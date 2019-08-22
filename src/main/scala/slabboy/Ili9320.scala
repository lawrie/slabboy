package slabboy

import spinal.core._
import spinal.lib._

case class Ili9320() extends Bundle with IMasterSlave {
  val nReset = Bool
  val cmdData = Bool
  val writeEdge = Bool
  val dout = Bits(8 bits)
  val cs = Bool

  override def asMaster(): Unit = {
    out(nReset, cmdData, writeEdge, dout, cs)
  }
}

case class Ili9320Ctrl() extends Component {
  val io = new Bundle {
    val ili9320 = master(Ili9320())
    val resetCursor = in Bool
    val pixels = slave Stream(Bits(16 bits))
    val diag = out Bits(8 bits)
  }

  val nReset = Reg(Bool)
  io.ili9320.nReset := nReset

  val cmdData = Reg(Bool)
  io.ili9320.cmdData := cmdData

  val writeEdge = Reg(Bool)
  io.ili9320.writeEdge := writeEdge

  val dout = Reg(Bits(8 bits))
  io.ili9320.dout := dout

  io.ili9320.cs := False

  object State {
    val RESET = 0
    val NOT_RESET = 1
    val WAKEUP = 2
    val INIT1 = 3
    val INIT2 = 4
    val INIT3 = 5
    val INIT4 = 6
    val INIT5 = 7
    val CURSOR = 8
    val READY = 9
    val HALT = 10
  }

  val ILI932X_START_OSC          = 0x00
  val ILI932X_DRIV_OUT_CTRL      = 0x01
  val ILI932X_DRIV_WAV_CTRL      = 0x02
  val ILI932X_ENTRY_MOD          = 0x03
  val ILI932X_RESIZE_CTRL        = 0x04
  val ILI932X_DISP_CTRL1         = 0x07
  val ILI932X_DISP_CTRL2         = 0x08
  val ILI932X_DISP_CTRL3         = 0x09
  val ILI932X_DISP_CTRL4         = 0x0A
  val ILI932X_RGB_DISP_IF_CTRL1  = 0x0C
  val ILI932X_FRM_MARKER_POS     = 0x0D
  val ILI932X_RGB_DISP_IF_CTRL2  = 0x0F
  val ILI932X_POW_CTRL1          = 0x10
  val ILI932X_POW_CTRL2          = 0x11
  val ILI932X_POW_CTRL3          = 0x12
  val ILI932X_POW_CTRL4          = 0x13
  val ILI932X_GRAM_HOR_AD        = 0x20
  val ILI932X_GRAM_VER_AD        = 0x21
  val ILI932X_RW_GRAM            = 0x22
  val ILI932X_POW_CTRL7          = 0x29
  val ILI932X_FRM_RATE_COL_CTRL  = 0x2B
  val ILI932X_GAMMA_CTRL1        = 0x30
  val ILI932X_GAMMA_CTRL2        = 0x31
  val ILI932X_GAMMA_CTRL3        = 0x32
  val ILI932X_GAMMA_CTRL4        = 0x35
  val ILI932X_GAMMA_CTRL5        = 0x36
  val ILI932X_GAMMA_CTRL6        = 0x37
  val ILI932X_GAMMA_CTRL7        = 0x38
  val ILI932X_GAMMA_CTRL8        = 0x39
  val ILI932X_GAMMA_CTRL9        = 0x3C
  val ILI932X_GAMMA_CTRL10       = 0x3D
  val ILI932X_HOR_START_AD       = 0x50
  val ILI932X_HOR_END_AD         = 0x51
  val ILI932X_VER_START_AD       = 0x52
  val ILI932X_VER_END_AD         = 0x53
  val ILI932X_GATE_SCAN_CTRL1    = 0x60
  val ILI932X_GATE_SCAN_CTRL2    = 0x61
  val ILI932X_GATE_SCAN_CTRL3    = 0x6A
  val ILI932X_PART_IMG1_DISP_POS = 0x80
  val ILI932X_PART_IMG1_START_AD = 0x81
  val ILI932X_PART_IMG1_END_AD   = 0x82
  val ILI932X_PART_IMG2_DISP_POS = 0x83
  val ILI932X_PART_IMG2_START_AD = 0x84
  val ILI932X_PART_IMG2_END_AD   = 0x85
  val ILI932X_PANEL_IF_CTRL1     = 0x90
  val ILI932X_PANEL_IF_CTRL2     = 0x92
  val ILI932X_PANEL_IF_CTRL3     = 0x93
  val ILI932X_PANEL_IF_CTRL4     = 0x95
  val ILI932X_PANEL_IF_CTRL5     = 0x97
  val ILI932X_PANEL_IF_CTRL6     = 0x98

  val COL_ADDR_SET    = B(0x2A, 8 bits)
  val PAGE_ADDR_SET   = B(0x2B, 8 bits)
  val MEMORY_WRITE    = B(0x2C, 8 bits)

  val CD_DATA = B"1"
  val CD_CMD = B"0"

  val clkFreq = 16000000
  val txClkFreq = 16000000
  val txClkDiv = (clkFreq / txClkFreq) - 1

  val secPerTick = (1.0 / txClkFreq)
  val ms120 = (0.120 / secPerTick).toInt
  val ms50  = (0.050 / secPerTick).toInt
  val ms10  = (0.005 / secPerTick).toInt
  val ms5   = (0.005 / secPerTick).toInt
  val ms500 = (0.500 / secPerTick).toInt

  // Simulation only
  //val ms120 = 120
  //val ms50  = 50
  //val ms10  = 10
  //val ms5   = 5
  //val ms500 = 500

  val initSeq1Len = 64
  val initSeq2Len = 8
  val initSeq3Len = 4
  val initSeq4Len = 8
  val initSeq5Len = 112
  
  val cursorSeqLen = 26

  val state = Reg(UInt(4 bits)) init State.RESET
  val txReady = Reg(Bool) init False
  val sendingPixel = Reg(Bool) init False
  val delayTicks = Reg(UInt(24 bits)) init 0
  val initSeqCounter = Reg(UInt(log2Up(initSeq5Len) bits)) init 0
  val cursorSeqCounter = Reg(UInt(log2Up(cursorSeqLen) bits)) init 0

  val initSeq1 = Vec(Bits(9 bits), initSeq1Len)
  val initSeq2 = Vec(Bits(9 bits), initSeq2Len)
  val initSeq3 = Vec(Bits(9 bits), initSeq3Len)
  val initSeq4 = Vec(Bits(9 bits), initSeq4Len)
  val initSeq5 = Vec(Bits(9 bits), initSeq5Len)

  val cursorSeq = Vec(Bits(9 bits), cursorSeqLen)

  io.diag := B"00" ## sendingPixel ## txReady ## state

  initSeq1(0)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(1)  := CD_CMD ## B(0xe5, 8 bits) // What is this?
  initSeq1(2)  := CD_DATA ## B(0x80, 8 bits)
  initSeq1(3)  := CD_DATA ## B(0x00, 8 bits)
  
  initSeq1(4)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(5)  := CD_CMD ## B(ILI932X_START_OSC, 8 bits)
  initSeq1(6)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(7)  := CD_DATA ## B(0x01, 8 bits)
  
  initSeq1(8)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(9)  := CD_CMD ## B(ILI932X_DRIV_OUT_CTRL, 8 bits)
  initSeq1(10)  := CD_DATA ## B(0x01, 8 bits)
  initSeq1(11)  := CD_DATA ## B(0x00, 8 bits)
  
  initSeq1(12)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(13)  := CD_CMD ## B(ILI932X_DRIV_WAV_CTRL, 8 bits)
  initSeq1(14)  := CD_DATA ## B(0x70, 8 bits)
  initSeq1(15)  := CD_DATA ## B(0x00, 8 bits)
  
  initSeq1(16)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(17)  := CD_CMD ## B(ILI932X_ENTRY_MOD, 8 bits)
  initSeq1(18)  := CD_DATA ## B(0x10, 8 bits)
  initSeq1(19)  := CD_DATA ## B(0x30, 8 bits)

  initSeq1(20)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(21)  := CD_CMD ## B(ILI932X_RESIZE_CTRL, 8 bits)
  initSeq1(22)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(23)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(24)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(25)  := CD_CMD ## B(ILI932X_DISP_CTRL2, 8 bits)
  initSeq1(26)  := CD_DATA ## B(0x02, 8 bits)
  initSeq1(27)  := CD_DATA ## B(0x02, 8 bits)

  initSeq1(28)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(29)  := CD_CMD ## B(ILI932X_DISP_CTRL3, 8 bits)
  initSeq1(30)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(31)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(32)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(33)  := CD_CMD ## B(ILI932X_DISP_CTRL4, 8 bits)
  initSeq1(34)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(35)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(36)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(37)  := CD_CMD ## B(ILI932X_RGB_DISP_IF_CTRL1, 8 bits)
  initSeq1(38)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(39)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(40)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(41)  := CD_CMD ## B(ILI932X_FRM_MARKER_POS, 8 bits)
  initSeq1(42)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(43)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(44)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(45)  := CD_CMD ## B(ILI932X_RGB_DISP_IF_CTRL2, 8 bits)
  initSeq1(46)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(47)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(48)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(49)  := CD_CMD ## B(ILI932X_POW_CTRL1, 8 bits)
  initSeq1(50)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(51)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(52)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(53)  := CD_CMD ## B(ILI932X_POW_CTRL2, 8 bits)
  initSeq1(54)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(55)  := CD_DATA ## B(0x07, 8 bits)

  initSeq1(56)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(57)  := CD_CMD ## B(ILI932X_POW_CTRL3, 8 bits)
  initSeq1(58)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(59)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(60)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(61)  := CD_CMD ## B(ILI932X_POW_CTRL4, 8 bits)
  initSeq1(62)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(63)  := CD_DATA ## B(0x00, 8 bits)

  initSeq2(0)  := CD_CMD ## B(0x00, 8 bits)
  initSeq2(1)  := CD_CMD ## B(ILI932X_POW_CTRL1, 8 bits)
  initSeq2(2)  := CD_DATA ## B(0x17, 8 bits)
  initSeq2(3)  := CD_DATA ## B(0xB0, 8 bits)

  initSeq2(4)  := CD_CMD ## B(0x00, 8 bits)
  initSeq2(5)  := CD_CMD ## B(ILI932X_POW_CTRL2, 8 bits)
  initSeq2(6)  := CD_DATA ## B(0x00, 8 bits)
  initSeq2(7)  := CD_DATA ## B(0x07, 8 bits)

  initSeq3(0)  := CD_CMD ## B(0x00, 8 bits)
  initSeq3(1)  := CD_CMD ## B(ILI932X_POW_CTRL3, 8 bits)
  initSeq3(2)  := CD_DATA ## B(0x01, 8 bits)
  initSeq3(3)  := CD_DATA ## B(0x3A, 8 bits)

  initSeq4(0)  := CD_CMD ## B(0x00, 8 bits)
  initSeq4(1)  := CD_CMD ## B(ILI932X_POW_CTRL3, 8 bits)
  initSeq4(2)  := CD_DATA ## B(0x1A, 8 bits)
  initSeq4(3)  := CD_DATA ## B(0x00, 8 bits)

  initSeq4(4)  := CD_CMD ## B(0x00, 8 bits)
  initSeq4(5)  := CD_CMD ## B(ILI932X_POW_CTRL7, 8 bits)
  initSeq4(6)  := CD_DATA ## B(0x00, 8 bits)
  initSeq4(7)  := CD_DATA ## B(0x0C, 8 bits)

  initSeq5(0)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(1)  := CD_CMD ## B(ILI932X_GAMMA_CTRL1, 8 bits)
  initSeq5(2)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(3)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(4)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(5)  := CD_CMD ## B(ILI932X_GAMMA_CTRL2, 8 bits)
  initSeq5(6)  := CD_DATA ## B(0x05, 8 bits)
  initSeq5(7)  := CD_DATA ## B(0x05, 8 bits)

  initSeq5(8)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(9)  := CD_CMD ## B(ILI932X_GAMMA_CTRL3, 8 bits)
  initSeq5(10)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(11)  := CD_DATA ## B(0x04, 8 bits)

  initSeq5(12)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(13)  := CD_CMD ## B(ILI932X_GAMMA_CTRL4, 8 bits)
  initSeq5(14)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(15)  := CD_DATA ## B(0x06, 8 bits)

  initSeq5(16)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(17)  := CD_CMD ## B(ILI932X_GAMMA_CTRL5, 8 bits)
  initSeq5(18)  := CD_DATA ## B(0x07, 8 bits)
  initSeq5(19)  := CD_DATA ## B(0x07, 8 bits)

  initSeq5(20)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(21)  := CD_CMD ## B(ILI932X_GAMMA_CTRL6, 8 bits)
  initSeq5(22)  := CD_DATA ## B(0x01, 8 bits)
  initSeq5(23)  := CD_DATA ## B(0x05, 8 bits)

  initSeq5(24)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(25)  := CD_CMD ## B(ILI932X_GAMMA_CTRL7, 8 bits)
  initSeq5(26)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(27)  := CD_DATA ## B(0x02, 8 bits)

  initSeq5(28)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(29)  := CD_CMD ## B(ILI932X_GAMMA_CTRL8, 8 bits)
  initSeq5(30)  := CD_DATA ## B(0x07, 8 bits)
  initSeq5(31)  := CD_DATA ## B(0x07, 8 bits)

  initSeq5(32)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(33)  := CD_CMD ## B(ILI932X_GAMMA_CTRL9, 8 bits)
  initSeq5(34)  := CD_DATA ## B(0x07, 8 bits)
  initSeq5(35)  := CD_DATA ## B(0x04, 8 bits)

  initSeq5(36)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(37)  := CD_CMD ## B(ILI932X_GAMMA_CTRL10, 8 bits)
  initSeq5(38)  := CD_DATA ## B(0x08, 8 bits)
  initSeq5(39)  := CD_DATA ## B(0x07, 8 bits)

  initSeq5(40)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(41)  := CD_CMD ## B(ILI932X_GATE_SCAN_CTRL1, 8 bits)
  initSeq5(42)  := CD_DATA ## B(0xA7, 8 bits)
  initSeq5(43)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(44)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(45)  := CD_CMD ## B(ILI932X_GATE_SCAN_CTRL2, 8 bits)
  initSeq5(46)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(47)  := CD_DATA ## B(0x01, 8 bits)

  initSeq5(48)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(49)  := CD_CMD ## B(ILI932X_GATE_SCAN_CTRL3, 8 bits)
  initSeq5(50)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(51)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(52)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(53)  := CD_CMD ## B(ILI932X_GRAM_VER_AD, 8 bits)
  initSeq5(54)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(55)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(56)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(57)  := CD_CMD ## B(ILI932X_GRAM_HOR_AD, 8 bits)
  initSeq5(58)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(59)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(60)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(61)  := CD_CMD ## B(ILI932X_PART_IMG1_DISP_POS, 8 bits)
  initSeq5(62)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(63)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(64)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(65)  := CD_CMD ## B(ILI932X_PART_IMG1_START_AD, 8 bits)
  initSeq5(66)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(67)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(68)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(69)  := CD_CMD ## B(ILI932X_PART_IMG1_END_AD, 8 bits)
  initSeq5(70)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(71)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(72)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(73)  := CD_CMD ## B(ILI932X_PART_IMG2_DISP_POS, 8 bits)
  initSeq5(74)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(75)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(76)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(77)  := CD_CMD ## B(ILI932X_PART_IMG2_START_AD, 8 bits)
  initSeq5(78)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(79)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(80)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(81)  := CD_CMD ## B(ILI932X_PART_IMG2_END_AD, 8 bits)
  initSeq5(82)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(83)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(84)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(85)  := CD_CMD ## B(ILI932X_PANEL_IF_CTRL1, 8 bits)
  initSeq5(86)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(87)  := CD_DATA ## B(0x10, 8 bits)

  initSeq5(88)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(89)  := CD_CMD ## B(ILI932X_PANEL_IF_CTRL2, 8 bits)
  initSeq5(90)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(91)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(92)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(93)  := CD_CMD ## B(ILI932X_PANEL_IF_CTRL3, 8 bits)
  initSeq5(94)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(95)  := CD_DATA ## B(0x03, 8 bits)

  initSeq5(96)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(97)  := CD_CMD ## B(ILI932X_PANEL_IF_CTRL4, 8 bits)
  initSeq5(98)  := CD_DATA ## B(0x01, 8 bits)
  initSeq5(99)  := CD_DATA ## B(0x10, 8 bits)

  initSeq5(100)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(101)  := CD_CMD ## B(ILI932X_PANEL_IF_CTRL5, 8 bits)
  initSeq5(102)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(103)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(104)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(105)  := CD_CMD ## B(ILI932X_PANEL_IF_CTRL6, 8 bits)
  initSeq5(106)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(107)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(108)  := CD_CMD ## B(0x00, 8 bits)
  initSeq5(109)  := CD_CMD ## B(ILI932X_DISP_CTRL1, 8 bits) // Turn display on
  initSeq5(110)  := CD_DATA ## B(0x01, 8 bits)
  initSeq5(111)  := CD_DATA ## B(0x73, 8 bits)

  cursorSeq(0)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(1)  := CD_CMD ## COL_ADDR_SET
  cursorSeq(2)  := CD_DATA ## B(0x00, 8 bits)
  cursorSeq(3)  := CD_DATA ## B(0x00, 8 bits)

  cursorSeq(4)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(5)  := CD_CMD ## PAGE_ADDR_SET
  cursorSeq(6)  := CD_DATA ## B(0x00, 8 bits)
  cursorSeq(7)  := CD_DATA ## B(0x00, 8 bits)

  cursorSeq(8)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(9)  := CD_CMD ## B(ILI932X_HOR_START_AD, 8 bits)
  cursorSeq(10)  := CD_DATA ## B(0x00, 8 bits)
  cursorSeq(11)  := CD_DATA ## B(0x00, 8 bits)

  cursorSeq(12)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(13)  := CD_CMD ## B(ILI932X_HOR_END_AD, 8 bits)
  cursorSeq(14)  := CD_DATA ## B(0x00, 8 bits)
  cursorSeq(15)  := CD_DATA ## B(0x3F, 8 bits)

  cursorSeq(16)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(17)  := CD_CMD ## B(ILI932X_VER_START_AD, 8 bits)
  cursorSeq(18)  := CD_DATA ## B(0x00, 8 bits)
  cursorSeq(19)  := CD_DATA ## B(0x00, 8 bits)

  cursorSeq(20)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(21)  := CD_CMD ## B(ILI932X_VER_END_AD, 8 bits)
  cursorSeq(22)  := CD_DATA ## B(0x00, 8 bits)
  cursorSeq(23)  := CD_DATA ## B(0xEF, 8 bits)

  cursorSeq(24)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(25)  := CD_CMD ## MEMORY_WRITE

  io.pixels.ready := (state === State.READY) && !sendingPixel && !txReady

  when(!txReady) {
    writeEdge := False
  } otherwise {
    writeEdge := True
    txReady := False
  }

  when (delayTicks =/= 0) {
    delayTicks := delayTicks - 1
  } otherwise {
    switch(state) {
      is(State.RESET) {
        nReset := False
        dout := 0
        writeEdge := False
        cmdData := False
        delayTicks := ms10
        state := State.NOT_RESET
      }
      is(State.NOT_RESET) {
        nReset := True;
        state := State.WAKEUP
        delayTicks := ms120
      }
      is(State.WAKEUP) {
        when (!txReady) {
          cmdData := False
          dout := 0x01
          txReady := True
          initSeqCounter := 0
          state := State.INIT1
          delayTicks := ms120
        }
      }
      is(State.INIT1) {
        when (initSeqCounter < initSeq1Len) {
          when (!txReady) {
            cmdData := initSeq1(initSeqCounter.resized)(8)
            dout := initSeq1(initSeqCounter.resized)(7 downto 0)
            initSeqCounter := initSeqCounter + 1
            txReady := True
          }
        } otherwise {
          state := State.INIT2
          delayTicks := ms50
          initSeqCounter := 0
        }
      }
      is(State.INIT2) {
        when (initSeqCounter < initSeq2Len) {
          when (!txReady) {
            cmdData := initSeq2(initSeqCounter.resized)(8)
            dout := initSeq2(initSeqCounter.resized)(7 downto 0)
            initSeqCounter := initSeqCounter + 1
            txReady := True
          }
        } otherwise {
          state := State.INIT3
          delayTicks := ms10
          initSeqCounter := 0
        }
      }
      is(State.INIT3) {
        when (initSeqCounter < initSeq3Len) {
          when (!txReady) {
            cmdData := initSeq3(initSeqCounter.resized)(8)
            dout := initSeq3(initSeqCounter.resized)(7 downto 0)
            initSeqCounter := initSeqCounter + 1
            txReady := True
          }
        } otherwise {
          state := State.INIT4
          delayTicks := ms10
          initSeqCounter := 0
        }
      }
      is(State.INIT4) {
        when (initSeqCounter < initSeq4Len) {
          when (!txReady) {
            cmdData := initSeq4(initSeqCounter.resized)(8)
            dout := initSeq4(initSeqCounter.resized)(7 downto 0)
            initSeqCounter := initSeqCounter + 1
            txReady := True
          }
        } otherwise {
          state := State.INIT5
          delayTicks := ms10
          initSeqCounter := 0
        }
      }
      is(State.INIT5) {
        when (initSeqCounter < initSeq5Len) {
          when (!txReady) {
            cmdData := initSeq5(initSeqCounter)(8)
            dout := initSeq5(initSeqCounter)(7 downto 0)
            initSeqCounter := initSeqCounter + 1
            txReady := True
          }
        } otherwise {
          //cmdData := True
          //dout := 0
          state := State.CURSOR
          delayTicks := ms120
          cursorSeqCounter := 0
          initSeqCounter := 0
        }
      }
      is(State.CURSOR) {
        when (cursorSeqCounter < cursorSeqLen) {
          when (!txReady) {
            cmdData := cursorSeq(cursorSeqCounter.resized)(8)
            dout := cursorSeq(cursorSeqCounter.resized)(7 downto 0)
            cursorSeqCounter := cursorSeqCounter + 1
            txReady := True
          }
        } otherwise {
          state := State.READY
          cursorSeqCounter := 0
        }
      }
      is(State.READY) {
        when (!sendingPixel) {
          when (io.resetCursor) {
            state := State.CURSOR
          } elsewhen (io.pixels.valid && !txReady) {
            cmdData := True
            dout := io.pixels.payload(15 downto 8)
            txReady := True
            sendingPixel := True
          }
        } otherwise {
          when (!txReady) {
            cmdData := True
            dout := io.pixels.payload(7 downto 0)
            txReady := True
            sendingPixel := False
          }
        }
      }
    }
  }
}

