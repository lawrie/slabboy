package slabboy

import spinal.core._
import spinal.lib._

case class PPU() extends Component {
  val io = new Bundle {
    val ili9320 = master(Ili9320())
    val tileOffset = out UInt(10 bits)
    val textureOffset = out UInt(13 bits)
    val startX = in UInt(8 bits)
    val startY = in UInt(8 bits)
    val tileData = in UInt(8 bits)
    val textureData = in Bits(8 bits)
    val diag = out Bits(8 bits)
  }

  val colors = Vec(Bits(16 bits), 4)
  colors(0) := 0x0020
  colors(1) := 0x00E0
  colors(2) := 0x01E0
  colors(3) := 0x03E0

  val x = Reg(UInt(8 bits))
  val y = Reg(UInt(8 bits))

  val lcd = Ili9320Ctrl()
  lcd.io.resetCursor := False
  io.diag := lcd.io.diag
  io.ili9320 <> lcd.io.ili9320

  val tileOffset = y(7 downto 2) @@ x(7 downto 2)
  io.tileOffset := tileOffset

  val textureOffset = io.tileData @@ y(7 downto 2)
  io.textureOffset := textureOffset

  val bit0 = io.textureData(x(2 downto 0))
  val bit1 = B"0"
  val color = (bit1 ## bit0).asUInt

  when (lcd.io.pixels.ready) {
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
}
   


   

  
  
  
  
