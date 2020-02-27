package slabboy

import spinal.core._
import spinal.lib._

case class PPUUlx3s(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val oled_csn = out Bool
    val oled_resn = out Bool
    val oled_dc = out Bool
    val oled_mosi = out Bool
    val oled_clk = out Bool
    val address = out UInt(13 bits)
    val lcdControl = in Bits(8 bits)
    val startX = in UInt(8 bits)
    val startY = in UInt(8 bits)
    val windowX = in UInt(8 bits)
    val windowY = in UInt(8 bits)
    val bgPalette = in Bits(8 bits)
    val mode = out Bits(2 bits)
    val currentY = out UInt(8 bits)
    val dataIn = in UInt(8 bits)
    val diag = out Bits(8 bits)

    val cpuSelOam = in Bool
    val cpuAddr = in UInt(8 bits)
    val cpuDataOut = in Bits(8 bits)
    val cpuWr = in Bool
    val cpuDataIn = out Bits(8 bits)
  }

  val mode = Reg(Bits(2 bits)) init 0
  io.mode := mode

  val colors = Vec(Bits(16 bits), 4)
  colors(0) := 0x09a1
  colors(1) := 0x2b05
  colors(2) := 0x8541
  colors(3) := 0x95c1

  val x = Reg(UInt(8 bits)) init 0
  val y = Reg(UInt(8 bits)) init 0

  io.currentY := y

  val lcd = new ST7789(16000)
  io.oled_csn := lcd.io.oled_csn
  io.oled_resn := lcd.io.oled_resn
  io.oled_dc := lcd.io.oled_dc
  io.oled_mosi := lcd.io.oled_mosi
  io.oled_clk := lcd.io.oled_clk

  val tile = Reg(UInt(8 bits))
  val texture0 = Reg(Bits(8 bits))
  val texture1 = Reg(Bits(8 bits))

  val bitCycle = Reg(UInt(5 bits))
  bitCycle := bitCycle + 1

  io.address := 0

  val bgScrnAddress = io.lcdControl(3) ? U(0x1c00) | U(0x1800)
  val windowAddress = io.lcdControl(6) ? U(0x1c00) | U(0x1800)
  val showWindow = io.lcdControl(5)
  val windowPriority = io.lcdControl(0)
  val textureAddress = io.lcdControl(4) ? U(0, 13 bits) | U(0x800, 13 bits)
  val inWindow = showWindow && x >= io.windowX && y >= io.windowY
  val bgOn = io.lcdControl(0)
  val tileX = io.startX + x
  val tileY = io.startY + y
  val winTileX = x - io.windowX
  val winTileY = y - io.windowY
  val bitx = tileX(2 downto 0)

  val spriteAddr = Reg(UInt(11 bits))
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
  val spriteDValid = B"01"

  val oamAddr = io.cpuAddr

  val sprites = Sprites()
  sprites.io.size16 := io.lcdControl(2)
  sprites.io.index := spriteIndex
  sprites.io.x := x
  sprites.io.y := y
  spriteAddr := sprites.io.addr
  sprites.io.dValid := spriteDValid
  sprites.io.data := 0xff

  sprites.io.oamDi := io.cpuDataOut
  sprites.io.oamAddr := oamAddr
  sprites.io.oamWr := io.cpuWr && io.cpuSelOam
  io.cpuDataIn := sprites.io.oamDo

  io.diag := sprites.io.diag

  val spritePixelActive = sprites.io.pixelActive
  val spritePixelData = sprites.io.pixelData
  val spritePixelPrio = sprites.io.pixelPrio

  when (bitx === 7) {
    when (bitCycle === 0) {
      // Set address of next tile
      when (spritePixelActive) {
        io.address := U"00" @@ spriteAddr
      } elsewhen (inWindow) {
        io.address := windowAddress + (U"000" @@ winTileY(7 downto 3) @@ winTileX(7 downto 3))
      } otherwise {
        io.address := bgScrnAddress + (U"000" @@ tileY(7 downto 3) @@ tileX(7 downto 3))
      }
    } elsewhen (bitCycle === 1) {
      // Save the tile number and set the address of first texture byte
      io.address := textureAddress + (U"0" @@ io.dataIn @@ tileY(2 downto 0) @@ U"0")
      tile := io.dataIn
    } elsewhen (bitCycle === 2) {
      // Save the first texture value and set the address of the second
      io.address := textureAddress + (U"0" @@ tile @@ tileY(2 downto 0) @@ U"1")
      when (bgOn) {
        texture0 := io.dataIn.asBits
      } otherwise {
        texture0 := 0
      }
    } elsewhen (bitCycle === 3) {
      // Save the second texture byte
      when (bgOn) {
        texture1 := io.dataIn.asBits
      } otherwise {
        texture1 := 0
      }
    }
  }

  val bit0 = texture0(7 - bitx)
  val bit1 = texture1(7 - bitx)
  val color = (bit1 ## bit0).asUInt

  mode := (y > 143) ? B"01" | B"00" // No busy modes yet

  when (lcd.io.pixels.ready) {
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

  lcd.io.pixels.payload := colors(io.bgPalette(color*2, 2 bits).asUInt)  
  lcd.io.pixels.valid := (x < 160 && y < 144) && io.lcdControl(7)
}

case class Sprite() extends Component {
  val io = new Bundle {
    val index = in UInt(6 bits)
    val x = in UInt(8 bits)
    val y = in UInt(8 bits)
    val size16 = in Bool
    val ds = in Bits(2 bits)
    val data = in Bits(8 bits)
    val pixelActive = out Bool
    val pixelData = out Bits(2 bits)
    val addr = out UInt(11 bits)

    val oamWr = in Bool
    val oamAddr = in UInt(2 bits)
    val oamDi = in Bits(8 bits)
    val oamDo = out Bits(8 bits)

    val diag = out Bits(8 bits)
  }

  val xPos = Reg(UInt(8 bits))
  val yPos = Reg(UInt(8 bits))
  val tile = Reg(UInt(8 bits))
  val flags = Reg(Bits(8 bits))

  io.diag := tile.asBits

  val data0 = Reg(Bits(8 bits))
  val data1 = Reg(Bits(8 bits))

  val height = io.size16 ? U(16, 8 bits) | U(8, 8 bits)

  when (io.ds(0)) (data0 := io.data)
  when (io.ds(1)) (data1 := io.data)

  val yVisible = (io.y + 16 >= yPos && io.y + 16 < yPos + height)
  val xVisible = (io.x + 8 >= xPos && io.x < xPos)
  val visible = yVisible & xVisible
  
  val colN = io.x - xPos
  val col = flags(5) ? colN(2 downto 0) | ~colN(2 downto 0)

  io.pixelData := data1(col).asBits ## data0(col).asBits
  io.pixelActive := io.pixelData =/= 0 && visible

  val rowN = io.y - yPos
  val row = flags(6) ? ~rowN(3 downto 0) | rowN(3 downto 0)
  
  val addr8 = tile @@ row(2 downto 0)
  val addr16 = tile(7 downto 1) @@ row
  
  io.addr := io.size16 ? addr16 | addr8

  when (io.oamWr) {
    switch (io.oamAddr) {
      is(0) (yPos := io.oamDi.asUInt)
      is(1) (xPos := io.oamDi.asUInt)
      is(2) (tile := io.oamDi.asUInt)
      is(3) (flags := io.oamDi)
    }
  }

  switch (io.oamAddr) {
    is(0) (io.oamDo := yPos.asBits)
    is(1) (io.oamDo := xPos.asBits)
    is(2) (io.oamDo := tile.asBits)
    is(3) (io.oamDo := flags)
  }
}

case class Sprites() extends Component {
  val io = new Bundle {
    val size16 = in Bool
    val x = in UInt(8 bits)
    val y = in UInt(8 bits)
    val dValid = in Bits(2 bits)
    val data = in Bits(8 bits)

    val pixelActive = out Bool
    val pixelData = out Bits(2 bits)
    val pixelPrio = out Bool

    val addr = out UInt(11 bits)

    val index = in UInt(4 bits)

    val oamWr = in Bool
    val oamAddr = in UInt(8 bits)
    val oamDi = in Bits(8 bits)
    val oamDo = out Bits(8 bits)

    val diag = out Bits(8 bits)
  }

  val numSprites = 40

  val sprites = new Array[Sprite](numSprites)
  val spriteAddr = Vec(UInt(11 bits), numSprites)
  val spritePixelActive = Bits(numSprites bits)
  val spritePixelPrio = Bits(numSprites bits)
  val spritePixelData = Vec(Bits(2 bits), numSprites)
  val spriteIndexArray = Vec(UInt(6 bits), numSprites)
  val spriteOamDo = Vec(Bits(8 bits), numSprites)

  val prioIndex = spriteIndexArray(io.index.resized)

  io.addr := spriteAddr(prioIndex)

  // TODO: Replace by sort
  for(i <- 0 to numSprites - 1) {
    spriteIndexArray(i) := U(i, 6 bits)
  }

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

  io.oamDo := spriteOamDo(io.oamAddr(7 downto 2))

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