class StripedIli9320() extends Component{
  val io = new Bundle{
    val ili9320 = master(Ili9320()) addTag(crossClockDomain)
    val leds = out Bits(8 bits)
    val led = out Bool
    val clk = in Bool
    val nReset = in Bool
  }

  val pll = SlabBoyPll()
  pll.clock_in := io.clk

  val coreClockDomain = ClockDomain(pll.clock_out, io.nReset,
                                    config = ClockDomainConfig(clockEdge = RISING,
                                                               resetKind = ASYNC,
                                                               resetActiveLevel = LOW))

  val coreArea = new ClockingArea(coreClockDomain) {
    io.led := True

    val colors = Vec(Bits(16 bits), 4)
    colors(0) := 0xffff
    colors(1) := 0x001f
    colors(2) := 0x07e0
    colors(3) := 0xf800

    val rowCounter = Reg(UInt(8 bits)) init 0
    val columnCounter = Reg(UInt(9 bits)) init 0

    val ctrl = new Ili9320Ctrl()
    ctrl.io.resetCursor := False
    ctrl.io.pixels.valid := True
    ctrl.io.pixels.payload := 0x0000 // colors(columnCounter(4 downto 3))
    ctrl.io.ili9320 <> io.ili9320
    io.leds := ctrl.io.diag

    when (ctrl.io.pixels.ready) {
      columnCounter := columnCounter + 1
      when (columnCounter === 319) {
        columnCounter := 0
        rowCounter := rowCounter + 1
      
        when (rowCounter === 239) {
          rowCounter := 0
        }
      }
    }
  }
}

