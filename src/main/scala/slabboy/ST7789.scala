package slabboy

import spinal.core._
import spinal.lib._

// Driver for ST7789 display
class ST7789(msCycles: Int = 25000) extends Component {
  val C_init_file = "st7789_init.mem"
  val C_init_size = 36
  //val C_init_file = "st7789_init_min.mem"
  //val C_init_size = 9
  val C_x_size = 160
  val C_y_size = 144
  val C_x_bits = log2Up(C_x_size)
  val C_y_bits = log2Up(C_y_size)

  val io = new Bundle {
    // Color of next pixel
    val pixels = slave Stream(Bits(16 bits))

    // The current x,y co-ordinates and flag for next pixel ready
    val x = out(Reg(UInt(C_x_bits bits))) init 0
    val y = out(Reg(UInt(C_y_bits bits))) init 0
    val next_pixel = out(Reg(Bool))

    // SPI pins
    val oled_csn = out Bool
    val oled_clk = out Bool
    val oled_mosi = out Bool
    val oled_dc = out Bool
    val oled_resn = out Bool

    // Diagnostics
    //val led = out(Bits(8 bits))
    //val gn = out(Bits(14 bits))
    //val gp = out(Bits(14 bits))
  }

  // Registers
  val resetCnt = Reg(UInt(23 bits)) init 0
  val initCnt = Reg(UInt(11 bits)) init 0
  val data = Reg(Bits(8 bits)) init 0
  val dc = Reg(Bool) init False
  val byteToggle = Reg(Bool) init False
  val init = Reg(Bool) init True
  val numArgs = Reg(UInt(5 bits)) init 0
  val delayCnt = Reg(UInt(25 bits)) init 0
  val arg = Reg(UInt(6 bits)) init 0
  val delaySet = Reg(Bool) init False
  val lastCmd = Reg(Bits(8 bits)) init 0

  // Diagnostics
  //io.led := lastCmd
  //io.gp := dc.asBits.resized
  //io.gn := 0

  // Set SPI pins
  io.oled_resn := resetCnt.msb // Reset set of first clock cycle
  io.oled_csn := True          // Backlight on 7-pin display
  io.oled_dc := dc             // False for commands, True for data
  io.oled_clk := initCnt(0)    // SPI clock is half system clock speed
  io.oled_mosi := data(7)      // Shift out data

  // Read in the initialisation sequence
  val C_oled_init = Mem(Bits(8 bits), wordCount=C_init_size)
  C_oled_init.initialContent = Tools.readmemh(C_init_file)

  // The next byte in the initialisation sequence
  val nextByte = C_oled_init(initCnt(10 downto 4).resized)

  io.pixels.ready := False

  // Do initialisation sequence, and then start sending pixels
  when (!resetCnt.msb) { 
    resetCnt := resetCnt + 1
  } elsewhen (delayCnt > 0) { // Delay
    delayCnt := delayCnt - 1
  } elsewhen (initCnt(10 downto 4) =/= C_init_size) {
    initCnt := initCnt + 1
    when (initCnt(3 downto 0) === 0) { // Start of byte
      when (init) { // Still initialsation
        dc := False
        arg := arg + 1
        when (arg === 0) { // New command
          data := 0
          lastCmd := nextByte
        } elsewhen (arg === 1) { // numArgs and delaySet
          numArgs := nextByte(4 downto 0).asUInt
          delaySet := nextByte(7)
          when (nextByte === 0) { // No args or delay
            arg := 0
          }
          data := lastCmd
        } elsewhen (arg <= numArgs+1) { // argument
          data := nextByte
          dc := True
          when (arg === numArgs + 1 && !delaySet) {
            arg := 0
          }
        } elsewhen (delaySet) { // delay
          when (nextByte =/= 0xff) {
            delayCnt := (nextByte.asUInt * msCycles).resized
          } otherwise {
            delayCnt := 500 * msCycles
          }
          data := 0
          delaySet := False
          arg := 0
        }
      } otherwise { // Send pixels and set x,y and next_pixel
        byteToggle := ~byteToggle
        dc := True
        data := byteToggle ? io.pixels.payload(7 downto 0) | io.pixels.payload(15 downto 8)
        when (!byteToggle) {
          io.next_pixel := True
          io.pixels.ready := True
          when (io.x === C_x_size-1) {
            io.x := 0
            when (io.y === C_y_size-1) {
              io.y := 0
            } otherwise {
              io.y := io.y + 1
            }
          } otherwise {
            io.x := io.x + 1
          }
        }
      } 
    } otherwise { // Shift out byte
      io.next_pixel := False
      when (!initCnt(0)) {
        data := data(6 downto 0) ## B"0"
      }
    }
  } otherwise { // Initialisation done. start sending pixels
    init := False
    initCnt(10 downto 4) := C_init_size - 1
  }
}

