package slabboy

import spinal.core._
import spinal.lib._

class GameBoy16(sim: Boolean = false) extends Component {
  val io = new Bundle {
    val ili9320 = master(Ili9320())
    val led = out Bool
    val leds = out UInt(8 bits)
  }

  val memSize = (6 * 1024) + 512

  val memory = Mem(UInt(8 bits), memSize)
  val vidMem = Mem(UInt(8 bits), 8 * 1024)

  BinTools.initRam(memory, "sw/test.gb")

  val cpu = new Cpu(
    bootVector = 0x0000,
    spInit = 0xFFFE
  )

  val address = UInt(16 bits)
  val dataIn = Reg(UInt(8 bits))
  val ppuIn = Reg(UInt(8 bits))
  val dataOut = cpu.io.dataOut
  val enable = cpu.io.mreq
  val write = cpu.io.write

  val ppu = PPU(sim)
  io.ili9320 <> ppu.io.ili9320
  ppu.io.startX := 0
  ppu.io.startY := 0
  ppu.io.dataIn := ppuIn
    
  ppuIn := vidMem(ppu.io.address)

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

