// Generator : SpinalHDL v1.1.6    git head : 369ec039630c441c429b64ffc0a9ec31d21b7196
// Date      : 20/02/2020, 14:19:29
// Component : GameBoyUlx3s


`define AddrSrc_binary_sequancial_type [3:0]
`define AddrSrc_binary_sequancial_PC 4'b0000
`define AddrSrc_binary_sequancial_HL 4'b0001
`define AddrSrc_binary_sequancial_BC 4'b0010
`define AddrSrc_binary_sequancial_DE 4'b0011
`define AddrSrc_binary_sequancial_WZ 4'b0100
`define AddrSrc_binary_sequancial_FFZ 4'b0101
`define AddrSrc_binary_sequancial_FFC 4'b0110
`define AddrSrc_binary_sequancial_SP 4'b0111
`define AddrSrc_binary_sequancial_SP1 4'b1000

`define AluOp_binary_sequancial_type [5:0]
`define AluOp_binary_sequancial_Nop 6'b000000
`define AluOp_binary_sequancial_Add 6'b000001
`define AluOp_binary_sequancial_Adc 6'b000010
`define AluOp_binary_sequancial_Sub 6'b000011
`define AluOp_binary_sequancial_Sbc 6'b000100
`define AluOp_binary_sequancial_And_1 6'b000101
`define AluOp_binary_sequancial_Xor_1 6'b000110
`define AluOp_binary_sequancial_Or_1 6'b000111
`define AluOp_binary_sequancial_Cp 6'b001000
`define AluOp_binary_sequancial_Inc 6'b001001
`define AluOp_binary_sequancial_Dec 6'b001010
`define AluOp_binary_sequancial_Cpl 6'b001011
`define AluOp_binary_sequancial_Ccf 6'b001100
`define AluOp_binary_sequancial_Scf 6'b001101
`define AluOp_binary_sequancial_Incc 6'b001110
`define AluOp_binary_sequancial_Decc 6'b001111
`define AluOp_binary_sequancial_Swap 6'b010000
`define AluOp_binary_sequancial_Add1 6'b010001
`define AluOp_binary_sequancial_Adc1 6'b010010
`define AluOp_binary_sequancial_Rlca 6'b010011
`define AluOp_binary_sequancial_Rrca 6'b010100
`define AluOp_binary_sequancial_Rla 6'b010101
`define AluOp_binary_sequancial_Rra 6'b010110
`define AluOp_binary_sequancial_Bit_1 6'b010111
`define AluOp_binary_sequancial_Set 6'b011000
`define AluOp_binary_sequancial_Reset 6'b011001
`define AluOp_binary_sequancial_Rlc 6'b011010
`define AluOp_binary_sequancial_Rrc 6'b011011
`define AluOp_binary_sequancial_Rl 6'b011100
`define AluOp_binary_sequancial_Rr 6'b011101
`define AluOp_binary_sequancial_Sla_1 6'b011110
`define AluOp_binary_sequancial_Sra_1 6'b011111
`define AluOp_binary_sequancial_Srl_1 6'b100000

`define tCycleFsm_enumDefinition_binary_sequancial_type [2:0]
`define tCycleFsm_enumDefinition_binary_sequancial_boot 3'b000
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State 3'b001
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t2State 3'b010
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t3State 3'b011
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t4State 3'b100

`define AddrOp_binary_sequancial_type [2:0]
`define AddrOp_binary_sequancial_Nop 3'b000
`define AddrOp_binary_sequancial_Inc 3'b001
`define AddrOp_binary_sequancial_Dec 3'b010
`define AddrOp_binary_sequancial_Rst 3'b011
`define AddrOp_binary_sequancial_ToPC 3'b100
`define AddrOp_binary_sequancial_R8 3'b101
`define AddrOp_binary_sequancial_HLR8 3'b110

