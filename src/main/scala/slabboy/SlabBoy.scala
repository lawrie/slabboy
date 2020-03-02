package slabboy

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import java.io.FileInputStream

class SlabBoy extends Component {
  val io = new Bundle {
    val address = out UInt(16 bits)
    val dataIn = in UInt(8 bits)
    val dataOut = out UInt(8 bits)
    val en = out Bool
    val write = out Bool
    val halt = out Bool
  }

  val cpu = new Cpu(
    bootVector = 0x0000,
    spInit = 0xFFFE
  )

  io.address := cpu.io.address
  cpu.io.dataIn := io.dataIn
  io.dataOut := cpu.io.dataOut
  io.en := cpu.io.mreq
  io.write := cpu.io.write
  io.halt := cpu.io.halt
}

object Cpu {
  object Reg16 {
    val AF = 0
    val WZ = 1
    val BC = 2
    val DE = 3
    val HL = 4
    val SP = 5
    val PC = 6
  }

  object Reg8 {
    val A = 0; val F = 1
    val W = 2; val Z = 3
    val B = 4; val C = 5
    val D = 6; val E = 7
    val H = 8; val L = 9
    val SPH = 10; val SPL = 11
    val PCH = 12; val PCL = 13
    // auto calculate bits needed to represent register index
    def DataType = UInt(log2Up(PCL) bits)
  }

  object Flags {
    val C = 4
    val H = 5
    val N = 6
    val Z = 7
  }

  object AluOp extends SpinalEnum {
    val Nop, Add, Adc, Sub, Sbc, And, Xor, Or, Cp, Sub1, Sbc1,
      Inc, Dec, Cpl, Ccf, Scf, Swap, Add1, Adc1, Ei, Di,
      Rlca, Rrca, Rla, Rra, Bit, Set, Reset,
      Rlc, Rrc, Rl, Rr, Sla, Sra, Srl = newElement()
  }

  object AddrSrc extends SpinalEnum {
    val PC, HL, BC, DE, WZ, FFZ, FFC, SP, SP1 = newElement()
  }

  object AddrOp extends SpinalEnum {
    val Nop, Inc, Dec, Rst, ToPC, R8, HLR8 = newElement()
  }

  object Condition extends SpinalEnum {
    val Z, NZ, C, NC = newElement()
  }
}

class Cpu(bootVector: Int, spInit: Int) extends Component {
  import Cpu._

  val io = new Bundle {
    val address = out UInt(16 bits)
    val dataIn = in UInt(8 bits)
    val dataOut = out UInt(8 bits)
    val irq = in Bool
    val ack = out Bool
    val mreq = out Bool
    val write = out Bool
    val halt = out Bool
    val diag = out UInt(8 bits)
  }

  // count tStates
  val tCount = Reg(UInt(32 bits)) init 0

  val mreq = Reg(Bool) init(False)
  val write = Reg(Bool) init(False)
  io.mreq := mreq
  io.write := write

  // instruction register
  val ir = RegInit(U(0x00, 8 bits))

  // register file
  val registers16 = Vec(Reg(UInt(16 bits)), 7)
  // A, F, WZ, BC, DE, HL and T are all initialized to zero
  for (i <- (0 until 5)) {
    registers16(i).init(0)
  }
  // SP and PC have defined init values
  registers16(Reg16.SP).init(spInit)
  registers16(Reg16.PC).init(bootVector)

  // 8-bit register vector for easy access
  val registers8 = registers16.flatMap(
    reg16 => Seq(reg16(15 downto 8), reg16(7 downto 0))
  )

  // Led diagnostics
  io.diag := registers8(Reg8.SPL)

  val temp = Reg(UInt(8 bits)) init(0)
  io.dataOut := temp

  val opA = Reg(UInt(8 bits))
  val prefix = Reg(Bool) init False

  val mCycle = Reg(CpuDecoder.MCycleDataType) init(0)
  val writeCycle = Reg(Bool) init(False)
  val halt = Reg(Bool) init(False)
  io.halt := halt

  when (!halt) {
    tCount := tCount + 1
  }

  val decoder = new CpuDecoder
  decoder.io.mCycle := mCycle
  decoder.io.ir := ir
  decoder.io.flags := registers8(Reg8.F)
  decoder.io.prefix := prefix

  val alu = new CpuAlu
  alu.io.op := decoder.io.aluOp
  alu.io.flagsIn := registers8(Reg8.F)
  alu.io.operandA := opA
  alu.io.operandB := temp
  alu.io.ir := ir

  val ime = alu.io.ime

  switch(decoder.io.addrSrc) {
    is(AddrSrc.PC) { io.address := registers16(Reg16.PC) }
    is(AddrSrc.HL) { io.address := registers16(Reg16.HL) }
    is(AddrSrc.BC) { io.address := registers16(Reg16.BC) }
    is(AddrSrc.DE) { io.address := registers16(Reg16.DE) }
    is(AddrSrc.WZ) { io.address := registers16(Reg16.WZ) }
    is(AddrSrc.SP) { io.address := registers16(Reg16.SP) }
    is(AddrSrc.SP1) { io.address := registers16(Reg16.SP) - 1 }
    is(AddrSrc.FFZ) {
      io.address(15 downto 8) := 0xFF
      io.address(7 downto 0) := registers8(Reg8.Z)
    }
    is(AddrSrc.FFC) {
      io.address(15 downto 8) := 0xFF
      io.address(7 downto 0) := registers8(Reg8.C)
    }
  }

  io.ack := False

