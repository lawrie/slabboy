package slabboy

import spinal.core._
import spinal.lib._

case class PPU(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val ili9320 = master(Ili9320())
    val address = out UInt(13 bits)
    val startX = in UInt(8 bits)
    val startY = in UInt(8 bits)
    val dataIn = in UInt(8 bits)
    val diag = out Bits(8 bits)
  }

  val colors = Vec(Bits(16 bits), 4)
  colors(0) := 0x0020
  colors(1) := 0x00E0
  colors(2) := 0x01E0
  colors(3) := 0x03E0

  val x = Reg(UInt(8 bits))
  val y = Reg(UInt(8 bits))

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

  when (bitx === 0) {
    when (bitCycle === 0) {
      // Set address of next tile
      io.address := (0x1800 + (y(7 downto 3) @@ x(7 downto 3))).resized
    } elsewhen (bitCycle === 1) {
      // Save the tile number and set the address of first texture byte
      io.address := (io.dataIn @@ y(2 downto 0) @@ U"0").resized
      tile := io.dataIn
    } elsewhen (bitCycle === 2) {
      // Save the first texture value and set the address of the second
      io.address := (tile @@ y(2 downto 0) @@ U"1").resized
      texture0 := io.dataIn.asBits
    } elsewhen (bitCycle === 3) {
      // Save the second texture byte
      texture1 := io.dataIn.asBits
    }
  }

  val bit0 = texture0(bitx)
  val bit1 = texture1(bitx)
  val color = (bit1 ## bit0).asUInt

  when (lcd.io.pixels.ready) {
    bitCycle := 0
    x := x + 1
    when (x === 159) {
      x := 0
      y := y + 1
      when (y === 143) {
        y := 0
      }
    }
  }

  lcd.io.pixels.payload := colors(color)  
  lcd.io.pixels.valid := True
}

