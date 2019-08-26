package slabboy

import spinal.core._
import spinal.lib._

case class PPU(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val ili9320 = master(Ili9320())
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

  val colors = Vec(Bits(16 bits), 4)
  colors(0) := 0x09a1
  colors(1) := 0x2b05
  colors(2) := 0x8541
  colors(3) := 0x95c1

  val x = Reg(UInt(8 bits)) init 104
  val y = Reg(UInt(8 bits)) init 48

  io.currentY := y

  val lcd = Ili9320Ctrl(sim)
  lcd.io.resetCursor := False
  io.diag := lcd.io.diag
  io.ili9320 <> lcd.io.ili9320

  val bitx = x(2 downto 0)
  val tile = Reg(UInt(8 bits))
  val texture0 = Reg(Bits(8 bits))
  val texture1 = Reg(Bits(8 bits))

  val bitCycle = Reg(UInt(2 bits))
  bitCycle := bitCycle + 1

  io.address := 0

  val bgScrnAddress = io.lcdControl(3) ? U(0x1c00) | U(0x1800)
  val windowAddress = io.lcdControl(6) ? U(0x1c00) | U(0x1800)
  val showWindow = io.lcdControl(5)
  val windowPriority = io.lcdControl(0)
  val textureAddress = io.lcdControl(4) ? U(0, 13 bits) | U(0x800, 13 bits)

  when (bitx === 7) {
    when (bitCycle === 0) {
      // Set address of next tile
      io.address := bgScrnAddress + (U"000" @@ y(7 downto 3) @@ x(7 downto 3))
    } elsewhen (bitCycle === 1) {
      // Save the tile number and set the address of first texture byte
      io.address := textureAddress + (U"0" @@ io.dataIn @@ y(2 downto 0) @@ U"0")
      tile := io.dataIn
    } elsewhen (bitCycle === 2) {
      // Save the first texture value and set the address of the second
      io.address := textureAddress + (U"0" @@ tile @@ y(2 downto 0) @@ U"1")
      texture0 := io.dataIn.asBits
    } elsewhen (bitCycle === 3) {
      // Save the second texture byte
      texture1 := io.dataIn.asBits
    }
  }

  val bit0 = texture0(7 - bitx)
  val bit1 = texture1(7 - bitx)
  val color = (bit1 ## bit0).asUInt

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