  val tCycleFsm = new StateMachine {
    val t1State: State = new State with EntryPoint {
      onEntry {
        writeCycle := decoder.io.memWrite
        when(!decoder.io.memWrite) {
          mreq := True
        }
      }
      whenIsActive {
        mreq := False
        goto(t2State)
      }
    }
    val t2State = new State {
      whenIsActive {
        when(decoder.io.memRead) {
          temp := io.dataIn
        } elsewhen (mCycle === 0) {
          ir := io.dataIn
        }

        goto(t3State)
      }
    }
    val t3State = new State {
      whenIsActive {
        when(writeCycle) {
          mreq := True
          write := True
        }

        opA := registers8(decoder.io.opA)

        when(decoder.io.loadOpB) {
          temp := registers8(decoder.io.opBSelect)
        }

        halt := decoder.io.nextHalt
        goto(t4State)
      }
    }
    val t4State = new State {
      whenIsActive {
        mreq := False
        write := False
        // Acknowledge interrupt if requested and not masked
        when (io.irq && ime) (io.ack := True)
        when (decoder.io.nextMCycle === 0) {
          prefix := decoder.io.nextPrefix
        }

        def doAddrOp(reg: UInt) {
          switch(decoder.io.addrOp) {
            is(AddrOp.Inc) { reg := reg + 1 }
            is(AddrOp.Dec) { reg := reg - 1 }
            is(AddrOp.Rst) { reg := (ir - 0xC7).resize(16) }
            is(AddrOp.ToPC) { registers16(Reg16.PC) := reg }
            is(AddrOp.R8)  { reg := reg + (temp.asSInt).resize(16).asUInt }
            is(AddrOp.HLR8)  { registers16(Reg16.HL) := reg + (temp.asSInt).resize(16).asUInt }
          }
        }

        switch(decoder.io.addrSrc) {
          is(AddrSrc.PC) { doAddrOp(registers16(Reg16.PC)) }
          is(AddrSrc.HL) { doAddrOp(registers16(Reg16.HL)) }
          is(AddrSrc.WZ) { doAddrOp(registers16(Reg16.WZ)) }
          is(AddrSrc.BC) { doAddrOp(registers16(Reg16.BC)) }
          is(AddrSrc.DE) { doAddrOp(registers16(Reg16.DE)) }
          is(AddrSrc.SP) { doAddrOp(registers16(Reg16.SP)) }
          is(AddrSrc.SP1) { doAddrOp(registers16(Reg16.SP)) }
          is(AddrSrc.FFZ) { }
        }

        when(decoder.io.store) {
          registers8(decoder.io.storeSelect) := alu.io.result
        }
        registers8(Reg8.F) := alu.io.flagsOut
        mCycle := decoder.io.nextMCycle
        when (!halt) {
          goto(t1State)
        }
      }
    }
  }
}

object CpuDecoder {
  import Cpu._

  case class MCycle(
    aluOp: SpinalEnumElement[AluOp.type] = AluOp.Nop,
    opA: Int = Reg8.A,
    opBSelect: Option[Int] = None,
    storeSelect: Option[Int] = None,
    memRead: Boolean = false,
    memWrite: Boolean = false,
    addrSrc: SpinalEnumElement[AddrSrc.type] = AddrSrc.PC,
    addrOp: SpinalEnumElement[AddrOp.type] = AddrOp.Inc,
    halt: Boolean = false,
    condition: Option[SpinalEnumElement[Condition.type]] = None,
    prefix:Boolean = false,
    condBreak: Boolean = false
  )

  // Simple fetch cycle
  def fetchCycle(aluOp: SpinalEnumElement[AluOp.type] = AluOp.Nop,
                 opBSelect: Option[Int] = None,
                 storeSelect: Option[Int] = None) = {
    MCycle(aluOp, Reg8.A, opBSelect, storeSelect)
  }

  // Fetch cycle with second Reg
  def fetchCycleReg(aluOp: SpinalEnumElement[AluOp.type] = AluOp.Nop,
                    opA: Int = Reg8.A,
                    opBSelect: Option[Int] = None,
                    storeSelect: Option[Int] = None) = {
    MCycle(aluOp, opA, opBSelect, storeSelect)
  }

  // Extra cycle with no memory access
  def extraCycle(aluOp: SpinalEnumElement[AluOp.type],
                 opA: Int,
                 opBSelect: Option[Int],
                 storeSelect: Option[Int]) = {
    MCycle(aluOp, opA, opBSelect, storeSelect, false, false, AddrSrc.HL, AddrOp.Nop)
  }

  // Extra cycle with address operation
  def extraCycle1(aluOp: SpinalEnumElement[AluOp.type],
                  opA: Int,
                  opBSelect: Option[Int],
                  storeSelect: Option[Int],
                  addrSrc: SpinalEnumElement[AddrSrc.type] = AddrSrc.SP,
                  addrOp: SpinalEnumElement[AddrOp.type] = AddrOp.Nop) = {
    MCycle(aluOp, opA, opBSelect, storeSelect, false, false, addrSrc, addrOp)
  }

  // Conditional cycle
  def condBreakCycle(storeSelect: Option[Int],
                     condition: Option[SpinalEnumElement[Condition.type]] = None,
                     addrSrc: SpinalEnumElement[AddrSrc.type] = AddrSrc.PC,
                     addrOp: SpinalEnumElement[AddrOp.type] = AddrOp.Nop) = {
    MCycle(AluOp.Nop, Reg8.A, None, storeSelect, true, false,
           addrSrc, addrOp, false, condition, false, true)
  }

  // Conditional extra cycle
  def condExtraCycle(aluOp: SpinalEnumElement[AluOp.type],
                     opA: Int,
                     opBSelect: Option[Int],
                     storeSelect: Option[Int],
                     condition: Option[SpinalEnumElement[Condition.type]] = None) = {
    MCycle(aluOp, opA, opBSelect, storeSelect, false, false,
           AddrSrc.PC, AddrOp.Nop, false, condition)
  }

  // Memory read cycle
  def memReadCycle(aluOp: SpinalEnumElement[AluOp.type],
                   storeSelect: Option[Int],
                   addrSrc: SpinalEnumElement[AddrSrc.type] = AddrSrc.PC,
                   addrOp: SpinalEnumElement[AddrOp.type] = AddrOp.Nop) = {
    MCycle(aluOp, Reg8.A, None, storeSelect, true, false, addrSrc, addrOp)
  }

  // Conditional memory read cycle
  def condMemReadCycle(aluOp: SpinalEnumElement[AluOp.type],
                       storeSelect: Option[Int],
                       addrSrc: SpinalEnumElement[AddrSrc.type] = AddrSrc.PC,
                       addrOp: SpinalEnumElement[AddrOp.type] = AddrOp.Nop,
                       condition: Option[SpinalEnumElement[Condition.type]] = None) = {
    MCycle(aluOp, Reg8.A, None, storeSelect, true, false, addrSrc, addrOp, false, condition)
  }

  // Memory write cycle
  def memWriteCycle(aluOp: SpinalEnumElement[AluOp.type],
                    opBSelect: Option[Int],
                    storeSelect: Option[Int],
                    addrSrc: SpinalEnumElement[AddrSrc.type] = AddrSrc.PC,
                    addrOp: SpinalEnumElement[AddrOp.type] = AddrOp.Nop) = {
    MCycle(aluOp, Reg8.A, opBSelect, storeSelect, false, true, addrSrc, addrOp)
  }

