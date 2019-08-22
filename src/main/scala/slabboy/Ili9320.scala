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
  }

  val CD_DATA = B"1"
  val CD_CMD = B"0"

  val initSeq1Len = 48
  val initSeq2Len = 6
  val initSeq3Len = 3
  val initSeq4Len = 6
  val initSeq5Len = 54
  
  val cursorSeqLen = 3

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

  val state = Reg(UInt(4 bits)) init State.RESET
  val txReady = Reg(Bool) init False
  val sendingPixel = Reg(Bool) init False
  val delayTicks = Reg(UInt(24 bits)) init 0
  val initSeqCounter = Reg(UInt(log2Up(initSeq1Len) bits)) init 0
  val cursorSeqCounter = Reg(UInt(log2Up(cursorSeqLen) bits)) init 0

  val initSeq1 = Vec(Bits(9 bits), initSeq1Len)
  val initSeq2 = Vec(Bits(9 bits), initSeq2Len)
  val initSeq3 = Vec(Bits(9 bits), initSeq3Len)
  val initSeq4 = Vec(Bits(9 bits), initSeq4Len)
  val initSeq5 = Vec(Bits(9 bits), initSeq5Len)

  val cursorSeq = Vec(Bits(9 bits), cursorSeqLen)

  io.diag := B"00" ## sendingPixel ## txReady ## state

  initSeq1(0)  := CD_CMD ## B(0xe5, 8 bits)
  initSeq1(1)  := CD_DATA ## B(0x80, 8 bits)
  initSeq1(2)  := CD_DATA ## B(0x00, 8 bits)
  
  initSeq1(3)  := CD_CMD ## B(0x00, 8 bits)
  initSeq1(4)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(5)  := CD_DATA ## B(0x01, 8 bits)
  
  initSeq1(6)  := CD_CMD ## B(0x01, 8 bits)
  initSeq1(7)  := CD_DATA ## B(0x01, 8 bits)
  initSeq1(8)  := CD_DATA ## B(0x00, 8 bits)
  
  initSeq1(9)  := CD_CMD ## B(0x02, 8 bits)
  initSeq1(10)  := CD_DATA ## B(0x70, 8 bits)
  initSeq1(11)  := CD_DATA ## B(0x00, 8 bits)
  
  initSeq1(12)  := CD_CMD ## B(0x03, 8 bits)
  initSeq1(13)  := CD_DATA ## B(0x10, 8 bits)
  initSeq1(14)  := CD_DATA ## B(0x30, 8 bits)

  initSeq1(15)  := CD_CMD ## B(0x04, 8 bits)
  initSeq1(16)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(17)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(18)  := CD_CMD ## B(0x08, 8 bits)
  initSeq1(19)  := CD_DATA ## B(0x02, 8 bits)
  initSeq1(20)  := CD_DATA ## B(0x02, 8 bits)

  initSeq1(21)  := CD_CMD ## B(0x09, 8 bits)
  initSeq1(22)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(23)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(24)  := CD_CMD ## B(0x0A, 8 bits)
  initSeq1(25)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(26)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(27)  := CD_CMD ## B(0x0C, 8 bits)
  initSeq1(28)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(29)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(30)  := CD_CMD ## B(0x0D, 8 bits)
  initSeq1(31)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(32)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(33)  := CD_CMD ## B(0x0F, 8 bits)
  initSeq1(34)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(35)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(36)  := CD_CMD ## B(0x10, 8 bits)
  initSeq1(37)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(38)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(39)  := CD_CMD ## B(0x11, 8 bits)
  initSeq1(40)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(41)  := CD_DATA ## B(0x07, 8 bits)

  initSeq1(42)  := CD_CMD ## B(0x12, 8 bits)
  initSeq1(43)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(44)  := CD_DATA ## B(0x00, 8 bits)

  initSeq1(45)  := CD_CMD ## B(0x13, 8 bits)
  initSeq1(46)  := CD_DATA ## B(0x00, 8 bits)
  initSeq1(47)  := CD_DATA ## B(0x00, 8 bits)

  initSeq2(0)  := CD_CMD ## B(0x10, 8 bits)
  initSeq2(1)  := CD_DATA ## B(0x17, 8 bits)
  initSeq2(2)  := CD_DATA ## B(0xB0, 8 bits)

  initSeq2(3)  := CD_CMD ## B(0x11, 8 bits)
  initSeq2(4)  := CD_DATA ## B(0x00, 8 bits)
  initSeq2(5)  := CD_DATA ## B(0x07, 8 bits)

  initSeq3(0)  := CD_CMD ## B(0x12, 8 bits)
  initSeq3(1)  := CD_DATA ## B(0x01, 8 bits)
  initSeq3(2)  := CD_DATA ## B(0x3A, 8 bits)

  initSeq4(0)  := CD_CMD ## B(0x13, 8 bits)
  initSeq4(1)  := CD_DATA ## B(0x1A, 8 bits)
  initSeq4(2)  := CD_DATA ## B(0x00, 8 bits)

  initSeq4(3)  := CD_CMD ## B(0x29, 8 bits)
  initSeq4(4)  := CD_DATA ## B(0x00, 8 bits)
  initSeq4(5)  := CD_DATA ## B(0x0C, 8 bits)

  initSeq5(0)  := CD_CMD ## B(0x60, 8 bits)
  initSeq5(1)  := CD_DATA ## B(0xA7, 8 bits)
  initSeq5(2)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(3)  := CD_CMD ## B(0x61, 8 bits)
  initSeq5(4)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(5)  := CD_DATA ## B(0x01, 8 bits)

  initSeq5(6)  := CD_CMD ## B(0x6A, 8 bits)
  initSeq5(7)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(8)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(9)  := CD_CMD ## B(0x21, 8 bits)
  initSeq5(10)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(11)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(12)  := CD_CMD ## B(0x20, 8 bits)
  initSeq5(13)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(14)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(15)  := CD_CMD ## B(0x80, 8 bits)
  initSeq5(16)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(17)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(18)  := CD_CMD ## B(0x81, 8 bits)
  initSeq5(19)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(20)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(21)  := CD_CMD ## B(0x82, 8 bits)
  initSeq5(22)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(23)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(24)  := CD_CMD ## B(0x83, 8 bits)
  initSeq5(25)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(26)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(27)  := CD_CMD ## B(0x84, 8 bits)
  initSeq5(28)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(29)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(30)  := CD_CMD ## B(0x85, 8 bits)
  initSeq5(31)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(32)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(33)  := CD_CMD ## B(0x90, 8 bits)
  initSeq5(34)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(35)  := CD_DATA ## B(0x10, 8 bits)

  initSeq5(36)  := CD_CMD ## B(0x92, 8 bits)
  initSeq5(37)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(38)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(39)  := CD_CMD ## B(0x93, 8 bits)
  initSeq5(40)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(41)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(42)  := CD_CMD ## B(0x95, 8 bits)
  initSeq5(43)  := CD_DATA ## B(0x01, 8 bits)
  initSeq5(44)  := CD_DATA ## B(0x10, 8 bits)

  initSeq5(45)  := CD_CMD ## B(0x97, 8 bits)
  initSeq5(46)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(47)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(48)  := CD_CMD ## B(0x98, 8 bits)
  initSeq5(49)  := CD_DATA ## B(0x00, 8 bits)
  initSeq5(50)  := CD_DATA ## B(0x00, 8 bits)

  initSeq5(51)  := CD_CMD ## B(0x07, 8 bits)
  initSeq5(52)  := CD_DATA ## B(0x01, 8 bits)
  initSeq5(53)  := CD_DATA ## B(0x73, 8 bits)

  cursorSeq(0)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(1)  := CD_CMD ## B(0x00, 8 bits)
  cursorSeq(2)  := CD_CMD ## B(0x00, 8 bits)

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
            cmdData := initSeq1(initSeqCounter)(8)
            dout := initSeq1(initSeqCounter)(7 downto 0)
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
            dout := initSeq1(initSeqCounter)(7 downto 0)
            initSeqCounter := initSeqCounter + 1
            txReady := True
          }
        } otherwise {
          state := State.CURSOR
          delayTicks := ms120
          cursorSeqCounter := 0
        }
      }
      is(State.CURSOR) {
        when (cursorSeqCounter < cursorSeqLen) {
          when (!txReady) {
            cmdData := cursorSeq(cursorSeqCounter)(8)
            dout := cursorSeq(cursorSeqCounter)(7 downto 0)
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
    ctrl.io.pixels.payload := colors(columnCounter(4 downto 3))
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

/*case class TiledIli9320() extends Component{
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
*/
