package slabboy

import spinal.core._
import spinal.lib._

// Top-level board-independent Gameboy implementation
class GameBoySystem(sim: Boolean = false) extends Component {
  val io = new Bundle {
    // SPI LCD interface
    val oled_csn  = out Bool
    val oled_resn = out Bool
    val oled_dc   = out Bool
    val oled_mosi = out Bool
    val oled_clk  = out Bool

    // Diagnostics
    val led       = out Bits(8 bits)
    val leds      = out Bits(5 bits)

    // Buttons
    val btn       = in Bits(8 bits)
  }

  // Gameboy register mapping
  val JOYP       = 0xff00
  val SB         = 0xff01
  val SC         = 0xff02
  val DIV        = 0xff04
  val TIMA       = 0xff05
  val TMA        = 0xff06
  val TAC        = 0xff07

  val AUD1SWEEP  = 0xff10
  val AUD1LEN    = 0xff11
  val AUD1ENV    = 0xff12
  val AUD1LOW    = 0xff13
  val AUD1HIGH   = 0xff14

  val AUD2LEN    = 0xff16
  val AUD2ENV    = 0xff17
  val AUD2LOW    = 0xff18
  val AUD2HIGH   = 0xff19

  val AUD3ENA    = 0xff1a
  val AUD3LEN    = 0xff1b
  val AUD3LEVEL  = 0xff1c
  val AUD3LOW    = 0xff1d
  val AUD3HIGH   = 0xff1e

  val AUDVOL     = 0xff24
  val AUDTERM    = 0xff25
  val AUDENA     = 0xff26

  val LCDC       = 0xff40
  val STAT       = 0xff41
  val SCY        = 0xff42
  val SCX        = 0xff43
  val LY         = 0xff44
  val LYC        = 0xff45
  val DMA        = 0xff46
  val BGP        = 0xff47
  val OBP0       = 0xff48
  val OBP1       = 0xff49

  val WY         = 0xff4a
  val WX         = 0xff4b

  val IF        = 0xff0f
  val IE        = 0xffff

  // Gameboy registers
  val rLCDC = Reg(Bits(8 bits)) 
  val rSTAT = Reg(Bits(8 bits)) 
  val rSCY  = Reg(UInt(8 bits)) 
  val rSCX  = Reg(UInt(8 bits)) 
  val rLYC  = Reg(UInt(8 bits)) 
  val rBGP  = Reg(Bits(8 bits)) 
  val rOBP0 = Reg(Bits(8 bits)) 
  val rOBP1 = Reg(Bits(8 bits)) 
  val rWY   = Reg(UInt(8 bits)) 
  val rWX   = Reg(UInt(8 bits)) 
  val rJOYP = Reg(Bits(8 bits)) 
  val rDIV  = Reg(UInt(8 bits)) 
  val rTIMA = Reg(UInt(8 bits)) 
  val rTMA  = Reg(UInt(8 bits)) 
  val rTAC  = Reg(UInt(8 bits)) 
  val rIE   = Reg(Bits(5 bits))
  val rIF   = Reg(Bits(5 bits))