  // helper function for the regular op code pattern
  // used for the bulk of the arithmetic instructions
  def arithmetic8Bit(base: Int,
                     aluOp: SpinalEnumElement[AluOp.type]
                    ) : Seq[(Int, Seq[MCycle])] = {
    val store = if (aluOp == AluOp.Cp) { None } else { Some(Reg8.A) }
    Seq(
      (base + 0, Seq(fetchCycle(aluOp, Some(Reg8.B), store))),
      (base + 1, Seq(fetchCycle(aluOp, Some(Reg8.C), store))),
      (base + 2, Seq(fetchCycle(aluOp, Some(Reg8.D), store))),
      (base + 3, Seq(fetchCycle(aluOp, Some(Reg8.E), store))),
      (base + 4, Seq(fetchCycle(aluOp, Some(Reg8.H), store))),
      (base + 5, Seq(fetchCycle(aluOp, Some(Reg8.L), store))),
      (base + 6, Seq(fetchCycle(AluOp.Nop, None, None),
               memReadCycle(aluOp, store, addrSrc=AddrSrc.HL))),
      (base + 7, Seq(fetchCycle(aluOp, Some(Reg8.A), store)))
    )
  }

  // helper function for bit operations
  def bit8Bit(base: Seq[Int],
              aluOp: SpinalEnumElement[AluOp.type]
             ) : Seq[(Seq[Int], Seq[MCycle])] = {
    val noStore = (aluOp == AluOp.Bit)
    Seq(
      (base.map(_ + 0), Seq(fetchCycle(aluOp, Some(Reg8.B), if (noStore)  None else Some(Reg8.B)))),
      (base.map(_ + 1), Seq(fetchCycle(aluOp, Some(Reg8.C), if (noStore)  None else Some(Reg8.C)))),
      (base.map(_ + 2), Seq(fetchCycle(aluOp, Some(Reg8.D), if (noStore)  None else Some(Reg8.D)))),
      (base.map(_ + 3), Seq(fetchCycle(aluOp, Some(Reg8.E), if (noStore)  None else Some(Reg8.E)))),
      (base.map(_ + 4), Seq(fetchCycle(aluOp, Some(Reg8.H), if (noStore)  None else Some(Reg8.H)))),
      (base.map(_ + 5), Seq(fetchCycle(aluOp, Some(Reg8.L), if (noStore)  None else Some(Reg8.H)))),
      (base.map(_ + 6), Seq(fetchCycle(AluOp.Nop, None, None),
                            memReadCycle(aluOp, Some(Reg8.Z), addrSrc=AddrSrc.HL),
                            memWriteCycle(AluOp.Nop, Some(Reg8.Z), None, addrSrc=AddrSrc.HL))),
      (base.map(_ + 7), Seq(fetchCycle(aluOp, Some(Reg8.A), if (noStore)  None else Some(Reg8.A))))
    )
  }

  // helper function for the regular op code pattern
  // used for most of the 8-bit reg-to-reg LD instructions
  def load8BitRegToReg(base: Int, dest: Int) = {
    Seq(
      (base + 0, Seq(fetchCycle(AluOp.Nop, Some(Reg8.B), Some(dest)))),
      (base + 1, Seq(fetchCycle(AluOp.Nop, Some(Reg8.C), Some(dest)))),
      (base + 2, Seq(fetchCycle(AluOp.Nop, Some(Reg8.D), Some(dest)))),
      (base + 3, Seq(fetchCycle(AluOp.Nop, Some(Reg8.E), Some(dest)))),
      (base + 4, Seq(fetchCycle(AluOp.Nop, Some(Reg8.H), Some(dest)))),
      (base + 5, Seq(fetchCycle(AluOp.Nop, Some(Reg8.L), Some(dest)))),
      (base + 6, Seq(fetchCycle(AluOp.Nop, None, None),
               memReadCycle(AluOp.Nop, Some(dest), addrSrc=AddrSrc.HL))),
      (base + 7, Seq(fetchCycle(AluOp.Nop, Some(Reg8.A), Some(dest))))
    )
  }

  // Microcode for prefix operations
  val prefixMicrocode = 
    bit8Bit(Seq(0x00), AluOp.Rlc) ++
    bit8Bit(Seq(0x08), AluOp.Rrc) ++
    bit8Bit(Seq(0x10), AluOp.Rl) ++
    bit8Bit(Seq(0x18), AluOp.Rr) ++
    bit8Bit(Seq(0x20), AluOp.Sla) ++
    bit8Bit(Seq(0x28), AluOp.Sra) ++
    bit8Bit(Seq(0x30), AluOp.Swap) ++
    bit8Bit(Seq(0x38), AluOp.Srl) ++
    bit8Bit(Seq(0x40, 0x48, 0x50, 0x58, 0x60, 0x68, 0x70, 0x78), AluOp.Bit) ++
    bit8Bit(Seq(0x80, 0x88, 0x90, 0x98, 0xA0, 0xA8, 0xB0, 0xB8), AluOp.Reset) ++
    bit8Bit(Seq(0xC0, 0xC8, 0xD0, 0xD8, 0xE0, 0xE8, 0xF0), AluOp.Set)

