package slabboy

import spinal.core._
import spinal.lib._

case class PPUUlx3s(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val lcdControl = in Bits(8 bits)
    val startX = in UInt(8 bits)
    val startY = in UInt(8 bits)
    val windowX = in UInt(8 bits)
    val windowY = in UInt(8 bits)
    val bgPalette = in Bits(8 bits)
    val dataIn = in UInt(8 bits)

    val mode = out Bits(2 bits)
    val address = out UInt(13 bits)

    val x = out UInt(8 bits)
    val y = out UInt(8 bits)
    val pixel = out Bits(16 bits)
    val nextPixel = in Bool

    val diag = out Bits(8 bits)

    val cpuSelOam = in Bool
    val cpuAddr = in UInt(8 bits)
    val cpuDataOut = in Bits(8 bits)
    val cpuWr = in Bool
    val cpuDataIn = out Bits(8 bits)
  }

  // Gameboy monochrome colors
  val colors = Vec(Bits(16 bits), 4)
  colors(0) := 0x09a1
  colors(1) := 0x2b05
  colors(2) := 0x8541
  colors(3) := 0x95c1

  val x = Reg(UInt(8 bits)) init 0
  val y = Reg(UInt(8 bits)) init 0

  io.x := x
  io.y := y

  io.mode := (y > 143) ? B"01" | B"00" // No busy modes yet

  val tile = Reg(UInt(8 bits))
  val texture0 = Reg(Bits(8 bits))
  val texture1 = Reg(Bits(8 bits))

  val bitCycle = Reg(UInt(5 bits))
  bitCycle := bitCycle + 1

  val bgScrnAddress = io.lcdControl(3) ? U(0x1c00) | U(0x1800)
  val windowAddress = io.lcdControl(6) ? U(0x1c00) | U(0x1800)
  val showWindow = io.lcdControl(5)
  val windowPriority = io.lcdControl(0)
  val textureAddress = io.lcdControl(4) ? U(0, 13 bits) | U(0x800, 13 bits)
  val inWindow = showWindow && x >= io.windowX && y >= io.windowY
  val bgOn = io.lcdControl(0)
  val tileX = x + io.startX
  val tileY = y + io.startY
  val winTileX = x - io.windowX
  val winTileY = y - io.windowY
  val bitx = tileX(2 downto 0)

  val hExtraTiles = Reg(UInt(2 bits))

  val mode3Offset = 16
  val oamLen = 80 // 8 clock cycles for 10 sprites
  val hExtra = (U"000" @@ hExtraTiles @@ U"000") + U(mode3Offset, 8 bits)
  val hBlank = x < oamLen || x >= oamLen + 160 + hExtra
  val vBlank = y >= 144
  //val spriteIndex = x(7 downto 4) - 5
  val spriteIndex = 0
  //val spriteDValid = (x(3 downto 0) === U(15, 4 bits) && ~hBlank && ~vBlank).asBits ## 
  //                   (x(3 downto 0) === U(7, 4 bits) && ~hBlank && ~vBlank).asBits
  val spriteDValid = Bits(2 bits)
  
  val oamAddr = io.cpuAddr

  val sprites = Sprites()
  sprites.io.size16 := io.lcdControl(2)
  sprites.io.index := spriteIndex
  sprites.io.x := x
  sprites.io.y := y
  sprites.io.dValid := spriteDValid

  sprites.io.oamDi := io.cpuDataOut
  sprites.io.oamAddr := oamAddr
  sprites.io.oamWr := io.cpuWr && io.cpuSelOam

  io.cpuDataIn := sprites.io.oamDo

  io.diag := sprites.io.diag

  val spriteAddr = sprites.io.addr
  val spritePixelActive = sprites.io.pixelActive
  val spritePixelData = sprites.io.pixelData
  val spritePixelPrio = sprites.io.pixelPrio

  spriteDValid := B"00"
  sprites.io.data := 0x00
  io.address := 0

  // Temporary code, not Gameboy-compatible
  when (bitCycle === 0) {
    // Set address of next tile
    when (inWindow) {
      io.address := windowAddress + (U"000" @@ winTileY(7 downto 3) @@ winTileX(7 downto 3))
    } otherwise {
      io.address := bgScrnAddress + (U"000" @@ tileY(7 downto 3) @@ tileX(7 downto 3))
    }
  } elsewhen (bitCycle === 1) {
    // Save the tile number and set the address of first texture byte
    when (inWindow) {
      io.address := textureAddress + (U"0" @@ io.dataIn @@ winTileY(2 downto 0) @@ U"0")
    } otherwise {
      io.address := textureAddress + (U"0" @@ io.dataIn @@ tileY(2 downto 0) @@ U"0")
    }
    tile := io.dataIn
  } elsewhen (bitCycle === 2) {
    // Save the first texture value and set the address of the second
    when (inWindow) {
      io.address := textureAddress + (U"0" @@ tile @@ winTileY(2 downto 0) @@ U"1")
    } otherwise {
      io.address := textureAddress + (U"0" @@ tile @@ tileY(2 downto 0) @@ U"1")
    }
    when (bgOn) {
      texture0 := io.dataIn.asBits
    } otherwise {
      texture0 := 0
    }
  } elsewhen (bitCycle === 3) {
    // Read the sprite textture
    io.address := U"0" @@ spriteAddr @@ U"0"
    // Save the second texture byte
    when (bgOn) {
      texture1 := io.dataIn.asBits
    } otherwise {
      texture1 := 0
    }
  } elsewhen (bitCycle === 4) {
    spriteDValid := B"10"
    sprites.io.data := io.dataIn.asBits
    io.address := U"0" @@ spriteAddr @@ U"1"
  } elsewhen (bitCycle === 5) {
    spriteDValid := B"01"
    sprites.io.data := io.dataIn.asBits
  }

  val bitX = inWindow ? (bitx - io.startX(2 downto 0)) | bitx
  val bit0 = texture0(7 - bitX)
  val bit1 = texture1(7 - bitX)
  val color = (spritePixelActive && !inWindow) ? spritePixelData.asUInt | (bit1 ## bit0).asUInt

  when (io.nextPixel) {
    bitCycle := 0
    x := x + 1
    when (x === 159) {
      x := 0
      y := y + 1
      when (y === 153) {
        y := 0
      }
    }
  }

  io.pixel := colors(io.bgPalette(color*2, 2 bits).asUInt)  
}