  // Buttons
  val rButtonSelect = Reg(Bits(2 bits))
  rJOYP:= !rButtonSelect(0) ? (B"0000"  ## ~io.btn(7 downto 4)) | (B"0000"  ## ~io.btn(3 downto 0))

  // CPU
  val cpu = new Cpu(
    bootVector = 0x0100,
    spInit = 0xFFFF
  )

  // IRQ: TODO
  val rIRQ = Reg(Bool)
  cpu.io.irq := rIRQ

  val rIV = Reg(Bits(8 bits)) // Interrupt vector

  // Request an interupt if any requested but not masked
  when ((rIF & rIE) =/= 0) (rIRQ := True)

  // Check if interrupt acknowledged
  when (cpu.io.ack) {
    rIRQ := False

    // Set vector and clear rIF bit
    when (rIF(0)) {
      rIV := 0x40
      rIF(0) := False
    } elsewhen (rIF(1)) {
      rIV := 0x48
      rIF(1) := False
    } elsewhen (rIF(2)) {
      rIV := 0x50
      rIF(2) := False
    } elsewhen (rIF(3)) {
      rIV := 0x58
      rIF(3) := False
    } elsewhen (rIF(4)) {
      rIV := 0x60
      rIF(4) := False
    }
  }

  // Memory mapping
  val romSize  = 32 * 1024
  val vramSize = 8 * 1024
  val eramSize = 8 * 1024
  val iramSize = 8 * 1024
  val hramSize = 8 * 1024

  val rom      = Mem(Bits(8 bits), romSize)   // Rom
  val vram     = Mem(Bits(8 bits), vramSize)  // Video memory
  val eram     = Mem(Bits(8 bits), eramSize)  // External RAM
  val iram     = Mem(Bits(8 bits), iramSize)  // Internal RAM
  val hram     = Mem(Bits(8 bits), hramSize)  // High RAM

  // Load the rom
  BinTools.initRam(rom, "sw/test.gb")

  // Data bus
  val romIn  = Reg(Bits(8 bits))
  val vramIn = Reg(Bits(8 bits))
  val eramIn = Reg(Bits(8 bits))
  val iramIn = Reg(Bits(8 bits))
  val hramIn = Reg(Bits(8 bits))
  val ppuIn  = Reg(Bits(8 bits))
  
  val ramOut = cpu.io.dataOut.asBits
  val write  = cpu.io.write

  // DMA for sprites
  val dmaActive = Reg(Bool)
  val dmaOffset = Reg(UInt(10 bits))
  val dmaPage   = Reg(UInt(5 bits))
  val dmaData   = Reg(Bits(8 bits))

  // Pixel Processing Unit
  val ppu = PPUUlx3s(sim)
  
  // Input from memory
  romIn  := rom(cpu.io.address(14 downto 0))
  vramIn := vram((cpu.io.address - 0xA000).resize(13))
  eramIn := eram((cpu.io.address - 0xA000).resize(13))
  iramIn := iram(dmaActive ? (dmaPage @@ dmaOffset(9 downto 2)) | (cpu.io.address - 0xC000).resize(13))
  hramIn := hram((cpu.io.address - 0xE000).resize(13))

  // vram input from PPU
  ppuIn := vram(ppu.io.address)

  // Current screen co-ordinates
  val x = ppu.io.x
  val y = ppu.io.y
  
  // Send relevant data to PPU
  ppu.io.dataIn     := ppuIn.asUInt
  ppu.io.lcdControl := rLCDC
  ppu.io.startX     := rSCX
  ppu.io.startY     := rSCY
  ppu.io.windowX    := (rWX < 7) ? U(0, 8 bits) | rWX - 7
  ppu.io.windowY    := rWY
  ppu.io.bgPalette  := rBGP
  ppu.io.cpuSelOam  := dmaActive | cpu.io.address(15 downto 8) === 0xFE
  ppu.io.cpuAddr    := dmaActive ? dmaOffset(9 downto 2) | cpu.io.address(7 downto 0)
  ppu.io.cpuWr      := write | (dmaActive && (dmaOffset(1 downto 0) === 2))
  ppu.io.cpuDataOut := dmaActive ? dmaData | ramOut

  // Writes to memory
  when (write) {
    when (cpu.io.address >= 0x8000 && cpu.io.address < 0xA000) {
      vram((cpu.io.address - 0x8000).resize(13)) := ramOut
    } elsewhen (cpu.io.address < 0xC000) {
      eram((cpu.io.address - 0xA000).resize(13)) := ramOut
    } elsewhen (cpu.io.address < 0xE000) {
      iram((cpu.io.address - 0xC000).resize(13)) := ramOut
    } elsewhen (cpu.io.address < 0xFDFF) {
      iram((cpu.io.address - 0xE000).resize(13)) := ramOut // Echo memory
    } otherwise {
      switch (cpu.io.address) {
        is(LCDC) (rLCDC := ramOut)
        is(STAT) (rSTAT := ramOut)
        is(SCY) (rSCY := ramOut.asUInt)
        is(SCX) (rSCX := ramOut.asUInt)
        is(LYC) (rLYC := ramOut.asUInt)
        is(BGP) (rBGP := ramOut)
        is(OBP0) (rOBP0 := ramOut)
        is(OBP1) (rOBP1 := ramOut)
        is(WY) (rWY := ramOut.asUInt)
        is(WX) (rWX := ramOut.asUInt)
        is(DIV) (rDIV := 0)
        is(TIMA) (rTIMA := ramOut.asUInt)
        is(TMA) (rTMA := ramOut.asUInt)
        is(TAC) (rTAC := ramOut.asUInt)
        is(JOYP) (rButtonSelect := ramOut(5 downto 4).asBits)
        is(IE) (rIE := ramOut(4 downto 0))
        is(IF) (rIF := ramOut(4 downto 0))
        is(DMA) {dmaActive := True; dmaOffset := 0; dmaPage := ramOut(4 downto 0).asUInt}
      } 
      hram((cpu.io.address - 0xE000).resize(13)) := ramOut
    }
  }

  // Reads from memory
  when (cpu.io.address < 0x8000) {
    cpu.io.dataIn := romIn.asUInt
  } elsewhen (cpu.io.address < 0xA000) {
    cpu.io.dataIn := vramIn.asUInt
  } elsewhen (cpu.io.address < 0xC000) {
    cpu.io.dataIn := eramIn.asUInt
  } elsewhen (cpu.io.address < 0xE000) {
    cpu.io.dataIn := iramIn.asUInt
  } elsewhen (cpu.io.address < 0xFDFF) {
    cpu.io.dataIn := iramIn.asUInt // Echo memory
  } otherwise {
    switch (cpu.io.address) {
      is(LCDC) (cpu.io.dataIn := rLCDC.asUInt & 0x7f) // Say LCD is off for now
      is(STAT) (cpu.io.dataIn := (rSTAT(7 downto 3) ## (y === rLYC) ## ppu.io.mode).asUInt)
      is(SCY) (cpu.io.dataIn := rSCY)
      is(SCX) (cpu.io.dataIn := rSCX)
      is(LY) (cpu.io.dataIn := y)
      is(LYC) (cpu.io.dataIn := rLYC)
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
      default (cpu.io.dataIn := hramIn.asUInt)
    }
  }
    
  // DMA for sprites
  when (dmaActive) {
    dmaOffset := dmaOffset + 1
    dmaData := iramIn
    when (dmaOffset === (160 * 4 - 1)) {
      dmaActive := False
    }
  }

  // LCD 
  val lcd = new ST7789(16000)
  io.oled_csn  := True
  io.oled_resn := lcd.io.oled_resn
  io.oled_dc := lcd.io.oled_dc
  io.oled_mosi := lcd.io.oled_mosi
  io.oled_clk := lcd.io.oled_clk

  lcd.io.pixels.payload := ppu.io.pixel
  lcd.io.pixels.valid := (x < 160 && y < 144) && rLCDC(7)
  ppu.io.nextPixel := lcd.io.pixels.ready

  // Diagnostics
  //io.led := ppu.io.diag
  io.leds := io.btn(7).asBits ## io.btn(6).asBits ## io.btn(4).asBits ## io.btn(5).asBits ## cpu.io.halt
  io.led := cpu.io.diag.asBits

  // Timer
  val timer = Reg(UInt(12 bits))
  timer := timer + 1

  when ((timer & 0x3FF) === 0) {
    rDIV := rDIV + 1
  }

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
      rIF(2) := True // Request timer interrupt
      rTIMA := rTMA
    }
  }
}

// Ulx3s implementation of Gameboy
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
    
    val gameboy = new GameBoySystem()
    io.oled_csn := gameboy.io.oled_csn
    io.oled_resn := gameboy.io.oled_resn
    io.oled_dc := gameboy.io.oled_dc
    io.oled_mosi := gameboy.io.oled_mosi
    io.oled_clk := gameboy.io.oled_clk

    io.led := gameboy.io.led
    io.leds := gameboy.io.leds
  
    gameboy.io.btn := io.btn(3).asBits ## io.btn(4).asBits ## io.btn(6).asBits ## 
                      io.btn(5).asBits ## io.btn(2 downto 1) ## io.button(1 downto 0)
  }
}

object GameBoyUlx3s {
  def main(args: Array[String]) {
    SpinalConfig().generateVerilog(new GameBoyUlx3s())
  }
}

object GameBoy64Ulx3sSim {
  import spinal.core.sim._

  def main(args: Array[String]) {
    SimConfig.withWave.compile(new GameBoySystem(true)).doSim{ dut =>
      dut.clockDomain.forkStimulus(100)

      dut.clockDomain.waitSampling(100000)
    }
  }
}