  // Main microcode
  val Microcode = Seq(
    // nop
    (0x00, Seq(fetchCycle())),
    // stop - currently nop
    (0x10, Seq(fetchCycle())),
    // di
    (0xf3, Seq(fetchCycle(AluOp.Di))),
    // ei
    (0xfb, Seq(fetchCycle(AluOp.Ei))),
    // halt
    (0x76, Seq(MCycle(halt=true)))
  ) ++
  arithmetic8Bit(0x80, AluOp.Add) ++ arithmetic8Bit(0x88, AluOp.Adc) ++
  arithmetic8Bit(0x90, AluOp.Sub) ++ arithmetic8Bit(0x98, AluOp.Sbc) ++
  arithmetic8Bit(0xA0, AluOp.And) ++ arithmetic8Bit(0xA8, AluOp.Xor) ++
  arithmetic8Bit(0xB0, AluOp.Or) ++ arithmetic8Bit(0xB8, AluOp.Cp) ++
  load8BitRegToReg(0x40, Reg8.B) ++
  load8BitRegToReg(0x48, Reg8.C) ++
  load8BitRegToReg(0x50, Reg8.D) ++
  load8BitRegToReg(0x58, Reg8.E) ++
  load8BitRegToReg(0x60, Reg8.H) ++
  load8BitRegToReg(0x68, Reg8.L) ++
  load8BitRegToReg(0x78, Reg8.A) ++
  Seq(
    // inc B
    (0x04, Seq(fetchCycle(AluOp.Inc, Some(Reg8.B), Some(Reg8.B)))),
    // inc C
    (0x0C, Seq(fetchCycle(AluOp.Inc, Some(Reg8.C), Some(Reg8.C)))),
    // inc BC
    (0x03, Seq(fetchCycle(AluOp.Add1, Some(Reg8.C), Some(Reg8.C)),
               extraCycle(AluOp.Adc1, Reg8.A, Some(Reg8.B), Some(Reg8.B)))),
    // inc D
    (0x14, Seq(fetchCycle(AluOp.Inc, Some(Reg8.D), Some(Reg8.D)))),
    // inc E
    (0x1C, Seq(fetchCycle(AluOp.Inc, Some(Reg8.E), Some(Reg8.E)))),
    // inc DE
    (0x13, Seq(fetchCycle(AluOp.Add1, Some(Reg8.E), Some(Reg8.E)),
               extraCycle(AluOp.Adc1, Reg8.A, Some(Reg8.D), Some(Reg8.D)))),
    // inc H
    (0x24, Seq(fetchCycle(AluOp.Inc, Some(Reg8.H), Some(Reg8.H)))),
    // inc L
    (0x2C, Seq(fetchCycle(AluOp.Inc, Some(Reg8.L), Some(Reg8.L)))),
    // inc HL
    (0x23, Seq(fetchCycle(AluOp.Add1, Some(Reg8.L), Some(Reg8.L)),
               extraCycle(AluOp.Adc1, Reg8.A, Some(Reg8.H), Some(Reg8.H)))),
    // inc SP
    (0x33, Seq(fetchCycle(AluOp.Add1, Some(Reg8.SPL), Some(Reg8.SPL)),
               extraCycle(AluOp.Adc1, Reg8.A, Some(Reg8.SPH), Some(Reg8.SPH)))),
    // inc (HL)
    (0x34, Seq(fetchCycle(AluOp.Nop, None, None),
               memReadCycle(AluOp.Inc, Some(Reg8.Z), addrSrc=AddrSrc.HL),
               memWriteCycle(AluOp.Nop, Some(Reg8.Z), None, addrSrc=AddrSrc.HL))),
    // inc A
    (0x3C, Seq(fetchCycle(AluOp.Inc, Some(Reg8.A), Some(Reg8.A)))),
    // dec B
    (0x05, Seq(fetchCycle(AluOp.Dec, Some(Reg8.B), Some(Reg8.B)))),
    // dec C
    (0x0D, Seq(fetchCycle(AluOp.Dec, Some(Reg8.C), Some(Reg8.C)))),
    // dec BC
    (0x0B, Seq(fetchCycle(AluOp.Sub1, Some(Reg8.C), Some(Reg8.C)),
               extraCycle(AluOp.Sbc1, Reg8.A, Some(Reg8.B), Some(Reg8.B)))),
    // dec D
    (0x15, Seq(fetchCycle(AluOp.Dec, Some(Reg8.D), Some(Reg8.D)))),
    // dec E
    (0x1D, Seq(fetchCycle(AluOp.Dec, Some(Reg8.E), Some(Reg8.E)))),
    // dec DE
    (0x1B, Seq(fetchCycle(AluOp.Sub1, Some(Reg8.E), Some(Reg8.E)),
               extraCycle(AluOp.Sbc1, Reg8.A, Some(Reg8.D), Some(Reg8.D)))),
    // dec H
    (0x25, Seq(fetchCycle(AluOp.Dec, Some(Reg8.H), Some(Reg8.H)))),
    // dec L
    (0x2D, Seq(fetchCycle(AluOp.Dec, Some(Reg8.L), Some(Reg8.L)))),
    // dec HL
    (0x2B, Seq(fetchCycle(AluOp.Sub1, Some(Reg8.L), Some(Reg8.L)),
               extraCycle(AluOp.Sbc1, Reg8.A, Some(Reg8.H), Some(Reg8.H)))),
    // dec SP
    (0x3B, Seq(fetchCycle(AluOp.Sub1, Some(Reg8.SPL), Some(Reg8.SPL)),
               extraCycle(AluOp.Sbc1, Reg8.A, Some(Reg8.SPH), Some(Reg8.SPH)))),
    // dec (HL)
    (0x35, Seq(fetchCycle(AluOp.Nop, None, None),
               memReadCycle(AluOp.Dec, Some(Reg8.Z), addrSrc=AddrSrc.HL),
               memWriteCycle(AluOp.Nop, Some(Reg8.Z), None, addrSrc=AddrSrc.HL))),
    // dec A
    (0x3D, Seq(fetchCycle(AluOp.Dec, Some(Reg8.A), Some(Reg8.A)))),
    // rlca
    (0x07, Seq(fetchCycle(AluOp.Rlca, Some(Reg8.A), Some(Reg8.A)))),
    // rrca
    (0x0f, Seq(fetchCycle(AluOp.Rrca, Some(Reg8.A), Some(Reg8.A)))),
    // rla
    (0x17, Seq(fetchCycle(AluOp.Rla, Some(Reg8.A), Some(Reg8.A)))),
    // rra
    (0x1f, Seq(fetchCycle(AluOp.Rra, Some(Reg8.A), Some(Reg8.A)))),
    // scf
    (0x37, Seq(fetchCycle(AluOp.Scf))),
    // cpl
    (0x2F, Seq(fetchCycle(AluOp.Cpl, Some(Reg8.A), Some(Reg8.A)))),
    // ccf
    (0x3F, Seq(fetchCycle(AluOp.Ccf))),
    // cp d8
    (0xFE, Seq(fetchCycle(),
               memReadCycle(AluOp.Cp, None, addrOp=AddrOp.Inc))),
    // add a, d8
    (0xC6, Seq(fetchCycle(),
               memReadCycle(AluOp.Add, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // sub a, d8
    (0xD6, Seq(fetchCycle(),
               memReadCycle(AluOp.Sub, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // and a, d8
    (0xE6, Seq(fetchCycle(),
               memReadCycle(AluOp.And, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // or a, d8
    (0xF6, Seq(fetchCycle(),
               memReadCycle(AluOp.Or, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // adc a, d8
    (0xCE, Seq(fetchCycle(),
               memReadCycle(AluOp.Adc, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // sbc a, d8
    (0xDE, Seq(fetchCycle(),
               memReadCycle(AluOp.Sbc, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // xor d8
    (0xEE, Seq(fetchCycle(),
               memReadCycle(AluOp.Xor, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // add HL, BC
    (0x09, Seq(fetchCycleReg(AluOp.Add, Reg8.L, Some(Reg8.C), Some(Reg8.L)),
               extraCycle(AluOp.Adc, Reg8.H, Some(Reg8.B), Some(Reg8.H)))),
    // add HL, DE
    (0x19, Seq(fetchCycleReg(AluOp.Add, Reg8.L,Some(Reg8.E), Some(Reg8.L)),
               extraCycle(AluOp.Adc, Reg8.H, Some(Reg8.D), Some(Reg8.H)))),
    // add HL, HL
    (0x29, Seq(fetchCycleReg(AluOp.Add, Reg8.L, Some(Reg8.L), Some(Reg8.L)),
               extraCycle(AluOp.Adc, Reg8.H, Some(Reg8.H), Some(Reg8.H)))),
    // add HL, SP
    (0x39, Seq(fetchCycleReg(AluOp.Add, Reg8.L, Some(Reg8.SPL), Some(Reg8.L)),
               extraCycle(AluOp.Adc, Reg8.H, Some(Reg8.SPH), Some(Reg8.H)))),
    // ls sp, hl
    (0xF9, Seq(fetchCycleReg(AluOp.Nop, Reg8.L, None, Some(Reg8.L)),
               extraCycle(AluOp.Nop, Reg8.H, None, Some(Reg8.H)))),
    // ld B, d8
    (0x06, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.B), addrOp=AddrOp.Inc))),
    // ld C, d8
    (0x0E, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.C), addrOp=AddrOp.Inc))),
    // ld D, d8
    (0x16, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.D), addrOp=AddrOp.Inc))),
    // ld E, d8
    (0x1E, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.E), addrOp=AddrOp.Inc))),
    // ld H, d8
    (0x26, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.H), addrOp=AddrOp.Inc))),
    // ld L, d8
    (0x2E, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.L), addrOp=AddrOp.Inc))),
    // ld A, d8
    (0x3E, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrOp=AddrOp.Inc))),
    // ld (hl), b
    (0x70, Seq(fetchCycle(AluOp.Nop, Some(Reg8.B)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl), c
    (0x71, Seq(fetchCycle(AluOp.Nop, Some(Reg8.C)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl), d
    (0x72, Seq(fetchCycle(AluOp.Nop, Some(Reg8.D)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl), e
    (0x73, Seq(fetchCycle(AluOp.Nop, Some(Reg8.E)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl), h
    (0x74, Seq(fetchCycle(AluOp.Nop, Some(Reg8.H)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl), l
    (0x75, Seq(fetchCycle(AluOp.Nop, Some(Reg8.L)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl), a
    (0x77, Seq(fetchCycle(AluOp.Nop, Some(Reg8.A)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (bc), a
    (0x02, Seq(fetchCycle(AluOp.Nop, Some(Reg8.A)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.BC))),
    // ld (de), a
    (0x12, Seq(fetchCycle(AluOp.Nop, Some(Reg8.A)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.DE))),
    // ld a, (bc)
    (0x0A, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.BC))),
    // ld a, (de)
    (0x1A, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.DE))),
    // ld (hl), d8
    (0x36, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, None, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL))),
    // ld (hl+), a
    (0x22, Seq(fetchCycle(AluOp.Nop, Some(Reg8.A)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL, addrOp=AddrOp.Inc))),
    // ld (hl-), a
    (0x32, Seq(fetchCycle(AluOp.Nop, Some(Reg8.A)),
               memWriteCycle(AluOp.Nop, None, None, addrSrc=AddrSrc.HL, addrOp=AddrOp.Dec))),
    // ld a, (hl+)
    (0x2A, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.HL, addrOp=AddrOp.Inc))),
    // ld a, (hl-)
    (0x3A, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.HL, addrOp=AddrOp.Dec))),
    // ldh (a8), a
    (0xE0, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.A), None, addrSrc=AddrSrc.FFZ, addrOp=AddrOp.Nop))),
    // ldh a, (a8)
    (0xF0, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.FFZ, addrOp=AddrOp.Nop))),
    // ld (c), a
    (0xE2, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.A), None, addrSrc=AddrSrc.FFC, addrOp=AddrOp.Nop))),
    // ld a, (c)
    (0xF2, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.FFC, addrOp=AddrOp.Nop))),
    // ld (a16), a
    (0xEA, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.W), addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.A), None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.Nop))),
    // ld (a16), SP
    (0x08, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.W), addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.SPL), None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.SPH), None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.Nop))),
    // ldh a, (a16)
    (0xFA, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.W), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.WZ, addrOp=AddrOp.Nop))),
    // ld bc, d16
    (0x01, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop,Some(Reg8.C), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop,Some(Reg8.B), addrOp=AddrOp.Inc))),
    // ld de, d16
    (0x11, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop,Some(Reg8.E), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop,Some(Reg8.D), addrOp=AddrOp.Inc))),
    // ld hl, d16
    (0x21, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop,Some(Reg8.L), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop,Some(Reg8.H), addrOp=AddrOp.Inc))),
    // ld sp, d16
    (0x31, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop,Some(Reg8.SPL), addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop,Some(Reg8.SPH), addrOp=AddrOp.Inc))),
    // ret 
    (0xC9, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.PCL), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.PCH), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // reti 
    (0xD9, Seq(fetchCycle(AluOp.Ei),
               memReadCycle(AluOp.Nop, Some(Reg8.PCL), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.PCH), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // ret Z
    (0xC8, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.Z), addrOp=AddrOp.Nop),
               memReadCycle(AluOp.Nop, Some(Reg8.PCL), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.PCH), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // ret NZ
    (0xC0, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.NZ), addrOp=AddrOp.Nop),
               memReadCycle(AluOp.Nop, Some(Reg8.PCL), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.PCH), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // ret C
    (0xD8, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.C), addrOp=AddrOp.Nop),
               memReadCycle(AluOp.Nop, Some(Reg8.PCL), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.PCH), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // ret NC
    (0xD0, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.NC), addrOp=AddrOp.Nop),
               memReadCycle(AluOp.Nop, Some(Reg8.PCL), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.PCH), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // rst 00
    (0xC7, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 08
    (0xCF, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 10
    (0xD7, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 18
    (0xDF, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 20
    (0xE7, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 28
    (0xEF, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 30
    (0xF7, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // rst 38
    (0xFF, Seq(fetchCycle(),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.Rst))),
    // prefix
    (0xCB, Seq(MCycle(prefix=true))),
    // call nn
    (0xCD, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.W), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // call Z, nn
    (0xCC, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // call C, nn
    (0xDC, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.C), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.C), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // call NZ, nn
    (0xC4, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.NZ), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // call NC, nn
    (0xD4, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.NC), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCH), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.PCL), None, addrSrc=AddrSrc.SP1, addrOp=AddrOp.Dec),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // pop bc
    (0xC1, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.C), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.B), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // pop de
    (0xD1, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.E), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.D), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // pop hl
    (0xE1, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.L), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.H), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // pop af
    (0xF1, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.F), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.A), addrSrc=AddrSrc.SP, addrOp=AddrOp.Inc))),
    // push bc
    (0xC5, Seq(fetchCycle(),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.B), None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.C), None, addrSrc=AddrSrc.SP))),
    // push de
    (0xD5, Seq(fetchCycle(),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.D), None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.E), None, addrSrc=AddrSrc.SP))),
    // push hl
    (0xE5, Seq(fetchCycle(),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.H), None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.L), None, addrSrc=AddrSrc.SP))),
    // push af
    (0xF5, Seq(fetchCycle(),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.A), None, addrSrc=AddrSrc.SP, addrOp=AddrOp.Dec),
               memWriteCycle(AluOp.Nop, Some(Reg8.F), None, addrSrc=AddrSrc.SP))),
    // add sp, r8
    (0xE8, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, None, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.SP, addrOp=AddrOp.R8))),
    // ld hl, SP+r8
    (0xF8, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, None, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.SP, addrOp=AddrOp.HLR8))),
    // jr d8
    (0x18, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, None, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.R8))), 
    // jr z, d8
    (0x28, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.R8))), 
    // jr c, d8
    (0x38, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.C), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.R8))), 
    // jr nz, d8
    (0x20, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.NZ), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.R8))), 
    // jr nc, d8
    (0x30, Seq(fetchCycle(),
               condBreakCycle(None, condition=Some(Condition.NC), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.PC, addrOp=AddrOp.R8))), 
    // jp nz,a16
    (0xC2, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.NZ), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // jp a16
    (0xC3, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               memReadCycle(AluOp.Nop, Some(Reg8.W), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // jp z,a16
    (0xCA, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // jp nc,a16
    (0xD2, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.NC), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC))),
    // jp c,a16
    (0xDA, Seq(fetchCycle(),
               memReadCycle(AluOp.Nop, Some(Reg8.Z), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               condBreakCycle(Some(Reg8.W), condition=Some(Condition.C), addrSrc=AddrSrc.PC, addrOp=AddrOp.Inc),
               extraCycle1(AluOp.Nop, Reg8.A, None, None, addrSrc=AddrSrc.WZ, addrOp=AddrOp.ToPC)))
  )

  val DefaultCycle = Microcode(0)._2(0)

  val MaxMCycles = Microcode.map(code => code._2.length).reduceLeft(_ max _ )
  def MCycleDataType = UInt(log2Up(MaxMCycles) bits)
}