object StripedIli9320 {
  def main(args: Array[String]) {
    SpinalVerilog(new StripedIli9320())
  }
}

case class TiledIli9320() extends Component{
  val io = new Bundle{
    val ili9320 = master(Ili9320())
    val writeEnable = in Bool
    val texture = in Bool
    val offset = in UInt(12 bits)
    val value = in UInt(6 bits)
    val diag = out UInt(32 bits)
  }

  val tile = Mem(UInt(6 bits), 1200)
  val texture = Mem(UInt(3 bits), 4096)

  when (io.writeEnable && io.texture) {
    texture(io.offset) := io.value(2 downto 0)
  }

  when (io.writeEnable && !io.texture) {
    tile(io.offset(10 downto 0)) := io.value
  }

  val rowCounter = Reg(UInt(8 bits)) init 0
  val columnCounter = Reg(UInt(9 bits)) init 0

  val colors = Vec(Bits(16 bits), 8)
  colors(0) := 0x0000
  colors(1) := 0xf800
  colors(2) := 0x0770
  colors(3) := 0xff70
  colors(4) := 0x001f
  colors(5) := 0xf81f
  colors(6) := 0x07ff
  colors(7) := 0xffff

  val t = RegNext(tile((rowCounter(7 downto 3) * 40)  + columnCounter(8 downto 3)))
  val idx = t @@ rowCounter(2 downto 0) @@ columnCounter(2 downto 0)
  val color = RegNext(texture(idx))

  io.diag := 0

  val ctrl = new Ili9320Ctrl()
  ctrl.io.resetCursor := False
  ctrl.io.pixels.valid := True
  ctrl.io.pixels.payload := colors(color)
  ctrl.io.ili9320 <> io.ili9320

  when (ctrl.io.pixels.ready) {
    columnCounter := columnCounter + 1
    when (columnCounter === 319) {
      columnCounter := 0
      rowCounter := rowCounter + 1
      
      when (rowCounter === 239) {
        rowCounter := 0
      }
    }
  }
}
