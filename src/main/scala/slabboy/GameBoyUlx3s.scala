package slabboy

import spinal.core._
import spinal.lib._

class GameBoy64Ulx3s(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val oled_csn = out Bool
    val oled_resn = out Bool
    val oled_dc = out Bool
    val oled_mosi = out Bool
    val oled_clk = out Bool 
    val led = out Bits(8 bits)
    val leds = out Bits(5 bits)
    val btn = in Bits(8 bits)
  }

  val JOYP = 0xff00
  val SB = 0xff01
  val SC = 0xff02
  val DIV = 0xff04
  val TIMA = 0xff05
  val TMA = 0xff06
  val TAC = 0xff07

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

  val memSize = (56 * 1024)

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

  val ppu = PPUUlx3s(sim)
  io.oled_csn := True
  io.oled_resn := ppu.io.oled_resn
  io.oled_dc := ppu.io.oled_dc
  io.oled_mosi := ppu.io.oled_mosi
  io.oled_clk := ppu.io.oled_clk
 
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
  val rJOYP = Reg(Bits(8 bits)) 
  val rButtonSelect = Reg(Bits(2 bits))
  val rDIV = Reg(UInt(8 bits)) 
  val rTIMA = Reg(UInt(8 bits)) 
  val rTMA = Reg(UInt(8 bits)) 
  val rTAC = Reg(UInt(8 bits)) 
  val IRQ = Reg(Bool)

  val timer = Reg(UInt(12 bits))

  timer := timer + 1

  when ((timer & 0x3FF) === 0) {
    rDIV := rDIV + 1
  }

  IRQ := False

  when (rTAC(2)) {
    switch (rTAC(1 downto 0)) {
      is(0) {
        when((timer & 0xFFF) === 0) {
          rTIMA := rTIMA + 1
        }
      }
      is(1) {
        when((timer & 0x3F) === 0) {
          rTIMA := rTIMA + 1
        }
      }
      is(2) {
        when((timer & 0xFF) === 0) {
          rTIMA := rTIMA + 1
        }
      }
      is(3) {
        when((timer & 0x3FF) === 0) {
          rTIMA := rTIMA + 1
        }
      }
    }

    when (rTIMA === 0xFF) {
      IRQ := True
      rTIMA := rTMA
    }
  }

  rJOYP:= !rButtonSelect(0) ? (B"0000"  ## io.btn(7 downto 4)) | (B"0000"  ## io.btn(3 downto 0))

  rLY := ppu.io.currentY

  ppu.io.lcdControl := rLCDC
  ppu.io.startX := rSCX
  ppu.io.startY := rSCY
  ppu.io.windowX := rWX
  ppu.io.windowY := rWY
  ppu.io.bgPalette := rBGP

  // The 8kb video memory is separate
  // The other 48kb includes ROM and RAM
  // Bank switching is not supported
  when (cpu.io.address >= 0xa000) {
    address := cpu.io.address - 0x2000
  } otherwise {
    address := cpu.io.address
  }

  dataIn := memory(address.resized)

  // Writes to memory
  when (write) {
    when (cpu.io.address >= 0x8000 && cpu.io.address < 0xA000) {
      vidMem((cpu.io.address - 0x8000).resized) := dataOut
    } otherwise {
      switch (cpu.io.address) {
        is(LCDC) (rLCDC := dataOut.asBits)
        is(STAT) (rSTAT := dataOut.asBits)
        is(SCY) (rSCY := dataOut)
        is(SCX) (rSCX := dataOut)
        is(LYC) (rLYC := dataOut)
        is(DMA) (rDMA := dataOut)
        is(BGP) (rBGP := dataOut.asBits)
        is(OBP0) (rOBP0 := dataOut.asBits)
        is(OBP1) (rOBP1 := dataOut.asBits)
        is(WY) (rWY := dataOut)
        is(WX) (rWX := dataOut)
        is(DIV) (rDIV := 0)
        is(TIMA) (rTIMA := dataOut)
        is(TMA) (rTMA := dataOut)
        is(TAC) (rTAC := dataOut)
        is(JOYP) (rButtonSelect := dataOut(5 downto 4).asBits)
      } 
      memory(address.resized) := dataOut
    }
  }

  // Reads from memory
  switch (cpu.io.address) {
    is(LCDC) (cpu.io.dataIn := rLCDC.asUInt & 0x7f) // Say LCD is off for now
    is(STAT) (cpu.io.dataIn := (rSTAT(7 downto 3) ## (rLY === rLYC) ## ppu.io.mode).asUInt)
    is(SCY) (cpu.io.dataIn := rSCY)
    is(SCX) (cpu.io.dataIn := rSCX)
    is(LY) (cpu.io.dataIn := rLY)
    is(LYC) (cpu.io.dataIn := rLYC)
    is(DMA) (cpu.io.dataIn := rDMA)
    is(BGP) (cpu.io.dataIn := rBGP.asUInt)
    is(OBP0) (cpu.io.dataIn := rOBP0.asUInt)
    is(OBP1) (cpu.io.dataIn := rOBP1.asUInt)
    is(WY) (cpu.io.dataIn := rWY)
    is(WX) (cpu.io.dataIn := rWX)
    is(DIV) (cpu.io.dataIn := rDIV)
    is(TIMA) (cpu.io.dataIn := rTIMA)
    is(TMA) (cpu.io.dataIn := rTMA)
    is(TAC) (cpu.io.dataIn := rTAC)
    is(JOYP) (cpu.io.dataIn := rJOYP.asUInt)
    default ( cpu.io.dataIn := dataIn)
  }
 
  io.led := rLCDC
  io.leds := io.btn(7).asBits ## io.btn(6).asBits ## io.btn(4).asBits ## io.btn(5).asBits ## B"0"

}

class GameBoyUlx3s extends Component {
  val io = new Bundle {
    val clk_25mhz = in Bool
    val oled_csn =out Bool
    val oled_resn = out Bool
    val oled_dc = out Bool
    val oled_mosi = out Bool
    val oled_clk = out Bool
    val led = out Bits(8 bits)
    val btn = in Bits(7 bits)
    val leds = out Bits(5 bits)
    val button = in Bits(3 bits)
  }.setName("")

  val pll = Ulx3sPll()
  pll.clkin := io.clk_25mhz

  val coreClockDomain =
    ClockDomain(pll.clkout0, io.btn(0),
                config = ClockDomainConfig(clockEdge = RISING,
                                           resetKind = ASYNC,
                                           resetActiveLevel = LOW))

  val coreClockingArea = new ClockingArea(coreClockDomain) {
    
    val gameboy = new GameBoy64Ulx3s()
    io.oled_csn := gameboy.io.oled_csn
    io.oled_resn := gameboy.io.oled_resn
    io.oled_dc := gameboy.io.oled_dc
    io.oled_mosi := gameboy.io.oled_mosi
    io.oled_clk := gameboy.io.oled_clk

    io.led := gameboy.io.led
    io.leds := gameboy.io.leds
  
    gameboy.io.btn := io.btn(3).asBits ## io.btn(4).asBits ## io.btn(6).asBits ## io.btn(5).asBits ## io.btn(2 downto 1) ## io.button(1 downto 0)
  }
}

object GameBoyUlx3s {
  def main(args: Array[String]) {
    print("Generation")
    SpinalConfig().generateVerilog(new GameBoyUlx3s())
  }
}

object GameBoy64Ulx3sSim {
  import spinal.core.sim._

  def main(args: Array[String]) {
    SimConfig.withWave.compile(new GameBoy64Ulx3s(true)).doSim{ dut =>
      dut.clockDomain.forkStimulus(100)

      dut.clockDomain.waitSampling(100000)
    }
  }
}