class CpuDecoder extends Component {
  import Cpu._
  import CpuDecoder._

  val io = new Bundle {
    val mCycle = in(MCycleDataType)
    val nextMCycle = out(MCycleDataType)
    val ir = in UInt(8 bits)
    val aluOp = out(AluOp())
    val opA = out(Reg8.DataType)
    val opBSelect = out(Reg8.DataType)
    val loadOpB = out Bool
    val storeSelect = out(Reg8.DataType)
    val store = out Bool
    val memRead = out Bool
    val memWrite = out Bool
    val addrSrc = out(AddrSrc())
    val addrOp = out(AddrOp())
    val nextHalt = out Bool
    val flags = in UInt(8 bits)
    val prefix = in Bool
    val nextPrefix = out Bool
  }

  def decodeCycle(cycle: MCycle, nextCycle: Option[MCycle]=None) = {
    if (cycle.aluOp != AluOp.Nop) io.aluOp := cycle.aluOp
    if (cycle.opA != Reg8.A) io.opA := cycle.opA
    cycle.opBSelect match {
      case Some(x) => {
        io.opBSelect := x
        io.loadOpB := True
      }
      case None =>
    }
    cycle.storeSelect match {
      case Some(x) => {
        io.storeSelect := x
        
        cycle.condition match {
          case Some(x) => {
            if (x == Condition.Z) {
              io.store := io.flags(Flags.Z)
            } else if (x == Condition.NZ) {
              io.store := ~io.flags(Flags.Z)
            } else if (x == Condition.C) {
              io.store := io.flags(Flags.C)
            } else if (x == Condition.NC) {
              io.store := ~io.flags(Flags.C)
            }
          }
          case None => {
            io.store := True
          }              
        }
      }
      case None => 
    }
    if (cycle.memRead) io.memRead := Bool(cycle.memRead)
    if (cycle.addrSrc != AddrSrc.PC) io.addrSrc := cycle.addrSrc
    if (cycle.addrOp != AddrOp.Inc) io.addrOp := cycle.addrOp
    if (cycle.halt) io.nextHalt := Bool(cycle.halt)
    if (cycle.prefix) io.nextPrefix := Bool(cycle.prefix)

    // some signals have to be set here for the next cycle
    nextCycle match {
      case Some(nCycle) => {
        io.memWrite := Bool(nCycle.memWrite)
      }
      case None => 
    }
  }

