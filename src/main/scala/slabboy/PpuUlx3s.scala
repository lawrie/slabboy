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
  }

  val mode = Reg(Bits(2 bits)) init 0
  io.mode := mode

  val colors = Vec(Bits(16 bits), 4)
  colors(0) := 0x09a1
  colors(1) := 0x2b05
  colors(2) := 0x8541
  colors(3) := 0x95c1

  val x = Reg(UInt(8 bits)) init 140
  val y = Reg(UInt(8 bits)) init 30

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

  val bitCycle = Reg(UInt(2 bits))
  bitCycle := bitCycle + 1

  io.address := 0

  val sprites = Reg(Vec(Bits(32 bits), 10))

  val bgScrnAddress = io.lcdControl(3) ? U(0x1c00) | U(0x1800)
  val windowAddress = io.lcdControl(6) ? U(0x1c00) | U(0x1800)
  val showWindow = io.lcdControl(5)
  val windowPriority = io.lcdControl(0)
  val textureAddress = io.lcdControl(4) ? U(0, 13 bits) | U(0x800, 13 bits)
  val inWindow = showWindow && x >= io.windowX && y >= io.windowY
  val bgOn = io.lcdControl(0)
  val tileX = io.startX + x
  val tileY = io.startY + y
  val bitx = tileX(2 downto 0)

  when (bitx === 7) {
    when (bitCycle === 0) {
      // Set address of next tile
      when (inWindow) {
        io.address := windowAddress + (U"000" @@ tileY(7 downto 3) @@ tileX(7 downto 3))
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