// Represents a single sprite
// Needs two cycles to get pixel color
case class Sprite() extends Component {
  val io = new Bundle {
    val index = in UInt(6 bits)      // The index into the sprite array
    val x = in UInt(8 bits)          // The current x position on the screen
    val y = in UInt(8 bits)          // The current y position on the screen
    val size16 = in Bool             // Global sprite size flag
    val ds = in Bits(2 bits)         // Data strobe for the two bits for each pixel
    val data = in Bits(8 bits)       // The byte from the texture
    val pixelActive = out Bool       // Indicates a hit, and the pixel is active
    val pixelData = out Bits(2 bits) // The 2-bit color of the pixel
    val addr = out UInt(11 bits)     // The address of the tile

    // Sprite read/write interface
    val oamWr = in Bool              // Indicates a write to sprite data
    val oamAddr = in UInt(2 bits)    // Selector for one of 4 fields
    val oamDi = in Bits(8 bits)      // The input sprite data for the field
    val oamDo = out Bits(8 bits)     // The output sprite data for the field

    val diag = out Bits(8 bits)
  }

  val yPos = Reg(UInt(8 bits))       // The y position of the sprite
  val xPos = Reg(UInt(8 bits))       // The x position of the sprite
  val tile = Reg(UInt(8 bits))       // The tile for the sprite
  val flags = Reg(Bits(8 bits))      // Sprite flags - only non-GBC currently used

  val data0 = Reg(Bits(8 bits))      // The first data byte of the texture
  val data1 = Reg(Bits(8 bits))      // The second data byte of the texture

  io.diag := yPos.asBits

  val height = io.size16 ? U(16, 8 bits) | U(8, 8 bits) // The height ofd the sprite (8 or 16)

  when (io.ds(0)) (data0 := io.data) // Latch texture data byte,
  when (io.ds(1)) (data1 := io.data) // corresponding to strobe bit

  val yVisible = (io.y + 16 >= yPos && io.y + 16 < yPos + height)  // Indicates match on y position
  val xVisible = (io.x + 8 >= xPos && io.x < xPos)                 // Indicates match on x position
  val visible = yVisible & xVisible                                // Set if sprite pixel visible
  
  val colN = io.x - xPos                                           // The column within texture data
  val col = flags(5) ? colN(2 downto 0) | ~colN(2 downto 0)        // Reverse for x-flip

  io.pixelData := data1(col).asBits ## data0(col).asBits           // The current pixel bit
  io.pixelActive := io.pixelData =/= 0 && visible                  // Active if not transparent

  val rowN = io.y - yPos                                           // The current row of the texture data
  val row = flags(6) ? ~rowN(3 downto 0) | rowN(3 downto 0)        // Reseverse for y-flip
  
  val addr8 = tile @@ row(2 downto 0)                              // Address for 8-bit sprite
  val addr16 = tile(7 downto 1) @@ row                             // Address for 16-bit stripe
  
  io.addr := io.size16 ? addr16 | addr8                            // Address to read texture data

  // Write to sprite data fields
  when (io.oamWr) {
    switch (io.oamAddr) {
      is(0) (yPos := io.oamDi.asUInt)
      is(1) (xPos := io.oamDi.asUInt)
      is(2) (tile := io.oamDi.asUInt)
      is(3) (flags := io.oamDi)
    }
  }

  // Read from sprite data fields
  switch (io.oamAddr) {
    is(0) (io.oamDo := yPos.asBits)
    is(1) (io.oamDo := xPos.asBits)
    is(2) (io.oamDo := tile.asBits)
    is(3) (io.oamDo := flags)
  }
}