  def testOpCode(opCodes: Seq[Int]):Bool = {
    if (opCodes.length == 1) return (io.ir === opCodes(0))
    else return ((io.ir === opCodes(0)) || testOpCode(opCodes.tail))
  } 

  // default to most common options
  io.aluOp := AluOp.Nop
  io.opA := Reg8.A
  io.opBSelect := 0
  io.loadOpB := False
  io.nextMCycle := 0
  io.storeSelect := 0
  io.store := False
  io.memRead := False
  io.addrOp := AddrOp.Inc
  io.addrSrc := AddrSrc.PC
  io.nextHalt := False
  io.nextPrefix := False
  io.memWrite := False

  // decode microcode instructions
  when (io.prefix) {
    for(icode <- prefixMicrocode) {
      if (icode._2.length == 1) {
        when (testOpCode(icode._1)) {
          decodeCycle(icode._2(0))
        }
      } else {
        when(testOpCode(icode._1)) {
          for((cycle, i) <- icode._2.zipWithIndex) {
            when(io.mCycle === i) {
              if(i == icode._2.length - 1) {
                decodeCycle(cycle)
              } else {
                decodeCycle(cycle, Some(icode._2(i + 1)))
                io.nextMCycle := io.mCycle + 1
              }
            }
          }
        }
      }             
    }
  } otherwise {
    // track assigned op-codes to prevent repeats
    var assignedOpCodes = collection.mutable.HashMap[Int, Boolean]()
      .withDefaultValue(false)

    for(icode <- Microcode) {
      if (assignedOpCodes(icode._1)) {
        throw new RuntimeException(
          s"Op-code 0x${icode._1.toHexString} already assigned!")
      }
      assignedOpCodes(icode._1) = true
      if (icode._2.length > 1) {
        when(io.ir === icode._1) {
          for((cycle, i) <- icode._2.zipWithIndex) {
            when(io.mCycle === i) {
              if(i == icode._2.length - 1) {
                decodeCycle(cycle)
              } else {
                decodeCycle(cycle, Some(icode._2(i + 1)))
                if (cycle.condBreak) {
                  cycle.condition match {
                    case Some(x) => {
                      if (x == Condition.Z) {
                        when (io.flags(Flags.Z)) {
                          io.nextMCycle := io.mCycle + 1
                        } otherwise {
                          io.memWrite := False
                        }
                      } else if (x == Condition.NZ) {
                        when (~io.flags(Flags.Z)) {
                          io.nextMCycle := io.mCycle + 1
                        } otherwise {
                          io.memWrite := False
                        }
                      } else if (x == Condition.C) {
                        when (io.flags(Flags.C)) {
                          io.nextMCycle := io.mCycle + 1
                        } otherwise {
                          io.memWrite := False
                        }  
                      } else if (x == Condition.NC) {
                        when (~io.flags(Flags.C)) {
                          io.nextMCycle := io.mCycle + 1
                        } otherwise {
                          io.memWrite := False
                        }
                      }
                    }
                    case None =>
                  }
                } else { 
                  io.nextMCycle := io.mCycle + 1
                }
              }
            }
          }
        }
      } else {
        when(io.ir === icode._1) {
          decodeCycle(icode._2(0))
        }
      }
    }
  }
}