module CpuDecoder (
      input  [2:0] io_mCycle,
      output reg [2:0] io_nextMCycle,
      input  [7:0] io_ir,
      output reg `AluOp_binary_sequancial_type io_aluOp,
      output reg [3:0] io_opA,
      output reg [3:0] io_opBSelect,
      output reg  io_loadOpB,
      output reg [3:0] io_storeSelect,
      output reg  io_store,
      output reg  io_memRead,
      output reg  io_memWrite,
      output reg `AddrSrc_binary_sequancial_type io_addrSrc,
      output reg `AddrOp_binary_sequancial_type io_addrOp,
      output reg  io_nextHalt,
      input  [7:0] io_flags,
      input   io_prefix,
      output reg  io_nextPrefix);
  always @ (*) begin
    io_aluOp = `AluOp_binary_sequancial_Nop;
    io_opA = (4'b0000);
    io_opBSelect = (4'b0000);
    io_loadOpB = 1'b0;
    io_nextMCycle = (3'b000);
    io_storeSelect = (4'b0000);
    io_store = 1'b0;
    io_memRead = 1'b0;
    io_addrOp = `AddrOp_binary_sequancial_Inc;
    io_addrSrc = `AddrSrc_binary_sequancial_PC;
    io_nextHalt = 1'b0;
    io_nextPrefix = 1'b0;
    io_memWrite = 1'b0;
    if(io_prefix)begin
      if((io_ir == (8'b00000000)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000001)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000010)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000011)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000100)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000101)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Rlc;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00000111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlc;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001000)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001001)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001010)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001011)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001100)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001101)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Rrc;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00001111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrc;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010000)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010001)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010010)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010011)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010100)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010101)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Rl;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00010111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rl;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011000)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011001)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011010)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011011)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011100)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011101)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Rr;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00011111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rr;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100000)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100001)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100010)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100011)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100100)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100101)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sla_1;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00100111)))begin
        io_aluOp = `AluOp_binary_sequancial_Sla_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101000)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101001)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101010)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101011)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101100)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101101)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sra_1;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00101111)))begin
        io_aluOp = `AluOp_binary_sequancial_Sra_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110000)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110001)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110010)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110011)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110100)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110101)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Swap;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00110111)))begin
        io_aluOp = `AluOp_binary_sequancial_Swap;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111000)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111001)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111010)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111011)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111100)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111101)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Srl_1;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00111111)))begin
        io_aluOp = `AluOp_binary_sequancial_Srl_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000000)) || ((io_ir == (8'b01001000)) || ((io_ir == (8'b01010000)) || ((io_ir == (8'b01011000)) || ((io_ir == (8'b01100000)) || ((io_ir == (8'b01101000)) || ((io_ir == (8'b01110000)) || (io_ir == (8'b01111000))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000001)) || ((io_ir == (8'b01001001)) || ((io_ir == (8'b01010001)) || ((io_ir == (8'b01011001)) || ((io_ir == (8'b01100001)) || ((io_ir == (8'b01101001)) || ((io_ir == (8'b01110001)) || (io_ir == (8'b01111001))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000010)) || ((io_ir == (8'b01001010)) || ((io_ir == (8'b01010010)) || ((io_ir == (8'b01011010)) || ((io_ir == (8'b01100010)) || ((io_ir == (8'b01101010)) || ((io_ir == (8'b01110010)) || (io_ir == (8'b01111010))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000011)) || ((io_ir == (8'b01001011)) || ((io_ir == (8'b01010011)) || ((io_ir == (8'b01011011)) || ((io_ir == (8'b01100011)) || ((io_ir == (8'b01101011)) || ((io_ir == (8'b01110011)) || (io_ir == (8'b01111011))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000100)) || ((io_ir == (8'b01001100)) || ((io_ir == (8'b01010100)) || ((io_ir == (8'b01011100)) || ((io_ir == (8'b01100100)) || ((io_ir == (8'b01101100)) || ((io_ir == (8'b01110100)) || (io_ir == (8'b01111100))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000101)) || ((io_ir == (8'b01001101)) || ((io_ir == (8'b01010101)) || ((io_ir == (8'b01011101)) || ((io_ir == (8'b01100101)) || ((io_ir == (8'b01101101)) || ((io_ir == (8'b01110101)) || (io_ir == (8'b01111101))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b01000110)) || ((io_ir == (8'b01001110)) || ((io_ir == (8'b01010110)) || ((io_ir == (8'b01011110)) || ((io_ir == (8'b01100110)) || ((io_ir == (8'b01101110)) || ((io_ir == (8'b01110110)) || (io_ir == (8'b01111110))))))))))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Bit_1;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if(((io_ir == (8'b01000111)) || ((io_ir == (8'b01001111)) || ((io_ir == (8'b01010111)) || ((io_ir == (8'b01011111)) || ((io_ir == (8'b01100111)) || ((io_ir == (8'b01101111)) || ((io_ir == (8'b01110111)) || (io_ir == (8'b01111111))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000000)) || ((io_ir == (8'b10001000)) || ((io_ir == (8'b10010000)) || ((io_ir == (8'b10011000)) || ((io_ir == (8'b10100000)) || ((io_ir == (8'b10101000)) || ((io_ir == (8'b10110000)) || (io_ir == (8'b10111000))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000001)) || ((io_ir == (8'b10001001)) || ((io_ir == (8'b10010001)) || ((io_ir == (8'b10011001)) || ((io_ir == (8'b10100001)) || ((io_ir == (8'b10101001)) || ((io_ir == (8'b10110001)) || (io_ir == (8'b10111001))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000010)) || ((io_ir == (8'b10001010)) || ((io_ir == (8'b10010010)) || ((io_ir == (8'b10011010)) || ((io_ir == (8'b10100010)) || ((io_ir == (8'b10101010)) || ((io_ir == (8'b10110010)) || (io_ir == (8'b10111010))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000011)) || ((io_ir == (8'b10001011)) || ((io_ir == (8'b10010011)) || ((io_ir == (8'b10011011)) || ((io_ir == (8'b10100011)) || ((io_ir == (8'b10101011)) || ((io_ir == (8'b10110011)) || (io_ir == (8'b10111011))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000100)) || ((io_ir == (8'b10001100)) || ((io_ir == (8'b10010100)) || ((io_ir == (8'b10011100)) || ((io_ir == (8'b10100100)) || ((io_ir == (8'b10101100)) || ((io_ir == (8'b10110100)) || (io_ir == (8'b10111100))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000101)) || ((io_ir == (8'b10001101)) || ((io_ir == (8'b10010101)) || ((io_ir == (8'b10011101)) || ((io_ir == (8'b10100101)) || ((io_ir == (8'b10101101)) || ((io_ir == (8'b10110101)) || (io_ir == (8'b10111101))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b10000110)) || ((io_ir == (8'b10001110)) || ((io_ir == (8'b10010110)) || ((io_ir == (8'b10011110)) || ((io_ir == (8'b10100110)) || ((io_ir == (8'b10101110)) || ((io_ir == (8'b10110110)) || (io_ir == (8'b10111110))))))))))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Reset;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if(((io_ir == (8'b10000111)) || ((io_ir == (8'b10001111)) || ((io_ir == (8'b10010111)) || ((io_ir == (8'b10011111)) || ((io_ir == (8'b10100111)) || ((io_ir == (8'b10101111)) || ((io_ir == (8'b10110111)) || (io_ir == (8'b10111111))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Reset;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000000)) || ((io_ir == (8'b11001000)) || ((io_ir == (8'b11010000)) || ((io_ir == (8'b11011000)) || ((io_ir == (8'b11100000)) || ((io_ir == (8'b11101000)) || (io_ir == (8'b11110000)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000001)) || ((io_ir == (8'b11001001)) || ((io_ir == (8'b11010001)) || ((io_ir == (8'b11011001)) || ((io_ir == (8'b11100001)) || ((io_ir == (8'b11101001)) || (io_ir == (8'b11110001)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000010)) || ((io_ir == (8'b11001010)) || ((io_ir == (8'b11010010)) || ((io_ir == (8'b11011010)) || ((io_ir == (8'b11100010)) || ((io_ir == (8'b11101010)) || (io_ir == (8'b11110010)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000011)) || ((io_ir == (8'b11001011)) || ((io_ir == (8'b11010011)) || ((io_ir == (8'b11011011)) || ((io_ir == (8'b11100011)) || ((io_ir == (8'b11101011)) || (io_ir == (8'b11110011)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000100)) || ((io_ir == (8'b11001100)) || ((io_ir == (8'b11010100)) || ((io_ir == (8'b11011100)) || ((io_ir == (8'b11100100)) || ((io_ir == (8'b11101100)) || (io_ir == (8'b11110100)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000101)) || ((io_ir == (8'b11001101)) || ((io_ir == (8'b11010101)) || ((io_ir == (8'b11011101)) || ((io_ir == (8'b11100101)) || ((io_ir == (8'b11101101)) || (io_ir == (8'b11110101)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if(((io_ir == (8'b11000110)) || ((io_ir == (8'b11001110)) || ((io_ir == (8'b11010110)) || ((io_ir == (8'b11011110)) || ((io_ir == (8'b11100110)) || ((io_ir == (8'b11101110)) || (io_ir == (8'b11110110)))))))))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Set;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if(((io_ir == (8'b11000111)) || ((io_ir == (8'b11001111)) || ((io_ir == (8'b11010111)) || ((io_ir == (8'b11011111)) || ((io_ir == (8'b11100111)) || ((io_ir == (8'b11101111)) || (io_ir == (8'b11110111)))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Set;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
    end else begin
      if((io_ir == (8'b01110110)))begin
        io_addrOp = `AddrOp_binary_sequancial_Nop;
        io_nextHalt = 1'b1;
      end
      if((io_ir == (8'b10000000)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10000001)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10000010)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10000011)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10000100)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10000101)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10000110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Add;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10000111)))begin
        io_aluOp = `AluOp_binary_sequancial_Add;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001000)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001001)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001010)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001011)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001100)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001101)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10001110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10001111)))begin
        io_aluOp = `AluOp_binary_sequancial_Adc;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010000)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010001)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010010)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010011)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010100)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010101)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10010110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sub;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10010111)))begin
        io_aluOp = `AluOp_binary_sequancial_Sub;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011000)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011001)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011010)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011011)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011100)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011101)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10011110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sbc;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10011111)))begin
        io_aluOp = `AluOp_binary_sequancial_Sbc;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100000)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100001)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100010)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100011)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100100)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100101)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10100110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_And_1;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10100111)))begin
        io_aluOp = `AluOp_binary_sequancial_And_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101000)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101001)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101010)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101011)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101100)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101101)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10101110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Xor_1;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10101111)))begin
        io_aluOp = `AluOp_binary_sequancial_Xor_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110000)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110001)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110010)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110011)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110100)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110101)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10110110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Or_1;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10110111)))begin
        io_aluOp = `AluOp_binary_sequancial_Or_1;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b10111000)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b10111001)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b10111010)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b10111011)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b10111100)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b10111101)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b10111110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Cp;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b10111111)))begin
        io_aluOp = `AluOp_binary_sequancial_Cp;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
      end
      if((io_ir == (8'b01000000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01000001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01000010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01000011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01000100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01000101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01000110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01000111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01001110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01001111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01010110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0110);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01010111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01011110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01011111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01100110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01100111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01101110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01101111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111000)))begin
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111001)))begin
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111010)))begin
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111011)))begin
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111100)))begin
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111101)))begin
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b01111110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01111111)))begin
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add1;
          io_opBSelect = (4'b0101);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc1;
          io_opBSelect = (4'b0100);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0100);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00010100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add1;
          io_opBSelect = (4'b0111);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc1;
          io_opBSelect = (4'b0110);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0110);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00100100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00100011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add1;
          io_opBSelect = (4'b1001);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc1;
          io_opBSelect = (4'b1000);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00110011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add1;
          io_opBSelect = (4'b1011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1011);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc1;
          io_opBSelect = (4'b1010);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1010);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00110100)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Inc;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00111100)))begin
        io_aluOp = `AluOp_binary_sequancial_Inc;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b0100);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0100);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0101);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Dec;
          io_opBSelect = (4'b0101);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Decc;
          io_opBSelect = (4'b0100);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0100);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00010101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0110);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0111);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Dec;
          io_opBSelect = (4'b0111);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Decc;
          io_opBSelect = (4'b0110);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0110);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00100101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b1001);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00101011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Dec;
          io_opBSelect = (4'b1001);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Decc;
          io_opBSelect = (4'b1000);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00111011)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Dec;
          io_opBSelect = (4'b1011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1011);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Decc;
          io_opBSelect = (4'b1010);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1010);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00110101)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Dec;
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00111101)))begin
        io_aluOp = `AluOp_binary_sequancial_Dec;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00000111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rlca;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00001111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rrca;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00010111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rla;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00011111)))begin
        io_aluOp = `AluOp_binary_sequancial_Rra;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00110111)))begin
        io_aluOp = `AluOp_binary_sequancial_Scf;
      end
      if((io_ir == (8'b00101111)))begin
        io_aluOp = `AluOp_binary_sequancial_Cpl;
        io_opBSelect = (4'b0000);
        io_loadOpB = 1'b1;
        io_storeSelect = (4'b0000);
        io_store = 1'b1;
      end
      if((io_ir == (8'b00111111)))begin
        io_aluOp = `AluOp_binary_sequancial_Ccf;
      end
      if((io_ir == (8'b11111110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Cp;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11000110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Add;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11010110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sub;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11100110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_And_1;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11110110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Or_1;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11001110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11011110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sbc;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11101110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Xor_1;
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00001001)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add;
          io_opA = (4'b1001);
          io_opBSelect = (4'b0101);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc;
          io_opA = (4'b1000);
          io_opBSelect = (4'b0100);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00011001)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add;
          io_opA = (4'b1001);
          io_opBSelect = (4'b0111);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc;
          io_opA = (4'b1000);
          io_opBSelect = (4'b0110);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00101001)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add;
          io_opA = (4'b1001);
          io_opBSelect = (4'b1001);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc;
          io_opA = (4'b1000);
          io_opBSelect = (4'b1000);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00111001)))begin
        if((io_mCycle == (3'b000)))begin
          io_aluOp = `AluOp_binary_sequancial_Add;
          io_opA = (4'b1001);
          io_opBSelect = (4'b1011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Adc;
          io_opA = (4'b1000);
          io_opBSelect = (4'b1010);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11111001)))begin
        if((io_mCycle == (3'b000)))begin
          io_opA = (4'b1001);
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opA = (4'b1000);
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00000110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0100);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00001110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00010110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0110);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00011110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00100110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00101110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00111110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b01110000)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0100);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01110001)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0101);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01110010)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0110);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01110011)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0111);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01110100)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b1000);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01110101)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b1001);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b01110111)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00000010)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_BC;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00010010)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_DE;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00001010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_BC;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00011010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_DE;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00110110)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00100010)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
        end
      end
      if((io_ir == (8'b00110010)))begin
        if((io_mCycle == (3'b000)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
        end
      end
      if((io_ir == (8'b00101010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
        end
      end
      if((io_ir == (8'b00111010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
        end
      end
      if((io_ir == (8'b11100000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_FFZ;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11110000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_FFZ;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11100010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_FFC;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11110010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_FFC;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11101010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00001000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1011);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b100)))begin
          io_opBSelect = (4'b1010);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11111010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b00000001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0100);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00010001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0110);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00100001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b00110001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1010);
          io_store = 1'b1;
          io_memRead = 1'b1;
        end
      end
      if((io_ir == (8'b11001001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11011001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11001000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b0;
          if(io_flags[7])begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11000000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b0;
          if((! io_flags[7]))begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11011000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b0;
          if(io_flags[4])begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11010000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b0;
          if((! io_flags[4]))begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11000111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11001111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11010111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11011111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11100111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11101111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11110111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11111111)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_addrOp = `AddrOp_binary_sequancial_Rst;
        end
      end
      if((io_ir == (8'b11001011)))begin
        io_nextPrefix = 1'b1;
      end
      if((io_ir == (8'b11001101)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b100)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b101)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_ToPC;
        end
      end
      if((io_ir == (8'b11001100)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = io_flags[7];
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          if(io_flags[7])begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b100)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b101)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_ToPC;
        end
      end
      if((io_ir == (8'b11011100)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = io_flags[7];
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          if(io_flags[7])begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b100)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b101)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_ToPC;
        end
      end
      if((io_ir == (8'b11000100)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = (! io_flags[7]);
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          if((! io_flags[7]))begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b100)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b101)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_ToPC;
        end
      end
      if((io_ir == (8'b11010100)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0010);
          io_store = (! io_flags[4]);
          io_memRead = 1'b1;
          io_memWrite = 1'b1;
          if((! io_flags[4]))begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b100)))begin
          io_opBSelect = (4'b1101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP1;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b101)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_WZ;
          io_addrOp = `AddrOp_binary_sequancial_ToPC;
        end
      end
      if((io_ir == (8'b11000001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11010001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0110);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11100001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11110001)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0001);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b0000);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
        end
      end
      if((io_ir == (8'b11000101)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0100);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0101);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11010101)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0110);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0111);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11100101)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b1000);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b1001);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11110101)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_opBSelect = (4'b0000);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Dec;
          io_memWrite = 1'b1;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0001);
          io_loadOpB = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11101000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_R8;
        end
      end
      if((io_ir == (8'b11111000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_addrSrc = `AddrSrc_binary_sequancial_SP;
          io_addrOp = `AddrOp_binary_sequancial_HLR8;
        end
      end
      if((io_ir == (8'b00011000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_addrOp = `AddrOp_binary_sequancial_R8;
        end
      end
      if((io_ir == (8'b00101000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          if(io_flags[7])begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_addrOp = `AddrOp_binary_sequancial_R8;
        end
      end
      if((io_ir == (8'b00111000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          if(io_flags[4])begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_addrOp = `AddrOp_binary_sequancial_R8;
        end
      end
      if((io_ir == (8'b00100000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          if((! io_flags[7]))begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_addrOp = `AddrOp_binary_sequancial_R8;
        end
      end
      if((io_ir == (8'b00110000)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          if((! io_flags[4]))begin
            io_nextMCycle = (io_mCycle + (3'b001));
          end
        end
        if((io_mCycle == (3'b010)))begin
          io_addrOp = `AddrOp_binary_sequancial_R8;
        end
      end
      if((io_ir == (8'b11000010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = (! io_flags[7]);
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = (! io_flags[7]);
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1101);
          io_store = (! io_flags[7]);
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11000011)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = 1'b1;
          io_memRead = 1'b1;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1101);
          io_store = 1'b1;
          io_addrSrc = `AddrSrc_binary_sequancial_HL;
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11001010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b0011);
          io_store = io_flags[7];
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = io_flags[7];
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1101);
          io_store = io_flags[7];
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11010010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1101);
          io_store = (! io_flags[4]);
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = (! io_flags[4]);
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1101);
          io_store = (! io_flags[4]);
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
      if((io_ir == (8'b11011010)))begin
        if((io_mCycle == (3'b000)))begin
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_storeSelect = (4'b1101);
          io_store = io_flags[4];
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b010)))begin
          io_storeSelect = (4'b1100);
          io_store = io_flags[4];
          io_memRead = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b011)))begin
          io_opBSelect = (4'b0011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1101);
          io_store = io_flags[4];
          io_addrOp = `AddrOp_binary_sequancial_Nop;
        end
      end
    end
  end

endmodule

module CpuAlu (
      input  `AluOp_binary_sequancial_type io_op,
      input  [7:0] io_flagsIn,
      output reg [7:0] io_flagsOut,
      input  [7:0] io_operandA,
      input  [7:0] io_operandB,
      output [7:0] io_result,
      input  [7:0] io_ir);
  wire [8:0] _zz_1;
  wire [8:0] _zz_2;
  wire [8:0] _zz_3;
  wire [8:0] _zz_4;
  wire [8:0] _zz_5;
  wire [0:0] _zz_6;
  wire [8:0] _zz_7;
  wire [0:0] _zz_8;
  wire [8:0] _zz_9;
  wire [8:0] _zz_10;
  wire [0:0] _zz_11;
  wire [8:0] _zz_12;
  wire [0:0] _zz_13;
  wire [8:0] _zz_14;
  wire [0:0] _zz_15;
  wire [8:0] _zz_16;
  wire [8:0] _zz_17;
  wire [8:0] _zz_18;
  reg [8:0] wideResult;
  wire [8:0] wideOpA;
  wire [8:0] wideOpB;
  wire  carry;
  wire  halfCarry;
  wire  halfBorrow;
  assign _zz_1 = wideResult;
  assign _zz_2 = wideResult;
  assign _zz_3 = wideResult;
  assign _zz_4 = wideResult;
  assign _zz_5 = (wideOpA + wideOpB);
  assign _zz_6 = io_flagsIn[4];
  assign _zz_7 = {8'd0, _zz_6};
  assign _zz_8 = io_flagsIn[4];
  assign _zz_9 = {8'd0, _zz_8};
  assign _zz_10 = (wideOpA - wideOpB);
  assign _zz_11 = io_flagsIn[4];
  assign _zz_12 = {8'd0, _zz_11};
  assign _zz_13 = io_flagsIn[4];
  assign _zz_14 = {8'd0, _zz_13};
  assign _zz_15 = io_flagsIn[4];
  assign _zz_16 = {8'd0, _zz_15};
  assign _zz_17 = ((9'b000000001) <<< io_ir[5 : 3]);
  assign _zz_18 = ((9'b000000001) <<< io_ir[5 : 3]);
  assign io_result = wideResult[7 : 0];
  assign wideOpA = {1'd0, io_operandA};
  assign wideOpB = {1'd0, io_operandB};
  assign carry = wideResult[8];
  assign halfCarry = (_zz_1[4] && (_zz_2[3 : 0] == (4'b0000)));
  assign halfBorrow = ((! _zz_3[4]) && (_zz_4[3 : 0] == (4'b1111)));
  always @ (*) begin
    io_flagsOut = io_flagsIn;
    case(io_op)
      `AluOp_binary_sequancial_Nop : begin
        wideResult = wideOpB;
      end
      `AluOp_binary_sequancial_Add : begin
        wideResult = (wideOpA + wideOpB);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Add1 : begin
        wideResult = (wideOpB + (9'b000000001));
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Adc : begin
        wideResult = (_zz_5 + _zz_7);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Adc1 : begin
        wideResult = (wideOpB + _zz_9);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Sub : begin
        wideResult = (wideOpA - wideOpB);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfBorrow;
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Sbc : begin
        wideResult = (_zz_10 - _zz_12);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfBorrow;
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_And_1 : begin
        wideResult = (wideOpA & wideOpB);
        io_flagsOut[4] = 1'b0;
        io_flagsOut[5] = 1'b1;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Xor_1 : begin
        wideResult = (wideOpA ^ wideOpB);
        io_flagsOut[4] = 1'b0;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Or_1 : begin
        wideResult = (wideOpA | wideOpB);
        io_flagsOut[4] = 1'b0;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Cp : begin
        wideResult = (wideOpA - wideOpB);
        io_flagsOut[4] = (! carry);
        io_flagsOut[5] = (! halfCarry);
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Inc : begin
        wideResult = (wideOpB + (9'b000000001));
        io_flagsOut[4] = io_flagsIn[4];
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Incc : begin
        wideResult = (wideOpB + _zz_14);
        io_flagsOut[4] = io_flagsIn[4];
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Dec : begin
        wideResult = (wideOpB - (9'b000000001));
        io_flagsOut[4] = io_flagsIn[4];
        io_flagsOut[5] = halfBorrow;
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Decc : begin
        wideResult = (wideOpB - _zz_16);
        io_flagsOut[4] = io_flagsIn[4];
        io_flagsOut[5] = halfBorrow;
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Cpl : begin
        wideResult = (~ wideOpB);
        io_flagsOut[5] = 1'b1;
        io_flagsOut[6] = 1'b1;
      end
      `AluOp_binary_sequancial_Ccf : begin
        wideResult = wideOpB;
        io_flagsOut[4] = (! io_flagsIn[4]);
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
      end
      `AluOp_binary_sequancial_Scf : begin
        wideResult = wideOpB;
        io_flagsOut[4] = 1'b1;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
      end
      `AluOp_binary_sequancial_Swap : begin
        wideResult = {{(1'b0),wideOpA[3 : 0]},wideOpA[7 : 4]};
        io_flagsOut[4] = 1'b0;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Rlca : begin
        wideResult = {wideOpA[7 : 0],wideOpA[7]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = 1'b0;
      end
      `AluOp_binary_sequancial_Rlc : begin
        wideResult = {wideOpB[7 : 0],wideOpB[7]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Rrca : begin
        wideResult = {{wideOpA[0],wideOpA[0]},wideOpA[7 : 1]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = 1'b0;
      end
      `AluOp_binary_sequancial_Rrc : begin
        wideResult = {{wideOpB[0],wideOpB[0]},wideOpB[7 : 1]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Rla : begin
        wideResult = {wideOpA[7 : 0],wideOpA[8 : 8]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = 1'b0;
      end
      `AluOp_binary_sequancial_Rl : begin
        wideResult = {wideOpB[7 : 0],wideOpB[8 : 8]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Rra : begin
        wideResult = {wideOpA[0 : 0],wideOpA[8 : 1]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = 1'b0;
      end
      `AluOp_binary_sequancial_Rr : begin
        wideResult = {wideOpB[0 : 0],wideOpB[8 : 1]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Sla_1 : begin
        wideResult = (wideOpB <<< 1);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Sra_1 : begin
        wideResult = {{wideOpB[0],wideOpB[7]},wideOpB[7 : 1]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Srl_1 : begin
        wideResult = {{wideOpB[0],(1'b0)},wideOpB[7 : 1]};
        io_flagsOut[4] = carry;
        io_flagsOut[5] = 1'b0;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Bit_1 : begin
        wideResult = (9'b000000000);
        io_flagsOut[4] = io_flagsIn[4];
        io_flagsOut[5] = 1'b1;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (! io_operandB[io_ir[5 : 3]]);
      end
      `AluOp_binary_sequancial_Set : begin
        wideResult = (wideOpB | _zz_17);
        io_flagsOut = io_flagsIn;
      end
      default : begin
        wideResult = (wideOpB & (~ _zz_18));
        io_flagsOut = io_flagsIn;
      end
    endcase
  end

endmodule

module ST7789 (
      input   io_pixels_valid,
      output reg  io_pixels_ready,
      input  [15:0] io_pixels_payload,
      output [7:0] io_x,
      output [7:0] io_y,
      output reg  io_next_pixel,
      output  io_oled_csn,
      output  io_oled_clk,
      output  io_oled_mosi,
      output  io_oled_dc,
      output  io_oled_resn,
      input   clkout0,
      input   _zz_2);
  wire [7:0] _zz_3;
  reg [7:0] _zz_4;
  reg [7:0] _zz_5;
  wire  _zz_6;
  wire  _zz_7;
  wire  _zz_8;
  wire  _zz_9;
  wire  _zz_10;
  wire [5:0] _zz_11;
  wire [4:0] _zz_12;
  wire [5:0] _zz_13;
  wire [4:0] _zz_14;
  wire [5:0] _zz_15;
  wire [21:0] _zz_16;
  reg [22:0] resetCnt;
  reg [10:0] initCnt;
  reg [7:0] data;
  reg  dc;
  reg  byteToggle;
  reg  init;
  reg [4:0] numArgs;
  reg [24:0] delayCnt;
  reg [5:0] arg;
  reg  delaySet;
  reg [7:0] lastCmd;
  wire [6:0] _zz_1;
  wire [7:0] nextByte;
  reg [7:0] C_oled_init [0:35];
  assign io_x = _zz_4;
  assign io_y = _zz_5;
  assign _zz_6 = ((25'b0000000000000000000000000) < delayCnt);
  assign _zz_7 = (initCnt[10 : 4] != (7'b0100100));
  assign _zz_8 = (! byteToggle);
  assign _zz_9 = (! resetCnt[22]);
  assign _zz_10 = (initCnt[3 : 0] == (4'b0000));
  assign _zz_11 = _zz_1[5:0];
  assign _zz_12 = (numArgs + (5'b00001));
  assign _zz_13 = {1'd0, _zz_12};
  assign _zz_14 = (numArgs + (5'b00001));
  assign _zz_15 = {1'd0, _zz_14};
  assign _zz_16 = (nextByte * (14'b11111010000000));
  initial begin
    $readmemb("GameBoyUlx3s.v_toplevel_coreClockingArea_gameboy_ppu_lcd_C_oled_init.bin",C_oled_init);
  end
  assign _zz_3 = C_oled_init[_zz_11];
  assign io_oled_resn = resetCnt[22];
  assign io_oled_csn = 1'b1;
  assign io_oled_dc = dc;
  assign io_oled_clk = initCnt[0];
  assign io_oled_mosi = data[7];
  assign _zz_1 = initCnt[10 : 4];
  assign nextByte = _zz_3;
  always @ (*) begin
    io_pixels_ready = 1'b0;
    if(! _zz_9) begin
      if(! _zz_6) begin
        if(_zz_7)begin
          if(_zz_10)begin
            if(! init) begin
              if(_zz_8)begin
                io_pixels_ready = 1'b1;
              end
            end
          end
        end
      end
    end
  end

  always @ (posedge clkout0 or negedge _zz_2) begin
    if (!_zz_2) begin
      _zz_4 <= (8'b00000000);
      _zz_5 <= (8'b00000000);
      resetCnt <= (23'b00000000000000000000000);
      initCnt <= (11'b00000000000);
      data <= (8'b00000000);
      dc <= 1'b0;
      byteToggle <= 1'b0;
      init <= 1'b1;
      numArgs <= (5'b00000);
      delayCnt <= (25'b0000000000000000000000000);
      arg <= (6'b000000);
      delaySet <= 1'b0;
      lastCmd <= (8'b00000000);
    end else begin
      if(_zz_9)begin
        resetCnt <= (resetCnt + (23'b00000000000000000000001));
      end else begin
        if(_zz_6)begin
          delayCnt <= (delayCnt - (25'b0000000000000000000000001));
        end else begin
          if(_zz_7)begin
            initCnt <= (initCnt + (11'b00000000001));
            if(_zz_10)begin
              if(init)begin
                dc <= 1'b0;
                arg <= (arg + (6'b000001));
                if((arg == (6'b000000)))begin
                  data <= (8'b00000000);
                  lastCmd <= nextByte;
                end else begin
                  if((arg == (6'b000001)))begin
                    numArgs <= nextByte[4 : 0];
                    delaySet <= nextByte[7];
                    if((nextByte == (8'b00000000)))begin
                      arg <= (6'b000000);
                    end
                    data <= lastCmd;
                  end else begin
                    if((arg <= _zz_13))begin
                      data <= nextByte;
                      dc <= 1'b1;
                      if(((arg == _zz_15) && (! delaySet)))begin
                        arg <= (6'b000000);
                      end
                    end else begin
                      if(delaySet)begin
                        if((nextByte != (8'b11111111)))begin
                          delayCnt <= {3'd0, _zz_16};
                        end else begin
                          delayCnt <= (25'b0011110100001001000000000);
                        end
                        data <= (8'b00000000);
                        delaySet <= 1'b0;
                        arg <= (6'b000000);
                      end
                    end
                  end
                end
              end else begin
                byteToggle <= (! byteToggle);
                dc <= 1'b1;
                data <= (byteToggle ? io_pixels_payload[7 : 0] : io_pixels_payload[15 : 8]);
                if(_zz_8)begin
                  if((_zz_4 == (8'b10011111)))begin
                    _zz_4 <= (8'b00000000);
                    if((_zz_5 == (8'b10001111)))begin
                      _zz_5 <= (8'b00000000);
                    end else begin
                      _zz_5 <= (_zz_5 + (8'b00000001));
                    end
                  end else begin
                    _zz_4 <= (_zz_4 + (8'b00000001));
                  end
                end
              end
            end else begin
              if((! initCnt[0]))begin
                data <= {data[6 : 0],(1'b0)};
              end
            end
          end else begin
            init <= 1'b0;
            initCnt[10 : 4] <= (7'b0100011);
          end
        end
      end
    end
  end

  always @ (posedge clkout0) begin
    if(! _zz_9) begin
      if(! _zz_6) begin
        if(_zz_7)begin
          if(_zz_10)begin
            if(! init) begin
              if(_zz_8)begin
                io_next_pixel <= 1'b1;
              end
            end
          end else begin
            io_next_pixel <= 1'b0;
          end
        end
      end
    end
  end

endmodule

module Cpu (
      output reg [15:0] io_address,
      input  [7:0] io_dataIn,
      output [7:0] io_dataOut,
      output  io_mreq,
      output  io_write,
      output  io_halt,
      output [7:0] io_diag,
      input   clkout0,
      input   _zz_2);
  reg [7:0] _zz_3;
  reg [7:0] _zz_4;
  wire [2:0] _zz_5;
  wire `AluOp_binary_sequancial_type _zz_6;
  wire [3:0] _zz_7;
  wire [3:0] _zz_8;
  wire  _zz_9;
  wire [3:0] _zz_10;
  wire  _zz_11;
  wire  _zz_12;
  wire  _zz_13;
  wire `AddrSrc_binary_sequancial_type _zz_14;
  wire `AddrOp_binary_sequancial_type _zz_15;
  wire  _zz_16;
  wire  _zz_17;
  wire [7:0] _zz_18;
  wire [7:0] _zz_19;
  wire [7:0] _zz_20;
  wire [7:0] _zz_21;
  wire [15:0] _zz_22;
  wire [7:0] _zz_23;
  wire [15:0] _zz_24;
  wire [7:0] _zz_25;
  wire [7:0] _zz_26;
  wire [15:0] _zz_27;
  wire [7:0] _zz_28;
  wire [15:0] _zz_29;
  wire [7:0] _zz_30;
  wire [7:0] _zz_31;
  wire [15:0] _zz_32;
  wire [7:0] _zz_33;
  wire [15:0] _zz_34;
  wire [7:0] _zz_35;
  wire [7:0] _zz_36;
  wire [15:0] _zz_37;
  wire [7:0] _zz_38;
  wire [15:0] _zz_39;
  wire [7:0] _zz_40;
  wire [7:0] _zz_41;
  wire [15:0] _zz_42;
  wire [7:0] _zz_43;
  wire [15:0] _zz_44;
  wire [7:0] _zz_45;
  wire [7:0] _zz_46;
  wire [15:0] _zz_47;
  wire [7:0] _zz_48;
  wire [15:0] _zz_49;
  wire [7:0] _zz_50;
  wire [7:0] _zz_51;
  wire [15:0] _zz_52;
  wire [7:0] _zz_53;
  wire [15:0] _zz_54;
  reg [31:0] tCount;
  reg  mreq;
  reg  write;
  reg [7:0] ir;
  reg [15:0] registers16_0;
  reg [15:0] registers16_1;
  reg [15:0] registers16_2;
  reg [15:0] registers16_3;
  reg [15:0] registers16_4;
  reg [15:0] registers16_5;
  reg [15:0] registers16_6;
  wire [7:0] registers8_0;
  wire [7:0] registers8_1;
  wire [7:0] registers8_2;
  wire [7:0] registers8_3;
  wire [7:0] registers8_4;
  wire [7:0] registers8_5;
  wire [7:0] registers8_6;
  wire [7:0] registers8_7;
  wire [7:0] registers8_8;
  wire [7:0] registers8_9;
  wire [7:0] registers8_10;
  wire [7:0] registers8_11;
  wire [7:0] registers8_12;
  wire [7:0] registers8_13;
  reg [7:0] temp;
  reg [7:0] opA;
  reg  prefix;
  reg [2:0] mCycle;
  reg  writeCycle;
  reg  halt;
  wire  tCycleFsm_wantExit;
  reg `tCycleFsm_enumDefinition_binary_sequancial_type tCycleFsm_stateReg;
  reg `tCycleFsm_enumDefinition_binary_sequancial_type tCycleFsm_stateNext;
  wire [15:0] _zz_1;
  assign _zz_20 = (ir - (8'b11000111));
  assign _zz_21 = temp;
  assign _zz_22 = {{8{_zz_21[7]}}, _zz_21};
  assign _zz_23 = temp;
  assign _zz_24 = {{8{_zz_23[7]}}, _zz_23};
  assign _zz_25 = (ir - (8'b11000111));
  assign _zz_26 = temp;
  assign _zz_27 = {{8{_zz_26[7]}}, _zz_26};
  assign _zz_28 = temp;
  assign _zz_29 = {{8{_zz_28[7]}}, _zz_28};
  assign _zz_30 = (ir - (8'b11000111));
  assign _zz_31 = temp;
  assign _zz_32 = {{8{_zz_31[7]}}, _zz_31};
  assign _zz_33 = temp;
  assign _zz_34 = {{8{_zz_33[7]}}, _zz_33};
  assign _zz_35 = (ir - (8'b11000111));
  assign _zz_36 = temp;
  assign _zz_37 = {{8{_zz_36[7]}}, _zz_36};
  assign _zz_38 = temp;
  assign _zz_39 = {{8{_zz_38[7]}}, _zz_38};
  assign _zz_40 = (ir - (8'b11000111));
  assign _zz_41 = temp;
  assign _zz_42 = {{8{_zz_41[7]}}, _zz_41};
  assign _zz_43 = temp;
  assign _zz_44 = {{8{_zz_43[7]}}, _zz_43};
  assign _zz_45 = (ir - (8'b11000111));
  assign _zz_46 = temp;
  assign _zz_47 = {{8{_zz_46[7]}}, _zz_46};
  assign _zz_48 = temp;
  assign _zz_49 = {{8{_zz_48[7]}}, _zz_48};
  assign _zz_50 = (ir - (8'b11000111));
  assign _zz_51 = temp;
  assign _zz_52 = {{8{_zz_51[7]}}, _zz_51};
  assign _zz_53 = temp;
  assign _zz_54 = {{8{_zz_53[7]}}, _zz_53};
  CpuDecoder decoder ( 
    .io_mCycle(mCycle),
    .io_nextMCycle(_zz_5),
    .io_ir(ir),
    .io_aluOp(_zz_6),
    .io_opA(_zz_7),
    .io_opBSelect(_zz_8),
    .io_loadOpB(_zz_9),
    .io_storeSelect(_zz_10),
    .io_store(_zz_11),
    .io_memRead(_zz_12),
    .io_memWrite(_zz_13),
    .io_addrSrc(_zz_14),
    .io_addrOp(_zz_15),
    .io_nextHalt(_zz_16),
    .io_flags(registers8_1),
    .io_prefix(prefix),
    .io_nextPrefix(_zz_17) 
  );
  CpuAlu alu ( 
    .io_op(_zz_6),
    .io_flagsIn(registers8_1),
    .io_flagsOut(_zz_18),
    .io_operandA(opA),
    .io_operandB(temp),
    .io_result(_zz_19),
    .io_ir(ir) 
  );
  always @(*) begin
    case(_zz_7)
      4'b0000 : begin
        _zz_3 = registers8_0;
      end
      4'b0001 : begin
        _zz_3 = registers8_1;
      end
      4'b0010 : begin
        _zz_3 = registers8_2;
      end
      4'b0011 : begin
        _zz_3 = registers8_3;
      end
      4'b0100 : begin
        _zz_3 = registers8_4;
      end
      4'b0101 : begin
        _zz_3 = registers8_5;
      end
      4'b0110 : begin
        _zz_3 = registers8_6;
      end
      4'b0111 : begin
        _zz_3 = registers8_7;
      end
      4'b1000 : begin
        _zz_3 = registers8_8;
      end
      4'b1001 : begin
        _zz_3 = registers8_9;
      end
      4'b1010 : begin
        _zz_3 = registers8_10;
      end
      4'b1011 : begin
        _zz_3 = registers8_11;
      end
      4'b1100 : begin
        _zz_3 = registers8_12;
      end
      default : begin
        _zz_3 = registers8_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_8)
      4'b0000 : begin
        _zz_4 = registers8_0;
      end
      4'b0001 : begin
        _zz_4 = registers8_1;
      end
      4'b0010 : begin
        _zz_4 = registers8_2;
      end
      4'b0011 : begin
        _zz_4 = registers8_3;
      end
      4'b0100 : begin
        _zz_4 = registers8_4;
      end
      4'b0101 : begin
        _zz_4 = registers8_5;
      end
      4'b0110 : begin
        _zz_4 = registers8_6;
      end
      4'b0111 : begin
        _zz_4 = registers8_7;
      end
      4'b1000 : begin
        _zz_4 = registers8_8;
      end
      4'b1001 : begin
        _zz_4 = registers8_9;
      end
      4'b1010 : begin
        _zz_4 = registers8_10;
      end
      4'b1011 : begin
        _zz_4 = registers8_11;
      end
      4'b1100 : begin
        _zz_4 = registers8_12;
      end
      default : begin
        _zz_4 = registers8_13;
      end
    endcase
  end

  assign io_mreq = mreq;
  assign io_write = write;
  assign registers8_0 = registers16_0[15 : 8];
  assign registers8_1 = registers16_0[7 : 0];
  assign registers8_2 = registers16_1[15 : 8];
  assign registers8_3 = registers16_1[7 : 0];
  assign registers8_4 = registers16_2[15 : 8];
  assign registers8_5 = registers16_2[7 : 0];
  assign registers8_6 = registers16_3[15 : 8];
  assign registers8_7 = registers16_3[7 : 0];
  assign registers8_8 = registers16_4[15 : 8];
  assign registers8_9 = registers16_4[7 : 0];
  assign registers8_10 = registers16_5[15 : 8];
  assign registers8_11 = registers16_5[7 : 0];
  assign registers8_12 = registers16_6[15 : 8];
  assign registers8_13 = registers16_6[7 : 0];
  assign io_diag = registers8_0;
  assign io_dataOut = temp;
  assign io_halt = halt;
  always @ (*) begin
    case(_zz_14)
      `AddrSrc_binary_sequancial_PC : begin
        io_address = registers16_6;
      end
      `AddrSrc_binary_sequancial_HL : begin
        io_address = registers16_4;
      end
      `AddrSrc_binary_sequancial_BC : begin
        io_address = registers16_2;
      end
      `AddrSrc_binary_sequancial_DE : begin
        io_address = registers16_3;
      end
      `AddrSrc_binary_sequancial_WZ : begin
        io_address = registers16_1;
      end
      `AddrSrc_binary_sequancial_SP : begin
        io_address = registers16_5;
      end
      `AddrSrc_binary_sequancial_SP1 : begin
        io_address = (registers16_5 - (16'b0000000000000001));
      end
      `AddrSrc_binary_sequancial_FFZ : begin
        io_address[15 : 8] = (8'b11111111);
        io_address[7 : 0] = registers8_3;
      end
      default : begin
        io_address[15 : 8] = (8'b11111111);
        io_address[7 : 0] = registers8_5;
      end
    endcase
  end

  assign tCycleFsm_wantExit = 1'b0;
  always @ (*) begin
    tCycleFsm_stateNext = tCycleFsm_stateReg;
    case(tCycleFsm_stateReg)
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State : begin
        tCycleFsm_stateNext = `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t2State;
      end
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t2State : begin
        tCycleFsm_stateNext = `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t3State;
      end
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t3State : begin
        tCycleFsm_stateNext = `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t4State;
      end
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t4State : begin
        if((! halt))begin
          tCycleFsm_stateNext = `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State;
        end
      end
      default : begin
        tCycleFsm_stateNext = `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State;
      end
    endcase
  end

  assign _zz_1 = ({15'd0,(1'b1)} <<< _zz_10);
  always @ (posedge clkout0 or negedge _zz_2) begin
    if (!_zz_2) begin
      tCount <= (32'b00000000000000000000000000000000);
      mreq <= 1'b0;
      write <= 1'b0;
      ir <= (8'b00000000);
      registers16_0 <= (16'b0000000000000000);
      registers16_1 <= (16'b0000000000000000);
      registers16_2 <= (16'b0000000000000000);
      registers16_3 <= (16'b0000000000000000);
      registers16_4 <= (16'b0000000000000000);
      registers16_5 <= (16'b1111111111111111);
      registers16_6 <= (16'b0000000100000000);
      temp <= (8'b00000000);
      prefix <= 1'b0;
      mCycle <= (3'b000);
      writeCycle <= 1'b0;
      halt <= 1'b0;
      tCycleFsm_stateReg <= `tCycleFsm_enumDefinition_binary_sequancial_boot;
    end else begin
      if((! halt))begin
        tCount <= (tCount + (32'b00000000000000000000000000000001));
      end
      tCycleFsm_stateReg <= tCycleFsm_stateNext;
      case(tCycleFsm_stateReg)
        `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State : begin
          mreq <= 1'b0;
        end
        `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t2State : begin
          if(_zz_12)begin
            temp <= io_dataIn;
          end else begin
            if((mCycle == (3'b000)))begin
              ir <= io_dataIn;
            end
          end
        end
        `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t3State : begin
          if(writeCycle)begin
            mreq <= 1'b1;
            write <= 1'b1;
          end
          if(_zz_9)begin
            temp <= _zz_4;
          end
          halt <= _zz_16;
        end
        `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t4State : begin
          mreq <= 1'b0;
          write <= 1'b0;
          if((_zz_5 == (3'b000)))begin
            prefix <= _zz_17;
          end
          case(_zz_14)
            `AddrSrc_binary_sequancial_PC : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_6 <= (registers16_6 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_6 <= (registers16_6 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_6 <= {8'd0, _zz_20};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_6;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_6 <= (registers16_6 + _zz_22);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_6 + _zz_24);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_HL : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_4 <= (registers16_4 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_4 <= (registers16_4 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_4 <= {8'd0, _zz_25};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_4;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_4 <= (registers16_4 + _zz_27);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_4 + _zz_29);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_WZ : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_1 <= (registers16_1 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_1 <= (registers16_1 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_1 <= {8'd0, _zz_30};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_1;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_1 <= (registers16_1 + _zz_32);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_1 + _zz_34);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_BC : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_2 <= (registers16_2 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_2 <= (registers16_2 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_2 <= {8'd0, _zz_35};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_2;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_2 <= (registers16_2 + _zz_37);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_2 + _zz_39);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_DE : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_3 <= (registers16_3 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_3 <= (registers16_3 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_3 <= {8'd0, _zz_40};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_3;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_3 <= (registers16_3 + _zz_42);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_3 + _zz_44);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_SP : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_5 <= (registers16_5 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_5 <= (registers16_5 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_5 <= {8'd0, _zz_45};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_5;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_5 <= (registers16_5 + _zz_47);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_5 + _zz_49);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_SP1 : begin
              case(_zz_15)
                `AddrOp_binary_sequancial_Inc : begin
                  registers16_5 <= (registers16_5 + (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Dec : begin
                  registers16_5 <= (registers16_5 - (16'b0000000000000001));
                end
                `AddrOp_binary_sequancial_Rst : begin
                  registers16_5 <= {8'd0, _zz_50};
                end
                `AddrOp_binary_sequancial_ToPC : begin
                  registers16_6 <= registers16_5;
                end
                `AddrOp_binary_sequancial_R8 : begin
                  registers16_5 <= (registers16_5 + _zz_52);
                end
                `AddrOp_binary_sequancial_HLR8 : begin
                  registers16_4 <= (registers16_5 + _zz_54);
                end
                default : begin
                end
              endcase
            end
            `AddrSrc_binary_sequancial_FFZ : begin
            end
            default : begin
            end
          endcase
          if(_zz_11)begin
            if(_zz_1[0])begin
              registers16_0[15 : 8] <= _zz_19;
            end
            if(_zz_1[1])begin
              registers16_0[7 : 0] <= _zz_19;
            end
            if(_zz_1[2])begin
              registers16_1[15 : 8] <= _zz_19;
            end
            if(_zz_1[3])begin
              registers16_1[7 : 0] <= _zz_19;
            end
            if(_zz_1[4])begin
              registers16_2[15 : 8] <= _zz_19;
            end
            if(_zz_1[5])begin
              registers16_2[7 : 0] <= _zz_19;
            end
            if(_zz_1[6])begin
              registers16_3[15 : 8] <= _zz_19;
            end
            if(_zz_1[7])begin
              registers16_3[7 : 0] <= _zz_19;
            end
            if(_zz_1[8])begin
              registers16_4[15 : 8] <= _zz_19;
            end
            if(_zz_1[9])begin
              registers16_4[7 : 0] <= _zz_19;
            end
            if(_zz_1[10])begin
              registers16_5[15 : 8] <= _zz_19;
            end
            if(_zz_1[11])begin
              registers16_5[7 : 0] <= _zz_19;
            end
            if(_zz_1[12])begin
              registers16_6[15 : 8] <= _zz_19;
            end
            if(_zz_1[13])begin
              registers16_6[7 : 0] <= _zz_19;
            end
          end
          registers16_0[7 : 0] <= _zz_18;
          mCycle <= _zz_5;
        end
        default : begin
        end
      endcase
      if(((! (tCycleFsm_stateReg == `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State)) && (tCycleFsm_stateNext == `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State)))begin
        writeCycle <= _zz_13;
        if((! _zz_13))begin
          mreq <= 1'b1;
        end
      end
    end
  end

  always @ (posedge clkout0) begin
    case(tCycleFsm_stateReg)
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State : begin
      end
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t2State : begin
      end
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t3State : begin
        opA <= _zz_3;
      end
      `tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t4State : begin
      end
      default : begin
      end
    endcase
  end

endmodule

module PPUUlx3s (
      output  io_oled_csn,
      output  io_oled_resn,
      output  io_oled_dc,
      output  io_oled_mosi,
      output  io_oled_clk,
      output reg [12:0] io_address,
      input  [7:0] io_lcdControl,
      input  [7:0] io_startX,
      input  [7:0] io_startY,
      input  [7:0] io_windowX,
      input  [7:0] io_windowY,
      input  [7:0] io_bgPalette,
      output [1:0] io_mode,
      output [7:0] io_currentY,
      input  [7:0] io_dataIn,
      output [7:0] io_diag,
      input   clkout0,
      input   _zz_1);
  wire  _zz_2;
  wire [15:0] _zz_3;
  reg [15:0] _zz_4;
  wire  _zz_5;
  wire [7:0] _zz_6;
  wire [7:0] _zz_7;
  wire  _zz_8;
  wire  _zz_9;
  wire  _zz_10;
  wire  _zz_11;
  wire  _zz_12;
  wire  _zz_13;
  wire  _zz_14;
  wire  _zz_15;
  wire  _zz_16;
  wire  _zz_17;
  wire [2:0] _zz_18;
  wire [2:0] _zz_19;
  wire [3:0] _zz_20;
  wire [1:0] _zz_21;
  reg [1:0] mode;
  wire [15:0] colors_0;
  wire [15:0] colors_1;
  wire [15:0] colors_2;
  wire [15:0] colors_3;
  reg [7:0] x;
  reg [7:0] y;
  reg [7:0] tile;
  reg [7:0] texture0;
  reg [7:0] texture1;
  reg [1:0] bitCycle;
  reg [31:0] sprites_0;
  reg [31:0] sprites_1;
  reg [31:0] sprites_2;
  reg [31:0] sprites_3;
  reg [31:0] sprites_4;
  reg [31:0] sprites_5;
  reg [31:0] sprites_6;
  reg [31:0] sprites_7;
  reg [31:0] sprites_8;
  reg [31:0] sprites_9;
  wire [12:0] bgScrnAddress;
  wire [12:0] windowAddress;
  wire  showWindow;
  wire  windowPriority;
  wire [12:0] textureAddress;
  wire  inWindow;
  wire  bgOn;
  wire [7:0] tileX;
  wire [7:0] tileY;
  wire [2:0] bitx;
  wire  bit0;
  wire  bit1;
  wire [1:0] color;
  assign _zz_14 = (bitCycle == (2'b01));
  assign _zz_15 = (bitCycle == (2'b00));
  assign _zz_16 = (bitCycle == (2'b10));
  assign _zz_17 = (bitx == (3'b111));
  assign _zz_18 = ((3'b111) - bitx);
  assign _zz_19 = ((3'b111) - bitx);
  assign _zz_20 = (color * (2'b10));
  assign _zz_21 = io_bgPalette[_zz_20 +: 2];
  ST7789 lcd ( 
    .io_pixels_valid(_zz_2),
    .io_pixels_ready(_zz_5),
    .io_pixels_payload(_zz_3),
    .io_x(_zz_6),
    .io_y(_zz_7),
    .io_next_pixel(_zz_8),
    .io_oled_csn(_zz_9),
    .io_oled_clk(_zz_10),
    .io_oled_mosi(_zz_11),
    .io_oled_dc(_zz_12),
    .io_oled_resn(_zz_13),
    .clkout0(clkout0),
    ._zz_2(_zz_1) 
  );
  always @(*) begin
    case(_zz_21)
      2'b00 : begin
        _zz_4 = colors_0;
      end
      2'b01 : begin
        _zz_4 = colors_1;
      end
      2'b10 : begin
        _zz_4 = colors_2;
      end
      default : begin
        _zz_4 = colors_3;
      end
    endcase
  end

  assign io_mode = mode;
  assign colors_0 = (16'b0000100110100001);
  assign colors_1 = (16'b0010101100000101);
  assign colors_2 = (16'b1000010101000001);
  assign colors_3 = (16'b1001010111000001);
  assign io_currentY = y;
  assign io_oled_csn = _zz_9;
  assign io_oled_resn = _zz_13;
  assign io_oled_dc = _zz_12;
  assign io_oled_mosi = _zz_11;
  assign io_oled_clk = _zz_10;
  always @ (*) begin
    io_address = (13'b0000000000000);
    if(_zz_17)begin
      if(_zz_15)begin
        if(inWindow)begin
          io_address = (windowAddress + {{(3'b000),tileY[7 : 3]},tileX[7 : 3]});
        end else begin
          io_address = (bgScrnAddress + {{(3'b000),tileY[7 : 3]},tileX[7 : 3]});
        end
      end else begin
        if(_zz_14)begin
          io_address = (textureAddress + {{{(1'b0),io_dataIn},tileY[2 : 0]},(1'b0)});
        end else begin
          if(_zz_16)begin
            io_address = (textureAddress + {{{(1'b0),tile},tileY[2 : 0]},(1'b1)});
          end
        end
      end
    end
  end

  assign bgScrnAddress = (io_lcdControl[3] ? (13'b1110000000000) : (13'b1100000000000));
  assign windowAddress = (io_lcdControl[6] ? (13'b1110000000000) : (13'b1100000000000));
  assign showWindow = io_lcdControl[5];
  assign windowPriority = io_lcdControl[0];
  assign textureAddress = (io_lcdControl[4] ? (13'b0000000000000) : (13'b0100000000000));
  assign inWindow = ((showWindow && (io_windowX <= x)) && (io_windowY <= y));
  assign bgOn = io_lcdControl[0];
  assign tileX = (io_startX + x);
  assign tileY = (io_startY + y);
  assign bitx = tileX[2 : 0];
  assign bit0 = texture0[_zz_18];
  assign bit1 = texture1[_zz_19];
  assign color = {bit1,bit0};
  assign _zz_3 = _zz_4;
  assign _zz_2 = (((x < (8'b10100000)) && (y < (8'b10010000))) && io_lcdControl[7]);
  always @ (posedge clkout0 or negedge _zz_1) begin
    if (!_zz_1) begin
      mode <= (2'b00);
      x <= (8'b10001100);
      y <= (8'b00011110);
    end else begin
      mode <= (((8'b10001111) < y) ? (2'b01) : (2'b00));
      if(_zz_5)begin
        x <= (x + (8'b00000001));
        if((x == (8'b10011111)))begin
          x <= (8'b00000000);
          y <= (y + (8'b00000001));
          if((y == (8'b10011001)))begin
            y <= (8'b00000000);
          end
        end
      end
    end
  end

  always @ (posedge clkout0) begin
    bitCycle <= (bitCycle + (2'b01));
    if(_zz_17)begin
      if(! _zz_15) begin
        if(_zz_14)begin
          tile <= io_dataIn;
        end else begin
          if(_zz_16)begin
            if(bgOn)begin
              texture0 <= io_dataIn;
            end else begin
              texture0 <= (8'b00000000);
            end
          end else begin
            if((bitCycle == (2'b11)))begin
              if(bgOn)begin
                texture1 <= io_dataIn;
              end else begin
                texture1 <= (8'b00000000);
              end
            end
          end
        end
      end
    end
    if(_zz_5)begin
      bitCycle <= (2'b00);
    end
  end

endmodule

module GameBoy16Ulx3s (
      output  io_oled_csn,
      output  io_oled_resn,
      output  io_oled_dc,
      output  io_oled_mosi,
      output  io_oled_clk,
      output [7:0] io_led,
      input  [3:0] io_btn,
      input   clkout0,
      input   _zz_4);
  reg [7:0] _zz_5;
  wire [7:0] _zz_6;
  wire [7:0] _zz_7;
  wire [15:0] _zz_8;
  wire [7:0] _zz_9;
  wire  _zz_10;
  wire  _zz_11;
  wire  _zz_12;
  wire [7:0] _zz_13;
  wire  _zz_14;
  wire  _zz_15;
  wire  _zz_16;
  wire  _zz_17;
  wire  _zz_18;
  wire [12:0] _zz_19;
  wire [1:0] _zz_20;
  wire [7:0] _zz_21;
  wire [7:0] _zz_22;
  wire  _zz_23;
  wire [1:0] _zz_24;
  wire [12:0] _zz_25;
  wire [15:0] _zz_26;
  wire [12:0] _zz_27;
  wire [12:0] _zz_28;
  wire [7:0] _zz_29;
  wire [7:0] _zz_30;
  reg  _zz_1;
  reg  _zz_2;
  reg [15:0] address;
  reg [7:0] dataIn;
  reg [7:0] ppuIn;
  reg [7:0] rLCDC;
  reg [7:0] rSTAT;
  reg [7:0] rSCY;
  reg [7:0] rSCX;
  reg [7:0] rLY;
  reg [7:0] rLYC;
  reg [7:0] rDMA;
  reg [7:0] rBGP;
  reg [7:0] rOBP0;
  reg [7:0] rOBP1;
  reg [7:0] rWY;
  reg [7:0] rWX;
  reg [7:0] rJOYP;
  reg [1:0] rButtonSelect;
  reg [7:0] rDIV;
  reg [7:0] rTIMA;
  reg [7:0] rTMA;
  reg [7:0] rTAC;
  reg [11:0] timer;
  wire [15:0] _zz_3;
  reg [7:0] memory [0:6655];
  reg [7:0] vidMem [0:8191];
  assign _zz_23 = (((16'b1000000000000000) <= _zz_8) && (_zz_8 < (16'b1010000000000000)));
  assign _zz_24 = rTAC[1 : 0];
  assign _zz_25 = _zz_3[12:0];
  assign _zz_26 = (_zz_8 - (16'b1000000000000000));
  assign _zz_27 = _zz_26[12:0];
  assign _zz_28 = address[12:0];
  assign _zz_29 = _zz_9;
  assign _zz_30 = _zz_9;
  initial begin
    $readmemb("GameBoyUlx3s.v_toplevel_coreClockingArea_gameboy_memory.bin",memory);
  end
  always @ (posedge clkout0) begin
    if(_zz_1) begin
      memory[_zz_28] <= _zz_29;
    end
  end

  assign _zz_6 = memory[_zz_25];
  always @ (posedge clkout0) begin
    if(_zz_2) begin
      vidMem[_zz_27] <= _zz_30;
    end
  end

  assign _zz_7 = vidMem[_zz_19];
  Cpu cpu_1 ( 
    .io_address(_zz_8),
    .io_dataIn(_zz_5),
    .io_dataOut(_zz_9),
    .io_mreq(_zz_10),
    .io_write(_zz_11),
    .io_halt(_zz_12),
    .io_diag(_zz_13),
    .clkout0(clkout0),
    ._zz_2(_zz_4) 
  );
  PPUUlx3s ppu ( 
    .io_oled_csn(_zz_14),
    .io_oled_resn(_zz_15),
    .io_oled_dc(_zz_16),
    .io_oled_mosi(_zz_17),
    .io_oled_clk(_zz_18),
    .io_address(_zz_19),
    .io_lcdControl(rLCDC),
    .io_startX(rSCX),
    .io_startY(rSCY),
    .io_windowX(rWX),
    .io_windowY(rWY),
    .io_bgPalette(rBGP),
    .io_mode(_zz_20),
    .io_currentY(_zz_21),
    .io_dataIn(ppuIn),
    .io_diag(_zz_22),
    .clkout0(clkout0),
    ._zz_1(_zz_4) 
  );
  always @ (*) begin
    _zz_1 = 1'b0;
    _zz_2 = 1'b0;
    if(_zz_11)begin
      if(_zz_23)begin
        _zz_2 = 1'b1;
      end else begin
        _zz_1 = 1'b1;
      end
    end
  end

  assign io_oled_csn = 1'b1;
  assign io_oled_resn = _zz_15;
  assign io_oled_dc = _zz_16;
  assign io_oled_mosi = _zz_17;
  assign io_oled_clk = _zz_18;
  always @ (*) begin
    if(((16'b1111111000000000) <= _zz_8))begin
      address = (_zz_8 - (16'b1110011000000000));
    end else begin
      if(((16'b1100000000000000) <= _zz_8))begin
        address = (_zz_8 - (16'b1011000000000000));
      end else begin
        address = _zz_8;
      end
    end
  end

  assign _zz_3 = address;
  always @ (*) begin
    case(_zz_8)
      16'b1111111101000000 : begin
        _zz_5 = (rLCDC & (8'b01111111));
      end
      16'b1111111101000001 : begin
        _zz_5 = {{rSTAT[7 : 3],(rLY == rLYC)},_zz_20};
      end
      16'b1111111101000010 : begin
        _zz_5 = rSCY;
      end
      16'b1111111101000011 : begin
        _zz_5 = rSCX;
      end
      16'b1111111101000100 : begin
        _zz_5 = rLY;
      end
      16'b1111111101000101 : begin
        _zz_5 = rLYC;
      end
      16'b1111111101000110 : begin
        _zz_5 = rDMA;
      end
      16'b1111111101000111 : begin
        _zz_5 = rBGP;
      end
      16'b1111111101001000 : begin
        _zz_5 = rOBP0;
      end
      16'b1111111101001001 : begin
        _zz_5 = rOBP1;
      end
      16'b1111111101001010 : begin
        _zz_5 = rWY;
      end
      16'b1111111101001011 : begin
        _zz_5 = rWX;
      end
      16'b1111111100000100 : begin
        _zz_5 = rDIV;
      end
      16'b1111111100000101 : begin
        _zz_5 = rTIMA;
      end
      16'b1111111100000110 : begin
        _zz_5 = rTMA;
      end
      16'b1111111100000111 : begin
        _zz_5 = rTAC;
      end
      16'b1111111100000000 : begin
        _zz_5 = rJOYP;
      end
      default : begin
        _zz_5 = dataIn;
      end
    endcase
  end

  assign io_led = _zz_13;
  always @ (posedge clkout0) begin
    ppuIn <= _zz_7;
    timer <= (timer + (12'b000000000001));
    if(((timer & (12'b001111111111)) == (12'b000000000000)))begin
      rDIV <= (rDIV + (8'b00000001));
    end
    if(rTAC[2])begin
      case(_zz_24)
        2'b00 : begin
          if(((timer & (12'b111111111111)) == (12'b000000000000)))begin
            rTIMA <= (rTIMA + (8'b00000001));
          end
        end
        2'b01 : begin
          if(((timer & (12'b000000111111)) == (12'b000000000000)))begin
            rTIMA <= (rTIMA + (8'b00000001));
          end
        end
        2'b10 : begin
          if(((timer & (12'b000011111111)) == (12'b000000000000)))begin
            rTIMA <= (rTIMA + (8'b00000001));
          end
        end
        default : begin
          if(((timer & (12'b001111111111)) == (12'b000000000000)))begin
            rTIMA <= (rTIMA + (8'b00000001));
          end
        end
      endcase
      if((rTIMA == (8'b11111111)))begin
        rTIMA <= rTMA;
      end
    end
    rJOYP <= {{(2'b00),rButtonSelect},io_btn};
    rLY <= _zz_21;
    dataIn <= _zz_6;
    if(_zz_11)begin
      if(! _zz_23) begin
        case(_zz_8)
          16'b1111111101000000 : begin
            rLCDC <= _zz_9;
          end
          16'b1111111101000001 : begin
            rSTAT <= _zz_9;
          end
          16'b1111111101000010 : begin
            rSCY <= _zz_9;
          end
          16'b1111111101000011 : begin
            rSCX <= _zz_9;
          end
          16'b1111111101000101 : begin
            rLYC <= _zz_9;
          end
          16'b1111111101000110 : begin
            rDMA <= _zz_9;
          end
          16'b1111111101000111 : begin
            rBGP <= _zz_9;
          end
          16'b1111111101001000 : begin
            rOBP0 <= _zz_9;
          end
          16'b1111111101001001 : begin
            rOBP1 <= _zz_9;
          end
          16'b1111111101001010 : begin
            rWY <= _zz_9;
          end
          16'b1111111101001011 : begin
            rWX <= _zz_9;
          end
          16'b1111111100000100 : begin
            rDIV <= (8'b00000000);
          end
          16'b1111111100000101 : begin
            rTIMA <= _zz_9;
          end
          16'b1111111100000110 : begin
            rTMA <= _zz_9;
          end
          16'b1111111100000111 : begin
            rTAC <= _zz_9;
          end
          16'b1111111100000000 : begin
            rButtonSelect <= _zz_9[5 : 4];
          end
          default : begin
          end
        endcase
      end
    end
  end

endmodule

module GameBoyUlx3s (
      input   clk_25mhz,
      output  oled_csn,
      output  oled_resn,
      output  oled_dc,
      output  oled_mosi,
      output  oled_clk,
      output [7:0] led,
      input  [6:0] btn);
  wire [3:0] _zz_2;
  wire  _zz_3;
  wire  _zz_4;
  wire  _zz_5;
  wire  _zz_6;
  wire  _zz_7;
  wire  _zz_8;
  wire  _zz_9;
  wire [7:0] _zz_10;
  wire  _zz_1;
  pll pll_1 ( 
    .clkin(clk_25mhz),
    .clkout0(_zz_3),
    .locked(_zz_4) 
  );
  GameBoy16Ulx3s coreClockingArea_gameboy ( 
    .io_oled_csn(_zz_5),
    .io_oled_resn(_zz_6),
    .io_oled_dc(_zz_7),
    .io_oled_mosi(_zz_8),
    .io_oled_clk(_zz_9),
    .io_led(_zz_10),
    .io_btn(_zz_2),
    .clkout0(_zz_3),
    ._zz_4(_zz_1) 
  );
  assign _zz_1 = btn[0];
  assign oled_csn = _zz_5;
  assign oled_resn = _zz_6;
  assign oled_dc = _zz_7;
  assign oled_mosi = _zz_8;
  assign oled_clk = _zz_9;
  assign led = _zz_10;
  assign _zz_2 = btn[4 : 1];
endmodule

