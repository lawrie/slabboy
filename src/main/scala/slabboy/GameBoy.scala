package slabboy

import spinal.core._
import spinal.lib._

class GameBoy16(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val ili9320 = master(Ili9320())
    val led = out Bool
    val leds = out UInt(8 bits)
  }

  val rSB = 0xff01
  val rSC = 0xff02
  val rDIV = 0xff04
  val tIMAA = 0xff05
  val rTMA = 0xff06
  val rTAC = 0xff07

  val rAUD1SWEEP = 0xff10
  val rAUD1LEN = 0xff11
  val rAUD1ENV = 0xff12
  val rAUD1LOW = 0xff13
  val rAUD1HIGH = 0xff14

  val rAUD2LEN = 0xff16
  val rAUD2ENV = 0xff17
  val rAUD2LOW = 0xff18
  val rAUD2HIGH = 0xff19

  val rAUD3ENA = 0xff1a
  val rAUD3LEN = 0xff1b
  val rAUD3LEVEL = 0xff1c
  val rAUD3LOW = 0xff1d
  val rAUD3HIGH = 0xff1e

  val rAUDVOL = 0xff24
  val rAUDTERM = 0xff25
  val AUDENA = 0xff26

  val LCDC = 0xff40
  val STAT = 0xff41
  val SCY = 0xff42
  val SCX = 0xff43
  val LY = 0xff44
  val LYC = 0xff45
  val DMA = 0xff46
  val BGP = 0xff47
  val OBP0 = 0xff48
  val OBP1 = 0xff49

  val WY = 0xff4a
  val WX = 0xff4b

  val rIF = 0xff0f
  val rIE = 0xffff

  val memSize = (6 * 1024) + 512

  val memory = Mem(UInt(8 bits), memSize)
  val vidMem = Mem(UInt(8 bits), 8 * 1024)

  BinTools.initRam(memory, "sw/test.gb")

  val cpu = new Cpu(
    bootVector = 0x0100,
    spInit = 0xFFFF
  )

  val address = UInt(16 bits)
  val dataIn = Reg(UInt(8 bits))
  val ppuIn = Reg(UInt(8 bits))
  val dataOut = cpu.io.dataOut
  val enable = cpu.io.mreq
  val write = cpu.io.write

  val ppu = PPU(sim)
  io.ili9320 <> ppu.io.ili9320
  ppu.io.dataIn := ppuIn
    
  ppuIn := vidMem(ppu.io.address)

  val rLCDC = Reg(Bits(8 bits)) 
  val rSTAT = Reg(Bits(8 bits)) 
  val rSCY = Reg(UInt(8 bits)) 
  val rSCX = Reg(UInt(8 bits)) 
  val rLY = Reg(UInt(8 bits)) 
  val rLYC = Reg(UInt(8 bits)) 
  val rDMA = Reg(UInt(8 bits)) 
  val rBGP = Reg(Bits(8 bits)) 
  val rOBP0 = Reg(Bits(8 bits)) 
  val rOBP1 = Reg(Bits(8 bits)) 
  val rWY = Reg(UInt(8 bits)) 
  val rWX = Reg(UInt(8 bits)) 

  ppu.io.lcdControl := rLCDC
  ppu.io.startX := rSCX
  ppu.io.startY := rSCY
  ppu.io.windowX := rWX
  ppu.io.windowY := rWY
  ppu.io.bgPalette := rBGP

  // Reduce Gameboy 64kb memory down to 14.5k
  // ROM reduced to 4kb and RAM to 2kb
  // Video and high memory kept full size
  when (cpu.io.address >= 0xfe00) {
    address := cpu.io.address - 0xE600
  } elsewhen (cpu.io.address >=  0xC000) {
    address := cpu.io.address - 0xB000
  } otherwise {
    address := cpu.io.address
  }

  dataIn := memory(address.resized)
 
  when (write) {
    when (cpu.io.address >= 0x8000 && cpu.io.address < 0xA000) {
      vidMem((cpu.io.address - 0x8000).resized) := dataOut
    } otherwise {
      switch (cpu.io.address) {
        is(LCDC) (rLCDC := dataOut.asBits)
        is(STAT) (rSTAT := dataOut.asBits)
        is(SCY) (rSCY := dataOut)
        is(SCX) (rSCX := dataOut)
        is(LY) (rLY := dataOut)
        is(DMA) (rDMA := dataOut)
        is(BGP) (rBGP := dataOut.asBits)
        is(OBP0) (rOBP0 := dataOut.asBits)
        is(OBP1) (rOBP1 := dataOut.asBits)
        is(WY) (rWY := dataOut)
        is(WX) (rWX := dataOut)
      } 
      memory(address.resized) := dataOut
    }
  }

  io.leds := cpu.io.diag

  cpu.io.dataIn := dataIn
  io.led := !cpu.io.halt
}

class GameBoy extends Component {
  val io = new Bundle {
    val clk = in Bool
    val nReset = in Bool
    val ili9320 = master(Ili9320())
    val led = out Bool
    val leds = out UInt(8 bits)
  }

  val pll = SlabBoyPll()
  pll.clock_in := io.clk

  val coreClockDomain =
    ClockDomain(pll.clock_out, io.nReset,
                config = ClockDomainConfig(clockEdge = RISING,
                                           resetKind = ASYNC,
                                           resetActiveLevel = LOW))

  val coreClockingArea = new ClockingArea(coreClockDomain) {
    
    val gameboy = new GameBoy16()
    io.ili9320 <> gameboy.io.ili9320

    io.leds := gameboy.io.leds
    io.led := gameboy.io.led
  }
}

object GameBoy {
  def main(args: Array[String]) {
    SpinalConfig().generateVerilog(new GameBoy())
  }
}

object GameBoy16Sim {
  import spinal.core.sim._

  def main(args: Array[String]) {
    SimConfig.withWave.compile(new GameBoy16(true)).doSim{ dut =>
      dut.clockDomain.forkStimulus(100)

      dut.clockDomain.waitSampling(100000)
    }
  }
}