// Represents the set 0f 40 sprites
// Each sprite is selected by its index
case class Sprites() extends Component {
  val io = new Bundle {
    val index = in UInt(4 bits)       // Index of sprite
    val size16 = in Bool              // Global sprite size
    val x = in UInt(8 bits)           // Current x position on screen
    val y = in UInt(8 bits)           // Current y position on screen
    val dValid = in Bits(2 bits)      // Data strobe for texture color bits
    val data = in Bits(8 bits)        // Texture data byte

    val pixelActive = out Bool        // Indicate if pixel is active for selected sprite
    val pixelData = out Bits(2 bits)  // Pixel color data for selected sprite
    val pixelPrio = out Bool          // Pixel priority ?

    val addr = out UInt(11 bits)      // Address of texrture data byte

    // Pixel read/wrire interface
    val oamWr = in Bool               // Indicates a write to pixel data
    val oamAddr = in UInt(8 bits)     // Selector for sprite and field
    val oamDi = in Bits(8 bits)       // The input sprite data for the field
    val oamDo = out Bits(8 bits)      // The output sprite data for the field

    val diag = out Bits(8 bits)
  }

  val numSprites = 40

  val sprites = new Array[Sprite](numSprites)           // Array of 40 sprites
  val spriteAddr = Vec(UInt(11 bits), numSprites)       // Texture address for each sprite
  val spritePixelActive = Bits(numSprites bits)         // Pixel Active for each sprite
  val spritePixelPrio = Bits(numSprites bits)           // Pixel priority for each sprite
  val spritePixelData = Vec(Bits(2 bits), numSprites)   // Pixel color for each sprite
  val spriteIndexArray = Vec(UInt(6 bits), numSprites)  // Index for each sprite, by priority
  val spriteOamDo = Vec(Bits(8 bits), numSprites)       // Output sprite field data for each sprite

  val prioIndex = spriteIndexArray(io.index.resized)    // The index, sorted by priority

  io.addr := spriteAddr(prioIndex)                      // The texture address for selected sprite

  // TODO: Replace by sort
  // For now, just use first 10 sprites
  for(i <- 0 to numSprites - 1) {
    spriteIndexArray(i) := U(i, 6 bits)
  }

  // Generate each sprite
  for(i <- 0 to numSprites - 1) {
    sprites(i) = Sprite()
    sprites(i).io.size16 := io.size16
    sprites(i).io.index := U(i, 6 bits)
    spriteAddr(i) := sprites(i).io.addr
    sprites(i).io.x := io.x
    sprites(i).io.y := io.y
    sprites(i).io.ds := io.dValid
    sprites(i).io.data := io.data
    spritePixelActive(i) := sprites(i).io.pixelActive
    spritePixelData(i) := sprites(i).io.pixelData

    sprites(i).io.oamWr := io.oamWr & io.oamAddr(7 downto 2) === U(i, 6 bits)
    sprites(i).io.oamAddr := io.oamAddr(1 downto 0)
    sprites(i).io.oamDi := io.oamDi
    spriteOamDo(i) := sprites(i).io.oamDo
  }

  io.diag := sprites(0).io.diag

  // The 10 selected sprites
  val spr0 = spriteIndexArray(0)
  val spr1 = spriteIndexArray(1)
  val spr2 = spriteIndexArray(2)
  val spr3 = spriteIndexArray(3)
  val spr4 = spriteIndexArray(4)
  val spr5 = spriteIndexArray(5)
  val spr6 = spriteIndexArray(6)
  val spr7 = spriteIndexArray(7)
  val spr8 = spriteIndexArray(8)
  val spr9 = spriteIndexArray(9)

  // The output data for the selected sprite
  io.oamDo := spriteOamDo(io.oamAddr(7 downto 2))

  // Indicates if any of the 10 sprites is active for this pixel
  io.pixelActive :=
    spritePixelActive(spr0) ||
    spritePixelActive(spr1) ||
    spritePixelActive(spr2) ||
    spritePixelActive(spr3) ||
    spritePixelActive(spr4) ||
    spritePixelActive(spr5) ||
    spritePixelActive(spr6) ||
    spritePixelActive(spr7) ||
    spritePixelActive(spr8) ||
    spritePixelActive(spr9)

  // Pixel data for the sprite with active pixel (else 0)
  io.pixelData :=
     spritePixelActive(spr0) ? spritePixelData(spr0) |
    (spritePixelActive(spr1) ? spritePixelData(spr1) |
    (spritePixelActive(spr2) ? spritePixelData(spr2) |
    (spritePixelActive(spr3) ? spritePixelData(spr3) |
    (spritePixelActive(spr4) ? spritePixelData(spr4) |
    (spritePixelActive(spr5) ? spritePixelData(spr5) |
    (spritePixelActive(spr6) ? spritePixelData(spr6) |
    (spritePixelActive(spr7) ? spritePixelData(spr7) |
    (spritePixelActive(spr8) ? spritePixelData(spr8) |
    (spritePixelActive(spr9) ? spritePixelData(spr9) |
    B"00")))))))))

  // Pixel priority for the sprite with active pixel (else False)
  io.pixelPrio :=
     spritePixelActive(spr0) ? spritePixelPrio(spr0) |
    (spritePixelActive(spr1) ? spritePixelPrio(spr1) |
    (spritePixelActive(spr2) ? spritePixelPrio(spr2) |
    (spritePixelActive(spr3) ? spritePixelPrio(spr3) |
    (spritePixelActive(spr4) ? spritePixelPrio(spr4) |
    (spritePixelActive(spr5) ? spritePixelPrio(spr5) |
    (spritePixelActive(spr6) ? spritePixelPrio(spr6) |
    (spritePixelActive(spr7) ? spritePixelPrio(spr7) |
    (spritePixelActive(spr8) ? spritePixelPrio(spr8) |
    (spritePixelActive(spr9) ? spritePixelPrio(spr9) |
    False)))))))))
}