class CpuAlu extends Component {
  import Cpu.AluOp

  val io = new Bundle {
    val op = in(AluOp())
    val flagsIn = in UInt(8 bits)
    val flagsOut = out UInt(8 bits)
    val operandA = in UInt(8 bits)
    val operandB = in UInt(8 bits)
    val result = out UInt(8 bits)
    val ir = in UInt(8 bits)
    val ime = out Bool
  }

  val rIME = Reg(Bool) init True
  io.ime := rIME

  // use 9-bits internally so the carry bit is easily available
  val wideResult = UInt(9 bits)
  io.result := wideResult(7 downto 0)
  val wideOpA = io.operandA.resize(9 bits)
  val wideOpB = io.operandB.resize(9 bits)

  // grab carry bits
  val carry = wideResult(8)
  // Z80 has half-carry and half-borrow bits as well
  val halfCarry = (
    wideResult.asBits(4) &&
    wideResult.asBits(3 downto 0) === B(0, 4 bits)
  )
  val halfBorrow = (
    !wideResult.asBits(4) &&
    wideResult.asBits(3 downto 0) === B(0xF, 4 bits)
  )

  // by default, pass flags through
  io.flagsOut := io.flagsIn

  val saveCarry = Reg(Bool)

  // helper for optionally setting or resetting flags
  def setFlags(c: Bool, h: Bool, n: Bool) = {
    io.flagsOut(Cpu.Flags.C) := c
    io.flagsOut(Cpu.Flags.H) := h
    io.flagsOut(Cpu.Flags.N) := n
    io.flagsOut(Cpu.Flags.Z) := (wideResult(7 downto 0) === 0)
  }

  switch(io.op) {
    is(AluOp.Nop) {
      wideResult := wideOpB
    }
    is(AluOp.Add) {
      wideResult := wideOpA + wideOpB
      setFlags(carry, halfCarry, False)
    }
    is(AluOp.Add1) {
      wideResult := wideOpB + 1
      saveCarry := carry
    }
    is(AluOp.Adc) {
      wideResult := wideOpA + wideOpB + io.flagsIn(Cpu.Flags.C).asUInt
      setFlags(carry, halfCarry, False)
    }
    is(AluOp.Adc1) {
      wideResult := wideOpB + saveCarry.asUInt
    }
    is(AluOp.Sub) {
      wideResult := wideOpA - wideOpB
      setFlags(carry, halfBorrow, True)
    }
    is(AluOp.Sbc) {
      wideResult := wideOpA - wideOpB - io.flagsIn(Cpu.Flags.C).asUInt
      setFlags(carry, halfBorrow, True)
    }
    is(AluOp.Sub1) {
      wideResult := wideOpB - 1
      saveCarry := carry
    }
    is(AluOp.Sbc1) {
      wideResult := wideOpB - saveCarry.asUInt
    }
    is(AluOp.And) {
      wideResult := wideOpA & wideOpB
      setFlags(False, True, False)
    }
    is(AluOp.Xor) {
      wideResult := wideOpA ^ wideOpB
      setFlags(False, False, False)
    }
    is(AluOp.Or) {
      wideResult := wideOpA | wideOpB
      setFlags(False, False, False)
    }
    is(AluOp.Cp) {
      wideResult := wideOpA - wideOpB
      setFlags(carry, halfCarry, True)
    }
    is(AluOp.Inc) {
      wideResult := wideOpB + 1
      setFlags(io.flagsIn(Cpu.Flags.C), halfCarry, False)
    }
    is(AluOp.Dec) {
      wideResult := wideOpB - 1
      setFlags(io.flagsIn(Cpu.Flags.C), halfBorrow, True)
    }
    is(AluOp.Cpl) {
      wideResult := ~wideOpB
      io.flagsOut(Cpu.Flags.H) := True
      io.flagsOut(Cpu.Flags.N) := True
    }
    is(AluOp.Ccf) {
      wideResult := wideOpB
      io.flagsOut(Cpu.Flags.C) := ~io.flagsIn(Cpu.Flags.C)
      io.flagsOut(Cpu.Flags.H) := False
      io.flagsOut(Cpu.Flags.N) := False
    }
    is(AluOp.Scf) {
      wideResult := wideOpB
      io.flagsOut(Cpu.Flags.C) := True
      io.flagsOut(Cpu.Flags.H) := False
      io.flagsOut(Cpu.Flags.N) := False
    }
    is(AluOp.Swap) {
      wideResult := U"0" @@ wideOpA(3 downto 0) @@ wideOpA(7 downto 4)
      setFlags(False, False, False)
    }
    is(AluOp.Rlca) {
      wideResult := wideOpA(7 downto 0) @@ wideOpA(7)
      io.flagsOut(Cpu.Flags.C) := carry
      io.flagsOut(Cpu.Flags.H) := False
      io.flagsOut(Cpu.Flags.N) := False
      io.flagsOut(Cpu.Flags.Z) := False
    }
    is(AluOp.Rlc) {
      wideResult := wideOpB(7 downto 0) @@ wideOpB(7)
      setFlags(carry, False, False)
    }
    is(AluOp.Rrca) {
      wideResult := wideOpA(0).asUInt @@ wideOpA(0) @@ wideOpA(7 downto 1)
      io.flagsOut(Cpu.Flags.C) := carry
      io.flagsOut(Cpu.Flags.H) := False
      io.flagsOut(Cpu.Flags.N) := False
      io.flagsOut(Cpu.Flags.Z) := False
    }
    is(AluOp.Rrc) {
      wideResult := wideOpB(0).asUInt @@ wideOpB(0) @@ wideOpB(7 downto 1)
      setFlags(carry, False, False)
    }
    is(AluOp.Rla) {
      wideResult := wideOpA.rotateLeft(1)
      io.flagsOut(Cpu.Flags.C) := carry
      io.flagsOut(Cpu.Flags.H) := False
      io.flagsOut(Cpu.Flags.N) := False
      io.flagsOut(Cpu.Flags.Z) := False
    }
    is(AluOp.Rl) {
      wideResult := wideOpB.rotateLeft(1)
      setFlags(carry, False, False)
    }
    is(AluOp.Rra) {
      wideResult := wideOpA.rotateRight(1)
      io.flagsOut(Cpu.Flags.C) := carry
      io.flagsOut(Cpu.Flags.H) := False
      io.flagsOut(Cpu.Flags.N) := False
      io.flagsOut(Cpu.Flags.Z) := False
    }
    is(AluOp.Rr) {
      wideResult := wideOpB.rotateRight(1)
      setFlags(carry, False, False)
    }
    is(AluOp.Sla) {
      wideResult := wideOpB |<< 1
      setFlags(carry, False, False)
    }
    is(AluOp.Sra) {
      wideResult := wideOpB(0).asUInt @@ wideOpB(7) @@ wideOpB(7 downto 1)
      setFlags(carry, False, False)
    }
    is(AluOp.Srl) {
      wideResult := wideOpB(0).asUInt @@ U"0" @@ wideOpB(7 downto 1)
      setFlags(carry, False, False)
    }
    is(AluOp.Bit) {
      wideResult := 0
      io.flagsOut(Cpu.Flags.C) := io.flagsIn(Cpu.Flags.C)
      io.flagsOut(Cpu.Flags.H) := True
      io.flagsOut(Cpu.Flags.N) := False
      io.flagsOut(Cpu.Flags.Z) := ~io.operandB(io.ir(5 downto 3))
    }
    is(AluOp.Set) {
      wideResult := wideOpB | (U(1, 9 bits) |<< io.ir(5 downto 3))
      io.flagsOut := io.flagsIn
    }
    is(AluOp.Reset) {
      wideResult := wideOpB & ~(U(1, 9 bits) |<< io.ir(5 downto 3))
      io.flagsOut := io.flagsIn
    }
    is(AluOp.Ei) {
      wideResult := 0
      rIME := True
    }
    is(AluOp.Di) {
      wideResult := 0
      rIME := False
    }
  }
}

object TopLevelVerilog {
  def main(args: Array[String]) {
    SpinalConfig().generateVerilog(new SlabBoy)
  }
}

object BinTools {
  def initRam[T <: Data](ram: Mem[T], path: String, swapEndianness: Boolean = false): Unit ={
    val initContent = Array.fill[BigInt](ram.wordCount)(0)
    val readTmp = Array.fill[Byte](ram.width / 8)(0)
    val initFile = new FileInputStream(path)
    for ((e, i) <- initContent.zipWithIndex)
      if (initFile.read(readTmp) > 0)
        /* read() stores the data in reserved order */
        initContent(i) = BigInt(1, if (swapEndianness) readTmp else readTmp.reverse)
    ram.initBigInt(initContent)
  }
}

class SlabBoyTest extends Component {
  val io = new Bundle {
    val clk = in Bool
    val nReset = in Bool
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

  val coreArea = new ClockingArea(coreClockDomain) {
    val memSize = (14 * 1024) + 512

    val memory = Mem(UInt(8 bits), memSize)

    BinTools.initRam(memory, "sw/test.gb")

    val cpu = new Cpu(
      bootVector = 0x0000,
      spInit = 0xFFFE
    )

    val address = UInt(16 bits)
    val dataIn = Reg(UInt(8 bits))
    val dataOut = cpu.io.dataOut
    val enable = cpu.io.mreq
    val write = cpu.io.write

    // Reduce Gameboy 64kb memory down to 14.5k
    // ROM reduced to 4kb and RAM to 2kb
    // Video and high memory kept full size
    when (cpu.io.address >= 0xfe00) {
      address := cpu.io.address - 0xC600
    } elsewhen (cpu.io.address >=  0xC000) {
      address := cpu.io.address - 0x9000
    } elsewhen (cpu.io.address >= 0x8000) {
      address := cpu.io.address - 0x7000
    } otherwise {
      address := cpu.io.address
    }

    dataIn := memory(address.resized)
 
    when (write) {
      memory(address.resized) := dataOut
    }
 
    io.leds := cpu.io.diag 

    cpu.io.dataIn := dataIn
    io.led := !cpu.io.halt
  }
}

object SlabBoyTest {
  def main(args: Array[String]) {
    SpinalConfig().generateVerilog(new SlabBoyTest)
  }
}


