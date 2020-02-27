// Generator : SpinalHDL v1.1.6    git head : 369ec039630c441c429b64ffc0a9ec31d21b7196
// Date      : 27/02/2020, 11:57:47
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
`define AluOp_binary_sequancial_Sub1 6'b001001
`define AluOp_binary_sequancial_Sbc1 6'b001010
`define AluOp_binary_sequancial_Inc 6'b001011
`define AluOp_binary_sequancial_Dec 6'b001100
`define AluOp_binary_sequancial_Cpl 6'b001101
`define AluOp_binary_sequancial_Ccf 6'b001110
`define AluOp_binary_sequancial_Scf 6'b001111
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

`define AddrOp_binary_sequancial_type [2:0]
`define AddrOp_binary_sequancial_Nop 3'b000
`define AddrOp_binary_sequancial_Inc 3'b001
`define AddrOp_binary_sequancial_Dec 3'b010
`define AddrOp_binary_sequancial_Rst 3'b011
`define AddrOp_binary_sequancial_ToPC 3'b100
`define AddrOp_binary_sequancial_R8 3'b101
`define AddrOp_binary_sequancial_HLR8 3'b110

`define tCycleFsm_enumDefinition_binary_sequancial_type [2:0]
`define tCycleFsm_enumDefinition_binary_sequancial_boot 3'b000
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t1State 3'b001
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t2State 3'b010
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t3State 3'b011
`define tCycleFsm_enumDefinition_binary_sequancial_tCycleFsm_t4State 3'b100

module Sprite (
      input  [5:0] io_index,
      input  [7:0] io_x,
      input  [7:0] io_y,
      input   io_size16,
      input  [1:0] io_ds,
      input  [7:0] io_data,
      output  io_pixelActive,
      output [1:0] io_pixelData,
      output [10:0] io_addr,
      input   io_oamWr,
      input  [1:0] io_oamAddr,
      input  [7:0] io_oamDi,
      output reg [7:0] io_oamDo,
      output [7:0] io_diag,
      input   clkout0,
      input   _zz_1);
  wire [1:0] _zz_2;
  wire [7:0] _zz_3;
  wire [7:0] _zz_4;
  wire [7:0] _zz_5;
  wire [7:0] _zz_6;
  reg [7:0] yPos;
  reg [7:0] xPos;
  reg [7:0] tile;
  reg [7:0] flags;
  reg [7:0] data0;
  reg [7:0] data1;
  wire [7:0] height;
  wire  yVisible;
  wire  xVisible;
  wire  visible;
  wire [7:0] colN;
  wire [2:0] col;
  wire [7:0] rowN;
  wire [3:0] row;
  wire [10:0] addr8;
  wire [10:0] addr16;
  assign io_pixelData = _zz_2;
  assign _zz_3 = (io_y + (8'b00010000));
  assign _zz_4 = (io_y + (8'b00010000));
  assign _zz_5 = (yPos + height);
  assign _zz_6 = (io_x + (8'b00001000));
  assign io_diag = tile;
  assign height = (io_size16 ? (8'b00010000) : (8'b00001000));
  assign yVisible = ((yPos <= _zz_3) && (_zz_4 < _zz_5));
  assign xVisible = ((xPos <= _zz_6) && (io_x < xPos));
  assign visible = (yVisible && xVisible);
  assign colN = (io_x - xPos);
  assign col = (flags[5] ? colN[2 : 0] : (~ colN[2 : 0]));
  assign _zz_2 = {data1[col],data0[col]};
  assign io_pixelActive = ((_zz_2 != (2'b00)) && visible);
  assign rowN = (io_y - yPos);
  assign row = (flags[6] ? (~ rowN[3 : 0]) : rowN[3 : 0]);
  assign addr8 = {tile,row[2 : 0]};
  assign addr16 = {tile[7 : 1],row};
  assign io_addr = (io_size16 ? addr16 : addr8);
  always @ (*) begin
    case(io_oamAddr)
      2'b00 : begin
        io_oamDo = yPos;
      end
      2'b01 : begin
        io_oamDo = xPos;
      end
      2'b10 : begin
        io_oamDo = tile;
      end
      default : begin
        io_oamDo = flags;
      end
    endcase
  end

  always @ (posedge clkout0) begin
    if(io_ds[0])begin
      data0 <= io_data;
    end
    if(io_ds[1])begin
      data1 <= io_data;
    end
    if(io_oamWr)begin
      case(io_oamAddr)
        2'b00 : begin
          yPos <= io_oamDi;
        end
        2'b01 : begin
          xPos <= io_oamDi;
        end
        2'b10 : begin
          tile <= io_oamDi;
        end
        default : begin
          flags <= io_oamDi;
        end
      endcase
    end
  end

endmodule


//Sprite_1 remplaced by Sprite


//Sprite_2 remplaced by Sprite


//Sprite_3 remplaced by Sprite


//Sprite_4 remplaced by Sprite


//Sprite_5 remplaced by Sprite


//Sprite_6 remplaced by Sprite


//Sprite_7 remplaced by Sprite


//Sprite_8 remplaced by Sprite


//Sprite_9 remplaced by Sprite


//Sprite_10 remplaced by Sprite


//Sprite_11 remplaced by Sprite


//Sprite_12 remplaced by Sprite


//Sprite_13 remplaced by Sprite


//Sprite_14 remplaced by Sprite


//Sprite_15 remplaced by Sprite


//Sprite_16 remplaced by Sprite


//Sprite_17 remplaced by Sprite


//Sprite_18 remplaced by Sprite


//Sprite_19 remplaced by Sprite


//Sprite_20 remplaced by Sprite


//Sprite_21 remplaced by Sprite


//Sprite_22 remplaced by Sprite


//Sprite_23 remplaced by Sprite


//Sprite_24 remplaced by Sprite


//Sprite_25 remplaced by Sprite


//Sprite_26 remplaced by Sprite


//Sprite_27 remplaced by Sprite


//Sprite_28 remplaced by Sprite


//Sprite_29 remplaced by Sprite


//Sprite_30 remplaced by Sprite


//Sprite_31 remplaced by Sprite


//Sprite_32 remplaced by Sprite


//Sprite_33 remplaced by Sprite


//Sprite_34 remplaced by Sprite


//Sprite_35 remplaced by Sprite


//Sprite_36 remplaced by Sprite


//Sprite_37 remplaced by Sprite


//Sprite_38 remplaced by Sprite


//Sprite_39 remplaced by Sprite

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
      end
      if(((io_ir == (8'b01000001)) || ((io_ir == (8'b01001001)) || ((io_ir == (8'b01010001)) || ((io_ir == (8'b01011001)) || ((io_ir == (8'b01100001)) || ((io_ir == (8'b01101001)) || ((io_ir == (8'b01110001)) || (io_ir == (8'b01111001))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0101);
        io_loadOpB = 1'b1;
      end
      if(((io_ir == (8'b01000010)) || ((io_ir == (8'b01001010)) || ((io_ir == (8'b01010010)) || ((io_ir == (8'b01011010)) || ((io_ir == (8'b01100010)) || ((io_ir == (8'b01101010)) || ((io_ir == (8'b01110010)) || (io_ir == (8'b01111010))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0110);
        io_loadOpB = 1'b1;
      end
      if(((io_ir == (8'b01000011)) || ((io_ir == (8'b01001011)) || ((io_ir == (8'b01010011)) || ((io_ir == (8'b01011011)) || ((io_ir == (8'b01100011)) || ((io_ir == (8'b01101011)) || ((io_ir == (8'b01110011)) || (io_ir == (8'b01111011))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b0111);
        io_loadOpB = 1'b1;
      end
      if(((io_ir == (8'b01000100)) || ((io_ir == (8'b01001100)) || ((io_ir == (8'b01010100)) || ((io_ir == (8'b01011100)) || ((io_ir == (8'b01100100)) || ((io_ir == (8'b01101100)) || ((io_ir == (8'b01110100)) || (io_ir == (8'b01111100))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b1000);
        io_loadOpB = 1'b1;
      end
      if(((io_ir == (8'b01000101)) || ((io_ir == (8'b01001101)) || ((io_ir == (8'b01010101)) || ((io_ir == (8'b01011101)) || ((io_ir == (8'b01100101)) || ((io_ir == (8'b01101101)) || ((io_ir == (8'b01110101)) || (io_ir == (8'b01111101))))))))))begin
        io_aluOp = `AluOp_binary_sequancial_Bit_1;
        io_opBSelect = (4'b1001);
        io_loadOpB = 1'b1;
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
          io_aluOp = `AluOp_binary_sequancial_Sub1;
          io_opBSelect = (4'b0101);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0101);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sbc1;
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
          io_aluOp = `AluOp_binary_sequancial_Sub1;
          io_opBSelect = (4'b0111);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b0111);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sbc1;
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
          io_aluOp = `AluOp_binary_sequancial_Sub1;
          io_opBSelect = (4'b1001);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1001);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sbc1;
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
          io_aluOp = `AluOp_binary_sequancial_Sub1;
          io_opBSelect = (4'b1011);
          io_loadOpB = 1'b1;
          io_storeSelect = (4'b1011);
          io_store = 1'b1;
          io_memWrite = 1'b0;
          io_nextMCycle = (io_mCycle + (3'b001));
        end
        if((io_mCycle == (3'b001)))begin
          io_aluOp = `AluOp_binary_sequancial_Sbc1;
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
      input  [7:0] io_ir,
      input   clkout0,
      input   _zz_1);
  wire [8:0] _zz_2;
  wire [8:0] _zz_3;
  wire [8:0] _zz_4;
  wire [8:0] _zz_5;
  wire [8:0] _zz_6;
  wire [0:0] _zz_7;
  wire [8:0] _zz_8;
  wire [0:0] _zz_9;
  wire [8:0] _zz_10;
  wire [8:0] _zz_11;
  wire [0:0] _zz_12;
  wire [8:0] _zz_13;
  wire [0:0] _zz_14;
  wire [8:0] _zz_15;
  wire [8:0] _zz_16;
  wire [8:0] _zz_17;
  reg [8:0] wideResult;
  wire [8:0] wideOpA;
  wire [8:0] wideOpB;
  wire  carry;
  wire  halfCarry;
  wire  halfBorrow;
  reg  saveCarry;
  assign _zz_2 = wideResult;
  assign _zz_3 = wideResult;
  assign _zz_4 = wideResult;
  assign _zz_5 = wideResult;
  assign _zz_6 = (wideOpA + wideOpB);
  assign _zz_7 = io_flagsIn[4];
  assign _zz_8 = {8'd0, _zz_7};
  assign _zz_9 = saveCarry;
  assign _zz_10 = {8'd0, _zz_9};
  assign _zz_11 = (wideOpA - wideOpB);
  assign _zz_12 = io_flagsIn[4];
  assign _zz_13 = {8'd0, _zz_12};
  assign _zz_14 = saveCarry;
  assign _zz_15 = {8'd0, _zz_14};
  assign _zz_16 = ((9'b000000001) <<< io_ir[5 : 3]);
  assign _zz_17 = ((9'b000000001) <<< io_ir[5 : 3]);
  assign io_result = wideResult[7 : 0];
  assign wideOpA = {1'd0, io_operandA};
  assign wideOpB = {1'd0, io_operandB};
  assign carry = wideResult[8];
  assign halfCarry = (_zz_2[4] && (_zz_3[3 : 0] == (4'b0000)));
  assign halfBorrow = ((! _zz_4[4]) && (_zz_5[3 : 0] == (4'b1111)));
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
      end
      `AluOp_binary_sequancial_Adc : begin
        wideResult = (_zz_6 + _zz_8);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfCarry;
        io_flagsOut[6] = 1'b0;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Adc1 : begin
        wideResult = (wideOpB + _zz_10);
      end
      `AluOp_binary_sequancial_Sub : begin
        wideResult = (wideOpA - wideOpB);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfBorrow;
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Sbc : begin
        wideResult = (_zz_11 - _zz_13);
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfBorrow;
        io_flagsOut[6] = 1'b1;
        io_flagsOut[7] = (wideResult[7 : 0] == (8'b00000000));
      end
      `AluOp_binary_sequancial_Sub1 : begin
        wideResult = (wideOpB - (9'b000000001));
      end
      `AluOp_binary_sequancial_Sbc1 : begin
        wideResult = (wideOpB - _zz_15);
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
        io_flagsOut[4] = carry;
        io_flagsOut[5] = halfCarry;
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
      `AluOp_binary_sequancial_Dec : begin
        wideResult = (wideOpB - (9'b000000001));
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
        wideResult = (wideOpB | _zz_16);
        io_flagsOut = io_flagsIn;
      end
      default : begin
        wideResult = (wideOpB & (~ _zz_17));
        io_flagsOut = io_flagsIn;
      end
    endcase
  end

  always @ (posedge clkout0) begin
    case(io_op)
      `AluOp_binary_sequancial_Nop : begin
      end
      `AluOp_binary_sequancial_Add : begin
      end
      `AluOp_binary_sequancial_Add1 : begin
        saveCarry <= carry;
      end
      `AluOp_binary_sequancial_Adc : begin
      end
      `AluOp_binary_sequancial_Adc1 : begin
      end
      `AluOp_binary_sequancial_Sub : begin
      end
      `AluOp_binary_sequancial_Sbc : begin
      end
      `AluOp_binary_sequancial_Sub1 : begin
        saveCarry <= carry;
      end
      `AluOp_binary_sequancial_Sbc1 : begin
      end
      `AluOp_binary_sequancial_And_1 : begin
      end
      `AluOp_binary_sequancial_Xor_1 : begin
      end
      `AluOp_binary_sequancial_Or_1 : begin
      end
      `AluOp_binary_sequancial_Cp : begin
      end
      `AluOp_binary_sequancial_Inc : begin
      end
      `AluOp_binary_sequancial_Dec : begin
      end
      `AluOp_binary_sequancial_Cpl : begin
      end
      `AluOp_binary_sequancial_Ccf : begin
      end
      `AluOp_binary_sequancial_Scf : begin
      end
      `AluOp_binary_sequancial_Swap : begin
      end
      `AluOp_binary_sequancial_Rlca : begin
      end
      `AluOp_binary_sequancial_Rlc : begin
      end
      `AluOp_binary_sequancial_Rrca : begin
      end
      `AluOp_binary_sequancial_Rrc : begin
      end
      `AluOp_binary_sequancial_Rla : begin
      end
      `AluOp_binary_sequancial_Rl : begin
      end
      `AluOp_binary_sequancial_Rra : begin
      end
      `AluOp_binary_sequancial_Rr : begin
      end
      `AluOp_binary_sequancial_Sla_1 : begin
      end
      `AluOp_binary_sequancial_Sra_1 : begin
      end
      `AluOp_binary_sequancial_Srl_1 : begin
      end
      `AluOp_binary_sequancial_Bit_1 : begin
      end
      `AluOp_binary_sequancial_Set : begin
      end
      default : begin
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
  assign _zz_7 = (! byteToggle);
  assign _zz_8 = (initCnt[10 : 4] != (7'b0100100));
  assign _zz_9 = (initCnt[3 : 0] == (4'b0000));
  assign _zz_10 = (! resetCnt[22]);
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
    if(! _zz_10) begin
      if(! _zz_6) begin
        if(_zz_8)begin
          if(_zz_9)begin
            if(! init) begin
              if(_zz_7)begin
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
      if(_zz_10)begin
        resetCnt <= (resetCnt + (23'b00000000000000000000001));
      end else begin
        if(_zz_6)begin
          delayCnt <= (delayCnt - (25'b0000000000000000000000001));
        end else begin
          if(_zz_8)begin
            initCnt <= (initCnt + (11'b00000000001));
            if(_zz_9)begin
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
                if(_zz_7)begin
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
    if(! _zz_10) begin
      if(! _zz_6) begin
        if(_zz_8)begin
          if(_zz_9)begin
            if(! init) begin
              if(_zz_7)begin
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

module Sprites (
      input  [3:0] io_index,
      input   io_size16,
      input  [7:0] io_x,
      input  [7:0] io_y,
      input  [1:0] io_dValid,
      input  [7:0] io_data,
      output  io_pixelActive,
      output [1:0] io_pixelData,
      output  io_pixelPrio,
      output [10:0] io_addr,
      input   io_oamWr,
      input  [7:0] io_oamAddr,
      input  [7:0] io_oamDi,
      output [7:0] io_oamDo,
      output [7:0] io_diag,
      input   clkout0,
      input   _zz_1);
  wire [5:0] _zz_2;
  wire  _zz_3;
  wire [1:0] _zz_4;
  wire [5:0] _zz_5;
  wire  _zz_6;
  wire [1:0] _zz_7;
  wire [5:0] _zz_8;
  wire  _zz_9;
  wire [1:0] _zz_10;
  wire [5:0] _zz_11;
  wire  _zz_12;
  wire [1:0] _zz_13;
  wire [5:0] _zz_14;
  wire  _zz_15;
  wire [1:0] _zz_16;
  wire [5:0] _zz_17;
  wire  _zz_18;
  wire [1:0] _zz_19;
  wire [5:0] _zz_20;
  wire  _zz_21;
  wire [1:0] _zz_22;
  wire [5:0] _zz_23;
  wire  _zz_24;
  wire [1:0] _zz_25;
  wire [5:0] _zz_26;
  wire  _zz_27;
  wire [1:0] _zz_28;
  wire [5:0] _zz_29;
  wire  _zz_30;
  wire [1:0] _zz_31;
  wire [5:0] _zz_32;
  wire  _zz_33;
  wire [1:0] _zz_34;
  wire [5:0] _zz_35;
  wire  _zz_36;
  wire [1:0] _zz_37;
  wire [5:0] _zz_38;
  wire  _zz_39;
  wire [1:0] _zz_40;
  wire [5:0] _zz_41;
  wire  _zz_42;
  wire [1:0] _zz_43;
  wire [5:0] _zz_44;
  wire  _zz_45;
  wire [1:0] _zz_46;
  wire [5:0] _zz_47;
  wire  _zz_48;
  wire [1:0] _zz_49;
  wire [5:0] _zz_50;
  wire  _zz_51;
  wire [1:0] _zz_52;
  wire [5:0] _zz_53;
  wire  _zz_54;
  wire [1:0] _zz_55;
  wire [5:0] _zz_56;
  wire  _zz_57;
  wire [1:0] _zz_58;
  wire [5:0] _zz_59;
  wire  _zz_60;
  wire [1:0] _zz_61;
  wire [5:0] _zz_62;
  wire  _zz_63;
  wire [1:0] _zz_64;
  wire [5:0] _zz_65;
  wire  _zz_66;
  wire [1:0] _zz_67;
  wire [5:0] _zz_68;
  wire  _zz_69;
  wire [1:0] _zz_70;
  wire [5:0] _zz_71;
  wire  _zz_72;
  wire [1:0] _zz_73;
  wire [5:0] _zz_74;
  wire  _zz_75;
  wire [1:0] _zz_76;
  wire [5:0] _zz_77;
  wire  _zz_78;
  wire [1:0] _zz_79;
  wire [5:0] _zz_80;
  wire  _zz_81;
  wire [1:0] _zz_82;
  wire [5:0] _zz_83;
  wire  _zz_84;
  wire [1:0] _zz_85;
  wire [5:0] _zz_86;
  wire  _zz_87;
  wire [1:0] _zz_88;
  wire [5:0] _zz_89;
  wire  _zz_90;
  wire [1:0] _zz_91;
  wire [5:0] _zz_92;
  wire  _zz_93;
  wire [1:0] _zz_94;
  wire [5:0] _zz_95;
  wire  _zz_96;
  wire [1:0] _zz_97;
  wire [5:0] _zz_98;
  wire  _zz_99;
  wire [1:0] _zz_100;
  wire [5:0] _zz_101;
  wire  _zz_102;
  wire [1:0] _zz_103;
  wire [5:0] _zz_104;
  wire  _zz_105;
  wire [1:0] _zz_106;
  wire [5:0] _zz_107;
  wire  _zz_108;
  wire [1:0] _zz_109;
  wire [5:0] _zz_110;
  wire  _zz_111;
  wire [1:0] _zz_112;
  wire [5:0] _zz_113;
  wire  _zz_114;
  wire [1:0] _zz_115;
  wire [5:0] _zz_116;
  wire  _zz_117;
  wire [1:0] _zz_118;
  wire [5:0] _zz_119;
  wire  _zz_120;
  wire [1:0] _zz_121;
  reg [5:0] _zz_122;
  reg [10:0] _zz_123;
  reg [7:0] _zz_124;
  reg [1:0] _zz_125;
  reg [1:0] _zz_126;
  reg [1:0] _zz_127;
  reg [1:0] _zz_128;
  reg [1:0] _zz_129;
  reg [1:0] _zz_130;
  reg [1:0] _zz_131;
  reg [1:0] _zz_132;
  reg [1:0] _zz_133;
  reg [1:0] _zz_134;
  wire  _zz_135;
  wire [1:0] _zz_136;
  wire [10:0] _zz_137;
  wire [7:0] _zz_138;
  wire [7:0] _zz_139;
  wire  _zz_140;
  wire [1:0] _zz_141;
  wire [10:0] _zz_142;
  wire [7:0] _zz_143;
  wire [7:0] _zz_144;
  wire  _zz_145;
  wire [1:0] _zz_146;
  wire [10:0] _zz_147;
  wire [7:0] _zz_148;
  wire [7:0] _zz_149;
  wire  _zz_150;
  wire [1:0] _zz_151;
  wire [10:0] _zz_152;
  wire [7:0] _zz_153;
  wire [7:0] _zz_154;
  wire  _zz_155;
  wire [1:0] _zz_156;
  wire [10:0] _zz_157;
  wire [7:0] _zz_158;
  wire [7:0] _zz_159;
  wire  _zz_160;
  wire [1:0] _zz_161;
  wire [10:0] _zz_162;
  wire [7:0] _zz_163;
  wire [7:0] _zz_164;
  wire  _zz_165;
  wire [1:0] _zz_166;
  wire [10:0] _zz_167;
  wire [7:0] _zz_168;
  wire [7:0] _zz_169;
  wire  _zz_170;
  wire [1:0] _zz_171;
  wire [10:0] _zz_172;
  wire [7:0] _zz_173;
  wire [7:0] _zz_174;
  wire  _zz_175;
  wire [1:0] _zz_176;
  wire [10:0] _zz_177;
  wire [7:0] _zz_178;
  wire [7:0] _zz_179;
  wire  _zz_180;
  wire [1:0] _zz_181;
  wire [10:0] _zz_182;
  wire [7:0] _zz_183;
  wire [7:0] _zz_184;
  wire  _zz_185;
  wire [1:0] _zz_186;
  wire [10:0] _zz_187;
  wire [7:0] _zz_188;
  wire [7:0] _zz_189;
  wire  _zz_190;
  wire [1:0] _zz_191;
  wire [10:0] _zz_192;
  wire [7:0] _zz_193;
  wire [7:0] _zz_194;
  wire  _zz_195;
  wire [1:0] _zz_196;
  wire [10:0] _zz_197;
  wire [7:0] _zz_198;
  wire [7:0] _zz_199;
  wire  _zz_200;
  wire [1:0] _zz_201;
  wire [10:0] _zz_202;
  wire [7:0] _zz_203;
  wire [7:0] _zz_204;
  wire  _zz_205;
  wire [1:0] _zz_206;
  wire [10:0] _zz_207;
  wire [7:0] _zz_208;
  wire [7:0] _zz_209;
  wire  _zz_210;
  wire [1:0] _zz_211;
  wire [10:0] _zz_212;
  wire [7:0] _zz_213;
  wire [7:0] _zz_214;
  wire  _zz_215;
  wire [1:0] _zz_216;
  wire [10:0] _zz_217;
  wire [7:0] _zz_218;
  wire [7:0] _zz_219;
  wire  _zz_220;
  wire [1:0] _zz_221;
  wire [10:0] _zz_222;
  wire [7:0] _zz_223;
  wire [7:0] _zz_224;
  wire  _zz_225;
  wire [1:0] _zz_226;
  wire [10:0] _zz_227;
  wire [7:0] _zz_228;
  wire [7:0] _zz_229;
  wire  _zz_230;
  wire [1:0] _zz_231;
  wire [10:0] _zz_232;
  wire [7:0] _zz_233;
  wire [7:0] _zz_234;
  wire  _zz_235;
  wire [1:0] _zz_236;
  wire [10:0] _zz_237;
  wire [7:0] _zz_238;
  wire [7:0] _zz_239;
  wire  _zz_240;
  wire [1:0] _zz_241;
  wire [10:0] _zz_242;
  wire [7:0] _zz_243;
  wire [7:0] _zz_244;
  wire  _zz_245;
  wire [1:0] _zz_246;
  wire [10:0] _zz_247;
  wire [7:0] _zz_248;
  wire [7:0] _zz_249;
  wire  _zz_250;
  wire [1:0] _zz_251;
  wire [10:0] _zz_252;
  wire [7:0] _zz_253;
  wire [7:0] _zz_254;
  wire  _zz_255;
  wire [1:0] _zz_256;
  wire [10:0] _zz_257;
  wire [7:0] _zz_258;
  wire [7:0] _zz_259;
  wire  _zz_260;
  wire [1:0] _zz_261;
  wire [10:0] _zz_262;
  wire [7:0] _zz_263;
  wire [7:0] _zz_264;
  wire  _zz_265;
  wire [1:0] _zz_266;
  wire [10:0] _zz_267;
  wire [7:0] _zz_268;
  wire [7:0] _zz_269;
  wire  _zz_270;
  wire [1:0] _zz_271;
  wire [10:0] _zz_272;
  wire [7:0] _zz_273;
  wire [7:0] _zz_274;
  wire  _zz_275;
  wire [1:0] _zz_276;
  wire [10:0] _zz_277;
  wire [7:0] _zz_278;
  wire [7:0] _zz_279;
  wire  _zz_280;
  wire [1:0] _zz_281;
  wire [10:0] _zz_282;
  wire [7:0] _zz_283;
  wire [7:0] _zz_284;
  wire  _zz_285;
  wire [1:0] _zz_286;
  wire [10:0] _zz_287;
  wire [7:0] _zz_288;
  wire [7:0] _zz_289;
  wire  _zz_290;
  wire [1:0] _zz_291;
  wire [10:0] _zz_292;
  wire [7:0] _zz_293;
  wire [7:0] _zz_294;
  wire  _zz_295;
  wire [1:0] _zz_296;
  wire [10:0] _zz_297;
  wire [7:0] _zz_298;
  wire [7:0] _zz_299;
  wire  _zz_300;
  wire [1:0] _zz_301;
  wire [10:0] _zz_302;
  wire [7:0] _zz_303;
  wire [7:0] _zz_304;
  wire  _zz_305;
  wire [1:0] _zz_306;
  wire [10:0] _zz_307;
  wire [7:0] _zz_308;
  wire [7:0] _zz_309;
  wire  _zz_310;
  wire [1:0] _zz_311;
  wire [10:0] _zz_312;
  wire [7:0] _zz_313;
  wire [7:0] _zz_314;
  wire  _zz_315;
  wire [1:0] _zz_316;
  wire [10:0] _zz_317;
  wire [7:0] _zz_318;
  wire [7:0] _zz_319;
  wire  _zz_320;
  wire [1:0] _zz_321;
  wire [10:0] _zz_322;
  wire [7:0] _zz_323;
  wire [7:0] _zz_324;
  wire  _zz_325;
  wire [1:0] _zz_326;
  wire [10:0] _zz_327;
  wire [7:0] _zz_328;
  wire [7:0] _zz_329;
  wire  _zz_330;
  wire [1:0] _zz_331;
  wire [10:0] _zz_332;
  wire [7:0] _zz_333;
  wire [7:0] _zz_334;
  wire [5:0] _zz_335;
  wire [5:0] _zz_336;
  wire [10:0] spriteAddr_0;
  wire [10:0] spriteAddr_1;
  wire [10:0] spriteAddr_2;
  wire [10:0] spriteAddr_3;
  wire [10:0] spriteAddr_4;
  wire [10:0] spriteAddr_5;
  wire [10:0] spriteAddr_6;
  wire [10:0] spriteAddr_7;
  wire [10:0] spriteAddr_8;
  wire [10:0] spriteAddr_9;
  wire [10:0] spriteAddr_10;
  wire [10:0] spriteAddr_11;
  wire [10:0] spriteAddr_12;
  wire [10:0] spriteAddr_13;
  wire [10:0] spriteAddr_14;
  wire [10:0] spriteAddr_15;
  wire [10:0] spriteAddr_16;
  wire [10:0] spriteAddr_17;
  wire [10:0] spriteAddr_18;
  wire [10:0] spriteAddr_19;
  wire [10:0] spriteAddr_20;
  wire [10:0] spriteAddr_21;
  wire [10:0] spriteAddr_22;
  wire [10:0] spriteAddr_23;
  wire [10:0] spriteAddr_24;
  wire [10:0] spriteAddr_25;
  wire [10:0] spriteAddr_26;
  wire [10:0] spriteAddr_27;
  wire [10:0] spriteAddr_28;
  wire [10:0] spriteAddr_29;
  wire [10:0] spriteAddr_30;
  wire [10:0] spriteAddr_31;
  wire [10:0] spriteAddr_32;
  wire [10:0] spriteAddr_33;
  wire [10:0] spriteAddr_34;
  wire [10:0] spriteAddr_35;
  wire [10:0] spriteAddr_36;
  wire [10:0] spriteAddr_37;
  wire [10:0] spriteAddr_38;
  wire [10:0] spriteAddr_39;
  reg [39:0] spritePixelActive;
  wire [39:0] spritePixelPrio;
  wire [1:0] spritePixelData_0;
  wire [1:0] spritePixelData_1;
  wire [1:0] spritePixelData_2;
  wire [1:0] spritePixelData_3;
  wire [1:0] spritePixelData_4;
  wire [1:0] spritePixelData_5;
  wire [1:0] spritePixelData_6;
  wire [1:0] spritePixelData_7;
  wire [1:0] spritePixelData_8;
  wire [1:0] spritePixelData_9;
  wire [1:0] spritePixelData_10;
  wire [1:0] spritePixelData_11;
  wire [1:0] spritePixelData_12;
  wire [1:0] spritePixelData_13;
  wire [1:0] spritePixelData_14;
  wire [1:0] spritePixelData_15;
  wire [1:0] spritePixelData_16;
  wire [1:0] spritePixelData_17;
  wire [1:0] spritePixelData_18;
  wire [1:0] spritePixelData_19;
  wire [1:0] spritePixelData_20;
  wire [1:0] spritePixelData_21;
  wire [1:0] spritePixelData_22;
  wire [1:0] spritePixelData_23;
  wire [1:0] spritePixelData_24;
  wire [1:0] spritePixelData_25;
  wire [1:0] spritePixelData_26;
  wire [1:0] spritePixelData_27;
  wire [1:0] spritePixelData_28;
  wire [1:0] spritePixelData_29;
  wire [1:0] spritePixelData_30;
  wire [1:0] spritePixelData_31;
  wire [1:0] spritePixelData_32;
  wire [1:0] spritePixelData_33;
  wire [1:0] spritePixelData_34;
  wire [1:0] spritePixelData_35;
  wire [1:0] spritePixelData_36;
  wire [1:0] spritePixelData_37;
  wire [1:0] spritePixelData_38;
  wire [1:0] spritePixelData_39;
  wire [5:0] spr0;
  wire [5:0] spr1;
  wire [5:0] spr2;
  wire [5:0] spr3;
  wire [5:0] spr4;
  wire [5:0] spr5;
  wire [5:0] spr6;
  wire [5:0] spr7;
  wire [5:0] spr8;
  wire [5:0] spr9;
  wire [5:0] spriteIndexArray_10;
  wire [5:0] spriteIndexArray_11;
  wire [5:0] spriteIndexArray_12;
  wire [5:0] spriteIndexArray_13;
  wire [5:0] spriteIndexArray_14;
  wire [5:0] spriteIndexArray_15;
  wire [5:0] spriteIndexArray_16;
  wire [5:0] spriteIndexArray_17;
  wire [5:0] spriteIndexArray_18;
  wire [5:0] spriteIndexArray_19;
  wire [5:0] spriteIndexArray_20;
  wire [5:0] spriteIndexArray_21;
  wire [5:0] spriteIndexArray_22;
  wire [5:0] spriteIndexArray_23;
  wire [5:0] spriteIndexArray_24;
  wire [5:0] spriteIndexArray_25;
  wire [5:0] spriteIndexArray_26;
  wire [5:0] spriteIndexArray_27;
  wire [5:0] spriteIndexArray_28;
  wire [5:0] spriteIndexArray_29;
  wire [5:0] spriteIndexArray_30;
  wire [5:0] spriteIndexArray_31;
  wire [5:0] spriteIndexArray_32;
  wire [5:0] spriteIndexArray_33;
  wire [5:0] spriteIndexArray_34;
  wire [5:0] spriteIndexArray_35;
  wire [5:0] spriteIndexArray_36;
  wire [5:0] spriteIndexArray_37;
  wire [5:0] spriteIndexArray_38;
  wire [5:0] spriteIndexArray_39;
  wire [7:0] spriteOamDo_0;
  wire [7:0] spriteOamDo_1;
  wire [7:0] spriteOamDo_2;
  wire [7:0] spriteOamDo_3;
  wire [7:0] spriteOamDo_4;
  wire [7:0] spriteOamDo_5;
  wire [7:0] spriteOamDo_6;
  wire [7:0] spriteOamDo_7;
  wire [7:0] spriteOamDo_8;
  wire [7:0] spriteOamDo_9;
  wire [7:0] spriteOamDo_10;
  wire [7:0] spriteOamDo_11;
  wire [7:0] spriteOamDo_12;
  wire [7:0] spriteOamDo_13;
  wire [7:0] spriteOamDo_14;
  wire [7:0] spriteOamDo_15;
  wire [7:0] spriteOamDo_16;
  wire [7:0] spriteOamDo_17;
  wire [7:0] spriteOamDo_18;
  wire [7:0] spriteOamDo_19;
  wire [7:0] spriteOamDo_20;
  wire [7:0] spriteOamDo_21;
  wire [7:0] spriteOamDo_22;
  wire [7:0] spriteOamDo_23;
  wire [7:0] spriteOamDo_24;
  wire [7:0] spriteOamDo_25;
  wire [7:0] spriteOamDo_26;
  wire [7:0] spriteOamDo_27;
  wire [7:0] spriteOamDo_28;
  wire [7:0] spriteOamDo_29;
  wire [7:0] spriteOamDo_30;
  wire [7:0] spriteOamDo_31;
  wire [7:0] spriteOamDo_32;
  wire [7:0] spriteOamDo_33;
  wire [7:0] spriteOamDo_34;
  wire [7:0] spriteOamDo_35;
  wire [7:0] spriteOamDo_36;
  wire [7:0] spriteOamDo_37;
  wire [7:0] spriteOamDo_38;
  wire [7:0] spriteOamDo_39;
  wire [5:0] prioIndex;
  assign _zz_335 = {2'd0, io_index};
  assign _zz_336 = io_oamAddr[7 : 2];
  Sprite sprites_0 ( 
    .io_index(_zz_2),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_135),
    .io_pixelData(_zz_136),
    .io_addr(_zz_137),
    .io_oamWr(_zz_3),
    .io_oamAddr(_zz_4),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_138),
    .io_diag(_zz_139),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_1 ( 
    .io_index(_zz_5),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_140),
    .io_pixelData(_zz_141),
    .io_addr(_zz_142),
    .io_oamWr(_zz_6),
    .io_oamAddr(_zz_7),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_143),
    .io_diag(_zz_144),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_2 ( 
    .io_index(_zz_8),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_145),
    .io_pixelData(_zz_146),
    .io_addr(_zz_147),
    .io_oamWr(_zz_9),
    .io_oamAddr(_zz_10),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_148),
    .io_diag(_zz_149),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_3 ( 
    .io_index(_zz_11),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_150),
    .io_pixelData(_zz_151),
    .io_addr(_zz_152),
    .io_oamWr(_zz_12),
    .io_oamAddr(_zz_13),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_153),
    .io_diag(_zz_154),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_4 ( 
    .io_index(_zz_14),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_155),
    .io_pixelData(_zz_156),
    .io_addr(_zz_157),
    .io_oamWr(_zz_15),
    .io_oamAddr(_zz_16),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_158),
    .io_diag(_zz_159),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_5 ( 
    .io_index(_zz_17),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_160),
    .io_pixelData(_zz_161),
    .io_addr(_zz_162),
    .io_oamWr(_zz_18),
    .io_oamAddr(_zz_19),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_163),
    .io_diag(_zz_164),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_6 ( 
    .io_index(_zz_20),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_165),
    .io_pixelData(_zz_166),
    .io_addr(_zz_167),
    .io_oamWr(_zz_21),
    .io_oamAddr(_zz_22),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_168),
    .io_diag(_zz_169),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_7 ( 
    .io_index(_zz_23),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_170),
    .io_pixelData(_zz_171),
    .io_addr(_zz_172),
    .io_oamWr(_zz_24),
    .io_oamAddr(_zz_25),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_173),
    .io_diag(_zz_174),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_8 ( 
    .io_index(_zz_26),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_175),
    .io_pixelData(_zz_176),
    .io_addr(_zz_177),
    .io_oamWr(_zz_27),
    .io_oamAddr(_zz_28),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_178),
    .io_diag(_zz_179),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_9 ( 
    .io_index(_zz_29),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_180),
    .io_pixelData(_zz_181),
    .io_addr(_zz_182),
    .io_oamWr(_zz_30),
    .io_oamAddr(_zz_31),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_183),
    .io_diag(_zz_184),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_10 ( 
    .io_index(_zz_32),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_185),
    .io_pixelData(_zz_186),
    .io_addr(_zz_187),
    .io_oamWr(_zz_33),
    .io_oamAddr(_zz_34),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_188),
    .io_diag(_zz_189),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_11 ( 
    .io_index(_zz_35),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_190),
    .io_pixelData(_zz_191),
    .io_addr(_zz_192),
    .io_oamWr(_zz_36),
    .io_oamAddr(_zz_37),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_193),
    .io_diag(_zz_194),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_12 ( 
    .io_index(_zz_38),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_195),
    .io_pixelData(_zz_196),
    .io_addr(_zz_197),
    .io_oamWr(_zz_39),
    .io_oamAddr(_zz_40),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_198),
    .io_diag(_zz_199),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_13 ( 
    .io_index(_zz_41),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_200),
    .io_pixelData(_zz_201),
    .io_addr(_zz_202),
    .io_oamWr(_zz_42),
    .io_oamAddr(_zz_43),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_203),
    .io_diag(_zz_204),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_14 ( 
    .io_index(_zz_44),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_205),
    .io_pixelData(_zz_206),
    .io_addr(_zz_207),
    .io_oamWr(_zz_45),
    .io_oamAddr(_zz_46),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_208),
    .io_diag(_zz_209),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_15 ( 
    .io_index(_zz_47),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_210),
    .io_pixelData(_zz_211),
    .io_addr(_zz_212),
    .io_oamWr(_zz_48),
    .io_oamAddr(_zz_49),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_213),
    .io_diag(_zz_214),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_16 ( 
    .io_index(_zz_50),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_215),
    .io_pixelData(_zz_216),
    .io_addr(_zz_217),
    .io_oamWr(_zz_51),
    .io_oamAddr(_zz_52),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_218),
    .io_diag(_zz_219),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_17 ( 
    .io_index(_zz_53),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_220),
    .io_pixelData(_zz_221),
    .io_addr(_zz_222),
    .io_oamWr(_zz_54),
    .io_oamAddr(_zz_55),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_223),
    .io_diag(_zz_224),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_18 ( 
    .io_index(_zz_56),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_225),
    .io_pixelData(_zz_226),
    .io_addr(_zz_227),
    .io_oamWr(_zz_57),
    .io_oamAddr(_zz_58),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_228),
    .io_diag(_zz_229),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_19 ( 
    .io_index(_zz_59),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_230),
    .io_pixelData(_zz_231),
    .io_addr(_zz_232),
    .io_oamWr(_zz_60),
    .io_oamAddr(_zz_61),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_233),
    .io_diag(_zz_234),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_20 ( 
    .io_index(_zz_62),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_235),
    .io_pixelData(_zz_236),
    .io_addr(_zz_237),
    .io_oamWr(_zz_63),
    .io_oamAddr(_zz_64),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_238),
    .io_diag(_zz_239),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_21 ( 
    .io_index(_zz_65),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_240),
    .io_pixelData(_zz_241),
    .io_addr(_zz_242),
    .io_oamWr(_zz_66),
    .io_oamAddr(_zz_67),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_243),
    .io_diag(_zz_244),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_22 ( 
    .io_index(_zz_68),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_245),
    .io_pixelData(_zz_246),
    .io_addr(_zz_247),
    .io_oamWr(_zz_69),
    .io_oamAddr(_zz_70),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_248),
    .io_diag(_zz_249),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_23 ( 
    .io_index(_zz_71),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_250),
    .io_pixelData(_zz_251),
    .io_addr(_zz_252),
    .io_oamWr(_zz_72),
    .io_oamAddr(_zz_73),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_253),
    .io_diag(_zz_254),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_24 ( 
    .io_index(_zz_74),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_255),
    .io_pixelData(_zz_256),
    .io_addr(_zz_257),
    .io_oamWr(_zz_75),
    .io_oamAddr(_zz_76),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_258),
    .io_diag(_zz_259),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_25 ( 
    .io_index(_zz_77),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_260),
    .io_pixelData(_zz_261),
    .io_addr(_zz_262),
    .io_oamWr(_zz_78),
    .io_oamAddr(_zz_79),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_263),
    .io_diag(_zz_264),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_26 ( 
    .io_index(_zz_80),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_265),
    .io_pixelData(_zz_266),
    .io_addr(_zz_267),
    .io_oamWr(_zz_81),
    .io_oamAddr(_zz_82),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_268),
    .io_diag(_zz_269),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_27 ( 
    .io_index(_zz_83),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_270),
    .io_pixelData(_zz_271),
    .io_addr(_zz_272),
    .io_oamWr(_zz_84),
    .io_oamAddr(_zz_85),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_273),
    .io_diag(_zz_274),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_28 ( 
    .io_index(_zz_86),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_275),
    .io_pixelData(_zz_276),
    .io_addr(_zz_277),
    .io_oamWr(_zz_87),
    .io_oamAddr(_zz_88),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_278),
    .io_diag(_zz_279),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_29 ( 
    .io_index(_zz_89),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_280),
    .io_pixelData(_zz_281),
    .io_addr(_zz_282),
    .io_oamWr(_zz_90),
    .io_oamAddr(_zz_91),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_283),
    .io_diag(_zz_284),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_30 ( 
    .io_index(_zz_92),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_285),
    .io_pixelData(_zz_286),
    .io_addr(_zz_287),
    .io_oamWr(_zz_93),
    .io_oamAddr(_zz_94),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_288),
    .io_diag(_zz_289),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_31 ( 
    .io_index(_zz_95),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_290),
    .io_pixelData(_zz_291),
    .io_addr(_zz_292),
    .io_oamWr(_zz_96),
    .io_oamAddr(_zz_97),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_293),
    .io_diag(_zz_294),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_32 ( 
    .io_index(_zz_98),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_295),
    .io_pixelData(_zz_296),
    .io_addr(_zz_297),
    .io_oamWr(_zz_99),
    .io_oamAddr(_zz_100),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_298),
    .io_diag(_zz_299),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_33 ( 
    .io_index(_zz_101),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_300),
    .io_pixelData(_zz_301),
    .io_addr(_zz_302),
    .io_oamWr(_zz_102),
    .io_oamAddr(_zz_103),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_303),
    .io_diag(_zz_304),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_34 ( 
    .io_index(_zz_104),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_305),
    .io_pixelData(_zz_306),
    .io_addr(_zz_307),
    .io_oamWr(_zz_105),
    .io_oamAddr(_zz_106),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_308),
    .io_diag(_zz_309),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_35 ( 
    .io_index(_zz_107),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_310),
    .io_pixelData(_zz_311),
    .io_addr(_zz_312),
    .io_oamWr(_zz_108),
    .io_oamAddr(_zz_109),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_313),
    .io_diag(_zz_314),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_36 ( 
    .io_index(_zz_110),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_315),
    .io_pixelData(_zz_316),
    .io_addr(_zz_317),
    .io_oamWr(_zz_111),
    .io_oamAddr(_zz_112),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_318),
    .io_diag(_zz_319),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_37 ( 
    .io_index(_zz_113),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_320),
    .io_pixelData(_zz_321),
    .io_addr(_zz_322),
    .io_oamWr(_zz_114),
    .io_oamAddr(_zz_115),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_323),
    .io_diag(_zz_324),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_38 ( 
    .io_index(_zz_116),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_325),
    .io_pixelData(_zz_326),
    .io_addr(_zz_327),
    .io_oamWr(_zz_117),
    .io_oamAddr(_zz_118),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_328),
    .io_diag(_zz_329),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  Sprite sprites_39 ( 
    .io_index(_zz_119),
    .io_x(io_x),
    .io_y(io_y),
    .io_size16(io_size16),
    .io_ds(io_dValid),
    .io_data(io_data),
    .io_pixelActive(_zz_330),
    .io_pixelData(_zz_331),
    .io_addr(_zz_332),
    .io_oamWr(_zz_120),
    .io_oamAddr(_zz_121),
    .io_oamDi(io_oamDi),
    .io_oamDo(_zz_333),
    .io_diag(_zz_334),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  always @(*) begin
    case(_zz_335)
      6'b000000 : begin
        _zz_122 = spr0;
      end
      6'b000001 : begin
        _zz_122 = spr1;
      end
      6'b000010 : begin
        _zz_122 = spr2;
      end
      6'b000011 : begin
        _zz_122 = spr3;
      end
      6'b000100 : begin
        _zz_122 = spr4;
      end
      6'b000101 : begin
        _zz_122 = spr5;
      end
      6'b000110 : begin
        _zz_122 = spr6;
      end
      6'b000111 : begin
        _zz_122 = spr7;
      end
      6'b001000 : begin
        _zz_122 = spr8;
      end
      6'b001001 : begin
        _zz_122 = spr9;
      end
      6'b001010 : begin
        _zz_122 = spriteIndexArray_10;
      end
      6'b001011 : begin
        _zz_122 = spriteIndexArray_11;
      end
      6'b001100 : begin
        _zz_122 = spriteIndexArray_12;
      end
      6'b001101 : begin
        _zz_122 = spriteIndexArray_13;
      end
      6'b001110 : begin
        _zz_122 = spriteIndexArray_14;
      end
      6'b001111 : begin
        _zz_122 = spriteIndexArray_15;
      end
      6'b010000 : begin
        _zz_122 = spriteIndexArray_16;
      end
      6'b010001 : begin
        _zz_122 = spriteIndexArray_17;
      end
      6'b010010 : begin
        _zz_122 = spriteIndexArray_18;
      end
      6'b010011 : begin
        _zz_122 = spriteIndexArray_19;
      end
      6'b010100 : begin
        _zz_122 = spriteIndexArray_20;
      end
      6'b010101 : begin
        _zz_122 = spriteIndexArray_21;
      end
      6'b010110 : begin
        _zz_122 = spriteIndexArray_22;
      end
      6'b010111 : begin
        _zz_122 = spriteIndexArray_23;
      end
      6'b011000 : begin
        _zz_122 = spriteIndexArray_24;
      end
      6'b011001 : begin
        _zz_122 = spriteIndexArray_25;
      end
      6'b011010 : begin
        _zz_122 = spriteIndexArray_26;
      end
      6'b011011 : begin
        _zz_122 = spriteIndexArray_27;
      end
      6'b011100 : begin
        _zz_122 = spriteIndexArray_28;
      end
      6'b011101 : begin
        _zz_122 = spriteIndexArray_29;
      end
      6'b011110 : begin
        _zz_122 = spriteIndexArray_30;
      end
      6'b011111 : begin
        _zz_122 = spriteIndexArray_31;
      end
      6'b100000 : begin
        _zz_122 = spriteIndexArray_32;
      end
      6'b100001 : begin
        _zz_122 = spriteIndexArray_33;
      end
      6'b100010 : begin
        _zz_122 = spriteIndexArray_34;
      end
      6'b100011 : begin
        _zz_122 = spriteIndexArray_35;
      end
      6'b100100 : begin
        _zz_122 = spriteIndexArray_36;
      end
      6'b100101 : begin
        _zz_122 = spriteIndexArray_37;
      end
      6'b100110 : begin
        _zz_122 = spriteIndexArray_38;
      end
      default : begin
        _zz_122 = spriteIndexArray_39;
      end
    endcase
  end

  always @(*) begin
    case(prioIndex)
      6'b000000 : begin
        _zz_123 = spriteAddr_0;
      end
      6'b000001 : begin
        _zz_123 = spriteAddr_1;
      end
      6'b000010 : begin
        _zz_123 = spriteAddr_2;
      end
      6'b000011 : begin
        _zz_123 = spriteAddr_3;
      end
      6'b000100 : begin
        _zz_123 = spriteAddr_4;
      end
      6'b000101 : begin
        _zz_123 = spriteAddr_5;
      end
      6'b000110 : begin
        _zz_123 = spriteAddr_6;
      end
      6'b000111 : begin
        _zz_123 = spriteAddr_7;
      end
      6'b001000 : begin
        _zz_123 = spriteAddr_8;
      end
      6'b001001 : begin
        _zz_123 = spriteAddr_9;
      end
      6'b001010 : begin
        _zz_123 = spriteAddr_10;
      end
      6'b001011 : begin
        _zz_123 = spriteAddr_11;
      end
      6'b001100 : begin
        _zz_123 = spriteAddr_12;
      end
      6'b001101 : begin
        _zz_123 = spriteAddr_13;
      end
      6'b001110 : begin
        _zz_123 = spriteAddr_14;
      end
      6'b001111 : begin
        _zz_123 = spriteAddr_15;
      end
      6'b010000 : begin
        _zz_123 = spriteAddr_16;
      end
      6'b010001 : begin
        _zz_123 = spriteAddr_17;
      end
      6'b010010 : begin
        _zz_123 = spriteAddr_18;
      end
      6'b010011 : begin
        _zz_123 = spriteAddr_19;
      end
      6'b010100 : begin
        _zz_123 = spriteAddr_20;
      end
      6'b010101 : begin
        _zz_123 = spriteAddr_21;
      end
      6'b010110 : begin
        _zz_123 = spriteAddr_22;
      end
      6'b010111 : begin
        _zz_123 = spriteAddr_23;
      end
      6'b011000 : begin
        _zz_123 = spriteAddr_24;
      end
      6'b011001 : begin
        _zz_123 = spriteAddr_25;
      end
      6'b011010 : begin
        _zz_123 = spriteAddr_26;
      end
      6'b011011 : begin
        _zz_123 = spriteAddr_27;
      end
      6'b011100 : begin
        _zz_123 = spriteAddr_28;
      end
      6'b011101 : begin
        _zz_123 = spriteAddr_29;
      end
      6'b011110 : begin
        _zz_123 = spriteAddr_30;
      end
      6'b011111 : begin
        _zz_123 = spriteAddr_31;
      end
      6'b100000 : begin
        _zz_123 = spriteAddr_32;
      end
      6'b100001 : begin
        _zz_123 = spriteAddr_33;
      end
      6'b100010 : begin
        _zz_123 = spriteAddr_34;
      end
      6'b100011 : begin
        _zz_123 = spriteAddr_35;
      end
      6'b100100 : begin
        _zz_123 = spriteAddr_36;
      end
      6'b100101 : begin
        _zz_123 = spriteAddr_37;
      end
      6'b100110 : begin
        _zz_123 = spriteAddr_38;
      end
      default : begin
        _zz_123 = spriteAddr_39;
      end
    endcase
  end

  always @(*) begin
    case(_zz_336)
      6'b000000 : begin
        _zz_124 = spriteOamDo_0;
      end
      6'b000001 : begin
        _zz_124 = spriteOamDo_1;
      end
      6'b000010 : begin
        _zz_124 = spriteOamDo_2;
      end
      6'b000011 : begin
        _zz_124 = spriteOamDo_3;
      end
      6'b000100 : begin
        _zz_124 = spriteOamDo_4;
      end
      6'b000101 : begin
        _zz_124 = spriteOamDo_5;
      end
      6'b000110 : begin
        _zz_124 = spriteOamDo_6;
      end
      6'b000111 : begin
        _zz_124 = spriteOamDo_7;
      end
      6'b001000 : begin
        _zz_124 = spriteOamDo_8;
      end
      6'b001001 : begin
        _zz_124 = spriteOamDo_9;
      end
      6'b001010 : begin
        _zz_124 = spriteOamDo_10;
      end
      6'b001011 : begin
        _zz_124 = spriteOamDo_11;
      end
      6'b001100 : begin
        _zz_124 = spriteOamDo_12;
      end
      6'b001101 : begin
        _zz_124 = spriteOamDo_13;
      end
      6'b001110 : begin
        _zz_124 = spriteOamDo_14;
      end
      6'b001111 : begin
        _zz_124 = spriteOamDo_15;
      end
      6'b010000 : begin
        _zz_124 = spriteOamDo_16;
      end
      6'b010001 : begin
        _zz_124 = spriteOamDo_17;
      end
      6'b010010 : begin
        _zz_124 = spriteOamDo_18;
      end
      6'b010011 : begin
        _zz_124 = spriteOamDo_19;
      end
      6'b010100 : begin
        _zz_124 = spriteOamDo_20;
      end
      6'b010101 : begin
        _zz_124 = spriteOamDo_21;
      end
      6'b010110 : begin
        _zz_124 = spriteOamDo_22;
      end
      6'b010111 : begin
        _zz_124 = spriteOamDo_23;
      end
      6'b011000 : begin
        _zz_124 = spriteOamDo_24;
      end
      6'b011001 : begin
        _zz_124 = spriteOamDo_25;
      end
      6'b011010 : begin
        _zz_124 = spriteOamDo_26;
      end
      6'b011011 : begin
        _zz_124 = spriteOamDo_27;
      end
      6'b011100 : begin
        _zz_124 = spriteOamDo_28;
      end
      6'b011101 : begin
        _zz_124 = spriteOamDo_29;
      end
      6'b011110 : begin
        _zz_124 = spriteOamDo_30;
      end
      6'b011111 : begin
        _zz_124 = spriteOamDo_31;
      end
      6'b100000 : begin
        _zz_124 = spriteOamDo_32;
      end
      6'b100001 : begin
        _zz_124 = spriteOamDo_33;
      end
      6'b100010 : begin
        _zz_124 = spriteOamDo_34;
      end
      6'b100011 : begin
        _zz_124 = spriteOamDo_35;
      end
      6'b100100 : begin
        _zz_124 = spriteOamDo_36;
      end
      6'b100101 : begin
        _zz_124 = spriteOamDo_37;
      end
      6'b100110 : begin
        _zz_124 = spriteOamDo_38;
      end
      default : begin
        _zz_124 = spriteOamDo_39;
      end
    endcase
  end

  always @(*) begin
    case(spr0)
      6'b000000 : begin
        _zz_125 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_125 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_125 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_125 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_125 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_125 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_125 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_125 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_125 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_125 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_125 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_125 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_125 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_125 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_125 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_125 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_125 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_125 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_125 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_125 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_125 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_125 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_125 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_125 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_125 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_125 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_125 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_125 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_125 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_125 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_125 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_125 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_125 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_125 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_125 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_125 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_125 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_125 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_125 = spritePixelData_38;
      end
      default : begin
        _zz_125 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr1)
      6'b000000 : begin
        _zz_126 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_126 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_126 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_126 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_126 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_126 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_126 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_126 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_126 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_126 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_126 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_126 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_126 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_126 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_126 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_126 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_126 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_126 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_126 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_126 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_126 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_126 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_126 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_126 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_126 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_126 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_126 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_126 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_126 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_126 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_126 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_126 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_126 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_126 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_126 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_126 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_126 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_126 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_126 = spritePixelData_38;
      end
      default : begin
        _zz_126 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr2)
      6'b000000 : begin
        _zz_127 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_127 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_127 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_127 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_127 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_127 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_127 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_127 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_127 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_127 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_127 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_127 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_127 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_127 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_127 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_127 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_127 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_127 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_127 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_127 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_127 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_127 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_127 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_127 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_127 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_127 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_127 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_127 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_127 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_127 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_127 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_127 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_127 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_127 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_127 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_127 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_127 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_127 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_127 = spritePixelData_38;
      end
      default : begin
        _zz_127 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr3)
      6'b000000 : begin
        _zz_128 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_128 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_128 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_128 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_128 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_128 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_128 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_128 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_128 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_128 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_128 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_128 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_128 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_128 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_128 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_128 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_128 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_128 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_128 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_128 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_128 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_128 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_128 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_128 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_128 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_128 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_128 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_128 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_128 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_128 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_128 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_128 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_128 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_128 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_128 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_128 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_128 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_128 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_128 = spritePixelData_38;
      end
      default : begin
        _zz_128 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr4)
      6'b000000 : begin
        _zz_129 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_129 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_129 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_129 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_129 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_129 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_129 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_129 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_129 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_129 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_129 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_129 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_129 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_129 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_129 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_129 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_129 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_129 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_129 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_129 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_129 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_129 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_129 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_129 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_129 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_129 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_129 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_129 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_129 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_129 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_129 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_129 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_129 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_129 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_129 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_129 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_129 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_129 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_129 = spritePixelData_38;
      end
      default : begin
        _zz_129 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr5)
      6'b000000 : begin
        _zz_130 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_130 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_130 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_130 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_130 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_130 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_130 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_130 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_130 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_130 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_130 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_130 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_130 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_130 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_130 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_130 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_130 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_130 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_130 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_130 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_130 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_130 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_130 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_130 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_130 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_130 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_130 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_130 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_130 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_130 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_130 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_130 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_130 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_130 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_130 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_130 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_130 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_130 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_130 = spritePixelData_38;
      end
      default : begin
        _zz_130 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr6)
      6'b000000 : begin
        _zz_131 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_131 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_131 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_131 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_131 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_131 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_131 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_131 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_131 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_131 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_131 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_131 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_131 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_131 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_131 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_131 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_131 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_131 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_131 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_131 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_131 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_131 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_131 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_131 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_131 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_131 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_131 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_131 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_131 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_131 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_131 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_131 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_131 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_131 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_131 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_131 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_131 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_131 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_131 = spritePixelData_38;
      end
      default : begin
        _zz_131 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr7)
      6'b000000 : begin
        _zz_132 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_132 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_132 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_132 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_132 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_132 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_132 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_132 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_132 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_132 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_132 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_132 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_132 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_132 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_132 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_132 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_132 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_132 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_132 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_132 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_132 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_132 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_132 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_132 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_132 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_132 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_132 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_132 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_132 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_132 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_132 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_132 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_132 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_132 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_132 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_132 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_132 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_132 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_132 = spritePixelData_38;
      end
      default : begin
        _zz_132 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr8)
      6'b000000 : begin
        _zz_133 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_133 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_133 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_133 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_133 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_133 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_133 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_133 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_133 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_133 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_133 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_133 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_133 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_133 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_133 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_133 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_133 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_133 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_133 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_133 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_133 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_133 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_133 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_133 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_133 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_133 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_133 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_133 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_133 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_133 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_133 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_133 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_133 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_133 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_133 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_133 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_133 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_133 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_133 = spritePixelData_38;
      end
      default : begin
        _zz_133 = spritePixelData_39;
      end
    endcase
  end

  always @(*) begin
    case(spr9)
      6'b000000 : begin
        _zz_134 = spritePixelData_0;
      end
      6'b000001 : begin
        _zz_134 = spritePixelData_1;
      end
      6'b000010 : begin
        _zz_134 = spritePixelData_2;
      end
      6'b000011 : begin
        _zz_134 = spritePixelData_3;
      end
      6'b000100 : begin
        _zz_134 = spritePixelData_4;
      end
      6'b000101 : begin
        _zz_134 = spritePixelData_5;
      end
      6'b000110 : begin
        _zz_134 = spritePixelData_6;
      end
      6'b000111 : begin
        _zz_134 = spritePixelData_7;
      end
      6'b001000 : begin
        _zz_134 = spritePixelData_8;
      end
      6'b001001 : begin
        _zz_134 = spritePixelData_9;
      end
      6'b001010 : begin
        _zz_134 = spritePixelData_10;
      end
      6'b001011 : begin
        _zz_134 = spritePixelData_11;
      end
      6'b001100 : begin
        _zz_134 = spritePixelData_12;
      end
      6'b001101 : begin
        _zz_134 = spritePixelData_13;
      end
      6'b001110 : begin
        _zz_134 = spritePixelData_14;
      end
      6'b001111 : begin
        _zz_134 = spritePixelData_15;
      end
      6'b010000 : begin
        _zz_134 = spritePixelData_16;
      end
      6'b010001 : begin
        _zz_134 = spritePixelData_17;
      end
      6'b010010 : begin
        _zz_134 = spritePixelData_18;
      end
      6'b010011 : begin
        _zz_134 = spritePixelData_19;
      end
      6'b010100 : begin
        _zz_134 = spritePixelData_20;
      end
      6'b010101 : begin
        _zz_134 = spritePixelData_21;
      end
      6'b010110 : begin
        _zz_134 = spritePixelData_22;
      end
      6'b010111 : begin
        _zz_134 = spritePixelData_23;
      end
      6'b011000 : begin
        _zz_134 = spritePixelData_24;
      end
      6'b011001 : begin
        _zz_134 = spritePixelData_25;
      end
      6'b011010 : begin
        _zz_134 = spritePixelData_26;
      end
      6'b011011 : begin
        _zz_134 = spritePixelData_27;
      end
      6'b011100 : begin
        _zz_134 = spritePixelData_28;
      end
      6'b011101 : begin
        _zz_134 = spritePixelData_29;
      end
      6'b011110 : begin
        _zz_134 = spritePixelData_30;
      end
      6'b011111 : begin
        _zz_134 = spritePixelData_31;
      end
      6'b100000 : begin
        _zz_134 = spritePixelData_32;
      end
      6'b100001 : begin
        _zz_134 = spritePixelData_33;
      end
      6'b100010 : begin
        _zz_134 = spritePixelData_34;
      end
      6'b100011 : begin
        _zz_134 = spritePixelData_35;
      end
      6'b100100 : begin
        _zz_134 = spritePixelData_36;
      end
      6'b100101 : begin
        _zz_134 = spritePixelData_37;
      end
      6'b100110 : begin
        _zz_134 = spritePixelData_38;
      end
      default : begin
        _zz_134 = spritePixelData_39;
      end
    endcase
  end

  assign prioIndex = _zz_122;
  assign io_addr = _zz_123;
  assign spr0 = (6'b000000);
  assign spr1 = (6'b000001);
  assign spr2 = (6'b000010);
  assign spr3 = (6'b000011);
  assign spr4 = (6'b000100);
  assign spr5 = (6'b000101);
  assign spr6 = (6'b000110);
  assign spr7 = (6'b000111);
  assign spr8 = (6'b001000);
  assign spr9 = (6'b001001);
  assign spriteIndexArray_10 = (6'b001010);
  assign spriteIndexArray_11 = (6'b001011);
  assign spriteIndexArray_12 = (6'b001100);
  assign spriteIndexArray_13 = (6'b001101);
  assign spriteIndexArray_14 = (6'b001110);
  assign spriteIndexArray_15 = (6'b001111);
  assign spriteIndexArray_16 = (6'b010000);
  assign spriteIndexArray_17 = (6'b010001);
  assign spriteIndexArray_18 = (6'b010010);
  assign spriteIndexArray_19 = (6'b010011);
  assign spriteIndexArray_20 = (6'b010100);
  assign spriteIndexArray_21 = (6'b010101);
  assign spriteIndexArray_22 = (6'b010110);
  assign spriteIndexArray_23 = (6'b010111);
  assign spriteIndexArray_24 = (6'b011000);
  assign spriteIndexArray_25 = (6'b011001);
  assign spriteIndexArray_26 = (6'b011010);
  assign spriteIndexArray_27 = (6'b011011);
  assign spriteIndexArray_28 = (6'b011100);
  assign spriteIndexArray_29 = (6'b011101);
  assign spriteIndexArray_30 = (6'b011110);
  assign spriteIndexArray_31 = (6'b011111);
  assign spriteIndexArray_32 = (6'b100000);
  assign spriteIndexArray_33 = (6'b100001);
  assign spriteIndexArray_34 = (6'b100010);
  assign spriteIndexArray_35 = (6'b100011);
  assign spriteIndexArray_36 = (6'b100100);
  assign spriteIndexArray_37 = (6'b100101);
  assign spriteIndexArray_38 = (6'b100110);
  assign spriteIndexArray_39 = (6'b100111);
  assign _zz_2 = (6'b000000);
  assign spriteAddr_0 = _zz_137;
  always @ (*) begin
    spritePixelActive[0] = _zz_135;
    spritePixelActive[1] = _zz_140;
    spritePixelActive[2] = _zz_145;
    spritePixelActive[3] = _zz_150;
    spritePixelActive[4] = _zz_155;
    spritePixelActive[5] = _zz_160;
    spritePixelActive[6] = _zz_165;
    spritePixelActive[7] = _zz_170;
    spritePixelActive[8] = _zz_175;
    spritePixelActive[9] = _zz_180;
    spritePixelActive[10] = _zz_185;
    spritePixelActive[11] = _zz_190;
    spritePixelActive[12] = _zz_195;
    spritePixelActive[13] = _zz_200;
    spritePixelActive[14] = _zz_205;
    spritePixelActive[15] = _zz_210;
    spritePixelActive[16] = _zz_215;
    spritePixelActive[17] = _zz_220;
    spritePixelActive[18] = _zz_225;
    spritePixelActive[19] = _zz_230;
    spritePixelActive[20] = _zz_235;
    spritePixelActive[21] = _zz_240;
    spritePixelActive[22] = _zz_245;
    spritePixelActive[23] = _zz_250;
    spritePixelActive[24] = _zz_255;
    spritePixelActive[25] = _zz_260;
    spritePixelActive[26] = _zz_265;
    spritePixelActive[27] = _zz_270;
    spritePixelActive[28] = _zz_275;
    spritePixelActive[29] = _zz_280;
    spritePixelActive[30] = _zz_285;
    spritePixelActive[31] = _zz_290;
    spritePixelActive[32] = _zz_295;
    spritePixelActive[33] = _zz_300;
    spritePixelActive[34] = _zz_305;
    spritePixelActive[35] = _zz_310;
    spritePixelActive[36] = _zz_315;
    spritePixelActive[37] = _zz_320;
    spritePixelActive[38] = _zz_325;
    spritePixelActive[39] = _zz_330;
  end

  assign spritePixelData_0 = _zz_136;
  assign _zz_3 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000000)));
  assign _zz_4 = io_oamAddr[1 : 0];
  assign spriteOamDo_0 = _zz_138;
  assign _zz_5 = (6'b000001);
  assign spriteAddr_1 = _zz_142;
  assign spritePixelData_1 = _zz_141;
  assign _zz_6 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000001)));
  assign _zz_7 = io_oamAddr[1 : 0];
  assign spriteOamDo_1 = _zz_143;
  assign _zz_8 = (6'b000010);
  assign spriteAddr_2 = _zz_147;
  assign spritePixelData_2 = _zz_146;
  assign _zz_9 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000010)));
  assign _zz_10 = io_oamAddr[1 : 0];
  assign spriteOamDo_2 = _zz_148;
  assign _zz_11 = (6'b000011);
  assign spriteAddr_3 = _zz_152;
  assign spritePixelData_3 = _zz_151;
  assign _zz_12 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000011)));
  assign _zz_13 = io_oamAddr[1 : 0];
  assign spriteOamDo_3 = _zz_153;
  assign _zz_14 = (6'b000100);
  assign spriteAddr_4 = _zz_157;
  assign spritePixelData_4 = _zz_156;
  assign _zz_15 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000100)));
  assign _zz_16 = io_oamAddr[1 : 0];
  assign spriteOamDo_4 = _zz_158;
  assign _zz_17 = (6'b000101);
  assign spriteAddr_5 = _zz_162;
  assign spritePixelData_5 = _zz_161;
  assign _zz_18 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000101)));
  assign _zz_19 = io_oamAddr[1 : 0];
  assign spriteOamDo_5 = _zz_163;
  assign _zz_20 = (6'b000110);
  assign spriteAddr_6 = _zz_167;
  assign spritePixelData_6 = _zz_166;
  assign _zz_21 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000110)));
  assign _zz_22 = io_oamAddr[1 : 0];
  assign spriteOamDo_6 = _zz_168;
  assign _zz_23 = (6'b000111);
  assign spriteAddr_7 = _zz_172;
  assign spritePixelData_7 = _zz_171;
  assign _zz_24 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b000111)));
  assign _zz_25 = io_oamAddr[1 : 0];
  assign spriteOamDo_7 = _zz_173;
  assign _zz_26 = (6'b001000);
  assign spriteAddr_8 = _zz_177;
  assign spritePixelData_8 = _zz_176;
  assign _zz_27 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001000)));
  assign _zz_28 = io_oamAddr[1 : 0];
  assign spriteOamDo_8 = _zz_178;
  assign _zz_29 = (6'b001001);
  assign spriteAddr_9 = _zz_182;
  assign spritePixelData_9 = _zz_181;
  assign _zz_30 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001001)));
  assign _zz_31 = io_oamAddr[1 : 0];
  assign spriteOamDo_9 = _zz_183;
  assign _zz_32 = (6'b001010);
  assign spriteAddr_10 = _zz_187;
  assign spritePixelData_10 = _zz_186;
  assign _zz_33 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001010)));
  assign _zz_34 = io_oamAddr[1 : 0];
  assign spriteOamDo_10 = _zz_188;
  assign _zz_35 = (6'b001011);
  assign spriteAddr_11 = _zz_192;
  assign spritePixelData_11 = _zz_191;
  assign _zz_36 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001011)));
  assign _zz_37 = io_oamAddr[1 : 0];
  assign spriteOamDo_11 = _zz_193;
  assign _zz_38 = (6'b001100);
  assign spriteAddr_12 = _zz_197;
  assign spritePixelData_12 = _zz_196;
  assign _zz_39 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001100)));
  assign _zz_40 = io_oamAddr[1 : 0];
  assign spriteOamDo_12 = _zz_198;
  assign _zz_41 = (6'b001101);
  assign spriteAddr_13 = _zz_202;
  assign spritePixelData_13 = _zz_201;
  assign _zz_42 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001101)));
  assign _zz_43 = io_oamAddr[1 : 0];
  assign spriteOamDo_13 = _zz_203;
  assign _zz_44 = (6'b001110);
  assign spriteAddr_14 = _zz_207;
  assign spritePixelData_14 = _zz_206;
  assign _zz_45 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001110)));
  assign _zz_46 = io_oamAddr[1 : 0];
  assign spriteOamDo_14 = _zz_208;
  assign _zz_47 = (6'b001111);
  assign spriteAddr_15 = _zz_212;
  assign spritePixelData_15 = _zz_211;
  assign _zz_48 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b001111)));
  assign _zz_49 = io_oamAddr[1 : 0];
  assign spriteOamDo_15 = _zz_213;
  assign _zz_50 = (6'b010000);
  assign spriteAddr_16 = _zz_217;
  assign spritePixelData_16 = _zz_216;
  assign _zz_51 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010000)));
  assign _zz_52 = io_oamAddr[1 : 0];
  assign spriteOamDo_16 = _zz_218;
  assign _zz_53 = (6'b010001);
  assign spriteAddr_17 = _zz_222;
  assign spritePixelData_17 = _zz_221;
  assign _zz_54 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010001)));
  assign _zz_55 = io_oamAddr[1 : 0];
  assign spriteOamDo_17 = _zz_223;
  assign _zz_56 = (6'b010010);
  assign spriteAddr_18 = _zz_227;
  assign spritePixelData_18 = _zz_226;
  assign _zz_57 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010010)));
  assign _zz_58 = io_oamAddr[1 : 0];
  assign spriteOamDo_18 = _zz_228;
  assign _zz_59 = (6'b010011);
  assign spriteAddr_19 = _zz_232;
  assign spritePixelData_19 = _zz_231;
  assign _zz_60 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010011)));
  assign _zz_61 = io_oamAddr[1 : 0];
  assign spriteOamDo_19 = _zz_233;
  assign _zz_62 = (6'b010100);
  assign spriteAddr_20 = _zz_237;
  assign spritePixelData_20 = _zz_236;
  assign _zz_63 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010100)));
  assign _zz_64 = io_oamAddr[1 : 0];
  assign spriteOamDo_20 = _zz_238;
  assign _zz_65 = (6'b010101);
  assign spriteAddr_21 = _zz_242;
  assign spritePixelData_21 = _zz_241;
  assign _zz_66 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010101)));
  assign _zz_67 = io_oamAddr[1 : 0];
  assign spriteOamDo_21 = _zz_243;
  assign _zz_68 = (6'b010110);
  assign spriteAddr_22 = _zz_247;
  assign spritePixelData_22 = _zz_246;
  assign _zz_69 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010110)));
  assign _zz_70 = io_oamAddr[1 : 0];
  assign spriteOamDo_22 = _zz_248;
  assign _zz_71 = (6'b010111);
  assign spriteAddr_23 = _zz_252;
  assign spritePixelData_23 = _zz_251;
  assign _zz_72 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b010111)));
  assign _zz_73 = io_oamAddr[1 : 0];
  assign spriteOamDo_23 = _zz_253;
  assign _zz_74 = (6'b011000);
  assign spriteAddr_24 = _zz_257;
  assign spritePixelData_24 = _zz_256;
  assign _zz_75 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011000)));
  assign _zz_76 = io_oamAddr[1 : 0];
  assign spriteOamDo_24 = _zz_258;
  assign _zz_77 = (6'b011001);
  assign spriteAddr_25 = _zz_262;
  assign spritePixelData_25 = _zz_261;
  assign _zz_78 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011001)));
  assign _zz_79 = io_oamAddr[1 : 0];
  assign spriteOamDo_25 = _zz_263;
  assign _zz_80 = (6'b011010);
  assign spriteAddr_26 = _zz_267;
  assign spritePixelData_26 = _zz_266;
  assign _zz_81 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011010)));
  assign _zz_82 = io_oamAddr[1 : 0];
  assign spriteOamDo_26 = _zz_268;
  assign _zz_83 = (6'b011011);
  assign spriteAddr_27 = _zz_272;
  assign spritePixelData_27 = _zz_271;
  assign _zz_84 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011011)));
  assign _zz_85 = io_oamAddr[1 : 0];
  assign spriteOamDo_27 = _zz_273;
  assign _zz_86 = (6'b011100);
  assign spriteAddr_28 = _zz_277;
  assign spritePixelData_28 = _zz_276;
  assign _zz_87 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011100)));
  assign _zz_88 = io_oamAddr[1 : 0];
  assign spriteOamDo_28 = _zz_278;
  assign _zz_89 = (6'b011101);
  assign spriteAddr_29 = _zz_282;
  assign spritePixelData_29 = _zz_281;
  assign _zz_90 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011101)));
  assign _zz_91 = io_oamAddr[1 : 0];
  assign spriteOamDo_29 = _zz_283;
  assign _zz_92 = (6'b011110);
  assign spriteAddr_30 = _zz_287;
  assign spritePixelData_30 = _zz_286;
  assign _zz_93 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011110)));
  assign _zz_94 = io_oamAddr[1 : 0];
  assign spriteOamDo_30 = _zz_288;
  assign _zz_95 = (6'b011111);
  assign spriteAddr_31 = _zz_292;
  assign spritePixelData_31 = _zz_291;
  assign _zz_96 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b011111)));
  assign _zz_97 = io_oamAddr[1 : 0];
  assign spriteOamDo_31 = _zz_293;
  assign _zz_98 = (6'b100000);
  assign spriteAddr_32 = _zz_297;
  assign spritePixelData_32 = _zz_296;
  assign _zz_99 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100000)));
  assign _zz_100 = io_oamAddr[1 : 0];
  assign spriteOamDo_32 = _zz_298;
  assign _zz_101 = (6'b100001);
  assign spriteAddr_33 = _zz_302;
  assign spritePixelData_33 = _zz_301;
  assign _zz_102 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100001)));
  assign _zz_103 = io_oamAddr[1 : 0];
  assign spriteOamDo_33 = _zz_303;
  assign _zz_104 = (6'b100010);
  assign spriteAddr_34 = _zz_307;
  assign spritePixelData_34 = _zz_306;
  assign _zz_105 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100010)));
  assign _zz_106 = io_oamAddr[1 : 0];
  assign spriteOamDo_34 = _zz_308;
  assign _zz_107 = (6'b100011);
  assign spriteAddr_35 = _zz_312;
  assign spritePixelData_35 = _zz_311;
  assign _zz_108 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100011)));
  assign _zz_109 = io_oamAddr[1 : 0];
  assign spriteOamDo_35 = _zz_313;
  assign _zz_110 = (6'b100100);
  assign spriteAddr_36 = _zz_317;
  assign spritePixelData_36 = _zz_316;
  assign _zz_111 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100100)));
  assign _zz_112 = io_oamAddr[1 : 0];
  assign spriteOamDo_36 = _zz_318;
  assign _zz_113 = (6'b100101);
  assign spriteAddr_37 = _zz_322;
  assign spritePixelData_37 = _zz_321;
  assign _zz_114 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100101)));
  assign _zz_115 = io_oamAddr[1 : 0];
  assign spriteOamDo_37 = _zz_323;
  assign _zz_116 = (6'b100110);
  assign spriteAddr_38 = _zz_327;
  assign spritePixelData_38 = _zz_326;
  assign _zz_117 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100110)));
  assign _zz_118 = io_oamAddr[1 : 0];
  assign spriteOamDo_38 = _zz_328;
  assign _zz_119 = (6'b100111);
  assign spriteAddr_39 = _zz_332;
  assign spritePixelData_39 = _zz_331;
  assign _zz_120 = (io_oamWr && (io_oamAddr[7 : 2] == (6'b100111)));
  assign _zz_121 = io_oamAddr[1 : 0];
  assign spriteOamDo_39 = _zz_333;
  assign io_diag = _zz_139;
  assign io_oamDo = _zz_124;
  assign io_pixelActive = (((((((((spritePixelActive[spr0] || spritePixelActive[spr1]) || spritePixelActive[spr2]) || spritePixelActive[spr3]) || spritePixelActive[spr4]) || spritePixelActive[spr5]) || spritePixelActive[spr6]) || spritePixelActive[spr7]) || spritePixelActive[spr8]) || spritePixelActive[spr9]);
  assign io_pixelData = (spritePixelActive[spr0] ? _zz_125 : (spritePixelActive[spr1] ? _zz_126 : (spritePixelActive[spr2] ? _zz_127 : (spritePixelActive[spr3] ? _zz_128 : (spritePixelActive[spr4] ? _zz_129 : (spritePixelActive[spr5] ? _zz_130 : (spritePixelActive[spr6] ? _zz_131 : (spritePixelActive[spr7] ? _zz_132 : (spritePixelActive[spr8] ? _zz_133 : (spritePixelActive[spr9] ? _zz_134 : (2'b00)))))))))));
  assign io_pixelPrio = (spritePixelActive[spr0] ? spritePixelPrio[spr0] : (spritePixelActive[spr1] ? spritePixelPrio[spr1] : (spritePixelActive[spr2] ? spritePixelPrio[spr2] : (spritePixelActive[spr3] ? spritePixelPrio[spr3] : (spritePixelActive[spr4] ? spritePixelPrio[spr4] : (spritePixelActive[spr5] ? spritePixelPrio[spr5] : (spritePixelActive[spr6] ? spritePixelPrio[spr6] : (spritePixelActive[spr7] ? spritePixelPrio[spr7] : (spritePixelActive[spr8] ? spritePixelPrio[spr8] : (spritePixelActive[spr9] ? spritePixelPrio[spr9] : 1'b0))))))))));
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
    .io_ir(ir),
    .clkout0(clkout0),
    ._zz_1(_zz_2) 
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
      input   io_cpuSelOam,
      input  [7:0] oamAddr,
      input  [7:0] io_cpuDataOut,
      input   io_cpuWr,
      output [7:0] io_cpuDataIn,
      input   clkout0,
      input   _zz_1);
  wire  _zz_2;
  wire [15:0] _zz_3;
  wire [3:0] _zz_4;
  wire  _zz_5;
  wire [7:0] _zz_6;
  wire  _zz_7;
  reg [15:0] _zz_8;
  wire  _zz_9;
  wire [7:0] _zz_10;
  wire [7:0] _zz_11;
  wire  _zz_12;
  wire  _zz_13;
  wire  _zz_14;
  wire  _zz_15;
  wire  _zz_16;
  wire  _zz_17;
  wire  _zz_18;
  wire [1:0] _zz_19;
  wire  _zz_20;
  wire [10:0] _zz_21;
  wire [7:0] _zz_22;
  wire [7:0] _zz_23;
  wire  _zz_24;
  wire  _zz_25;
  wire  _zz_26;
  wire  _zz_27;
  wire [7:0] _zz_28;
  wire [2:0] _zz_29;
  wire [2:0] _zz_30;
  wire [3:0] _zz_31;
  wire [1:0] _zz_32;
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
  reg [4:0] bitCycle;
  wire [12:0] bgScrnAddress;
  wire [12:0] windowAddress;
  wire  showWindow;
  wire  windowPriority;
  wire [12:0] textureAddress;
  wire  inWindow;
  wire  bgOn;
  wire [7:0] tileX;
  wire [7:0] tileY;
  wire [7:0] winTileX;
  wire [7:0] winTileY;
  wire [2:0] bitx;
  reg [10:0] spriteAddr;
  reg [1:0] hExtraTiles;
  wire [7:0] hExtra;
  wire  hBlank;
  wire  vBlank;
  reg [1:0] spriteDValid;
  wire  bit0;
  wire  bit1;
  wire [1:0] color;
  assign _zz_24 = (bitCycle == (5'b00001));
  assign _zz_25 = (bitCycle == (5'b00010));
  assign _zz_26 = (bitx == (3'b111));
  assign _zz_27 = (bitCycle == (5'b00000));
  assign _zz_28 = ((8'b11110000) + hExtra);
  assign _zz_29 = ((3'b111) - bitx);
  assign _zz_30 = ((3'b111) - bitx);
  assign _zz_31 = (color * (2'b10));
  assign _zz_32 = io_bgPalette[_zz_31 +: 2];
  ST7789 lcd ( 
    .io_pixels_valid(_zz_2),
    .io_pixels_ready(_zz_9),
    .io_pixels_payload(_zz_3),
    .io_x(_zz_10),
    .io_y(_zz_11),
    .io_next_pixel(_zz_12),
    .io_oled_csn(_zz_13),
    .io_oled_clk(_zz_14),
    .io_oled_mosi(_zz_15),
    .io_oled_dc(_zz_16),
    .io_oled_resn(_zz_17),
    .clkout0(clkout0),
    ._zz_2(_zz_1) 
  );
  Sprites sprites_1 ( 
    .io_index(_zz_4),
    .io_size16(_zz_5),
    .io_x(x),
    .io_y(y),
    .io_dValid(spriteDValid),
    .io_data(_zz_6),
    .io_pixelActive(_zz_18),
    .io_pixelData(_zz_19),
    .io_pixelPrio(_zz_20),
    .io_addr(_zz_21),
    .io_oamWr(_zz_7),
    .io_oamAddr(oamAddr),
    .io_oamDi(io_cpuDataOut),
    .io_oamDo(_zz_22),
    .io_diag(_zz_23),
    .clkout0(clkout0),
    ._zz_1(_zz_1) 
  );
  always @(*) begin
    case(_zz_32)
      2'b00 : begin
        _zz_8 = colors_0;
      end
      2'b01 : begin
        _zz_8 = colors_1;
      end
      2'b10 : begin
        _zz_8 = colors_2;
      end
      default : begin
        _zz_8 = colors_3;
      end
    endcase
  end

  assign io_mode = mode;
  assign colors_0 = (16'b0000100110100001);
  assign colors_1 = (16'b0010101100000101);
  assign colors_2 = (16'b1000010101000001);
  assign colors_3 = (16'b1001010111000001);
  assign io_currentY = y;
  assign io_oled_csn = _zz_13;
  assign io_oled_resn = _zz_17;
  assign io_oled_dc = _zz_16;
  assign io_oled_mosi = _zz_15;
  assign io_oled_clk = _zz_14;
  always @ (*) begin
    io_address = (13'b0000000000000);
    spriteDValid = (2'b00);
    if(_zz_26)begin
      if(_zz_27)begin
        if(inWindow)begin
          io_address = (windowAddress + {{(3'b000),winTileY[7 : 3]},winTileX[7 : 3]});
        end else begin
          io_address = (bgScrnAddress + {{(3'b000),tileY[7 : 3]},tileX[7 : 3]});
        end
      end else begin
        if(_zz_24)begin
          if(_zz_18)begin
            spriteDValid = (2'b10);
            io_address = {(2'b00),spriteAddr};
          end else begin
            io_address = (textureAddress + {{{(1'b0),io_dataIn},tileY[2 : 0]},(1'b0)});
          end
        end else begin
          if(_zz_25)begin
            if(_zz_18)begin
              spriteDValid = (2'b01);
              io_address = {(2'b00),spriteAddr};
            end else begin
              io_address = (textureAddress + {{{(1'b0),tile},tileY[2 : 0]},(1'b1)});
            end
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
  assign winTileX = (x - io_windowX);
  assign winTileY = (y - io_windowY);
  assign bitx = tileX[2 : 0];
  assign hExtra = ({{(3'b000),hExtraTiles},(3'b000)} + (8'b00010000));
  assign hBlank = ((x < (8'b01010000)) || (_zz_28 <= x));
  assign vBlank = ((8'b10010000) <= y);
  assign _zz_5 = io_lcdControl[2];
  assign _zz_4 = (4'b0000);
  assign _zz_6 = (8'b11111111);
  assign _zz_7 = (io_cpuWr && io_cpuSelOam);
  assign io_cpuDataIn = _zz_22;
  assign io_diag = _zz_23;
  assign bit0 = texture0[_zz_29];
  assign bit1 = texture1[_zz_30];
  assign color = ((_zz_18 && (! bgOn)) ? _zz_19 : {bit1,bit0});
  assign _zz_3 = _zz_8;
  assign _zz_2 = (((x < (8'b10100000)) && (y < (8'b10010000))) && io_lcdControl[7]);
  always @ (posedge clkout0 or negedge _zz_1) begin
    if (!_zz_1) begin
      mode <= (2'b00);
      x <= (8'b00000000);
      y <= (8'b00000000);
    end else begin
      mode <= (((8'b10001111) < y) ? (2'b01) : (2'b00));
      if(_zz_9)begin
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
    bitCycle <= (bitCycle + (5'b00001));
    spriteAddr <= _zz_21;
    if(_zz_26)begin
      if(! _zz_27) begin
        if(_zz_24)begin
          if(! _zz_18) begin
            tile <= io_dataIn;
          end
        end else begin
          if(_zz_25)begin
            if(! _zz_18) begin
              if(bgOn)begin
                texture0 <= io_dataIn;
              end else begin
                texture0 <= (8'b00000000);
              end
            end
          end else begin
            if((bitCycle == (5'b00011)))begin
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
    if(_zz_9)begin
      bitCycle <= (5'b00000);
    end
  end

endmodule

module GameBoy64Ulx3s (
      output  io_oled_csn,
      output  io_oled_resn,
      output  io_oled_dc,
      output  io_oled_mosi,
      output  io_oled_clk,
      output [7:0] io_led,
      output [4:0] io_leds,
      input  [7:0] io_btn,
      input   clkout0,
      input   _zz_4);
  reg [7:0] _zz_5;
  wire  _zz_6;
  wire [7:0] _zz_7;
  wire [7:0] _zz_8;
  wire [7:0] _zz_9;
  wire [7:0] _zz_10;
  wire [15:0] _zz_11;
  wire [7:0] _zz_12;
  wire  _zz_13;
  wire  _zz_14;
  wire  _zz_15;
  wire [7:0] _zz_16;
  wire  _zz_17;
  wire  _zz_18;
  wire  _zz_19;
  wire  _zz_20;
  wire  _zz_21;
  wire [12:0] _zz_22;
  wire [1:0] _zz_23;
  wire [7:0] _zz_24;
  wire [7:0] _zz_25;
  wire [7:0] _zz_26;
  wire  _zz_27;
  wire [1:0] _zz_28;
  wire [15:0] _zz_29;
  wire [12:0] _zz_30;
  wire [7:0] _zz_31;
  wire [7:0] _zz_32;
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
  reg  IRQ;
  reg [11:0] timer;
  wire [15:0] _zz_3;
  reg [7:0] memory [0:57343];
  reg [7:0] vidMem [0:8191];
  assign _zz_27 = (((16'b1000000000000000) <= _zz_11) && (_zz_11 < (16'b1010000000000000)));
  assign _zz_28 = rTAC[1 : 0];
  assign _zz_29 = (_zz_11 - (16'b1000000000000000));
  assign _zz_30 = _zz_29[12:0];
  assign _zz_31 = _zz_12;
  assign _zz_32 = _zz_12;
  initial begin
    $readmemb("GameBoyUlx3s.v_toplevel_coreClockingArea_gameboy_memory.bin",memory);
  end
  always @ (posedge clkout0) begin
    if(_zz_1) begin
      memory[address] <= _zz_31;
    end
  end

  assign _zz_9 = memory[_zz_3];
  always @ (posedge clkout0) begin
    if(_zz_2) begin
      vidMem[_zz_30] <= _zz_32;
    end
  end

  assign _zz_10 = vidMem[_zz_22];
  Cpu cpu_1 ( 
    .io_address(_zz_11),
    .io_dataIn(_zz_5),
    .io_dataOut(_zz_12),
    .io_mreq(_zz_13),
    .io_write(_zz_14),
    .io_halt(_zz_15),
    .io_diag(_zz_16),
    .clkout0(clkout0),
    ._zz_2(_zz_4) 
  );
  PPUUlx3s ppu ( 
    .io_oled_csn(_zz_17),
    .io_oled_resn(_zz_18),
    .io_oled_dc(_zz_19),
    .io_oled_mosi(_zz_20),
    .io_oled_clk(_zz_21),
    .io_address(_zz_22),
    .io_lcdControl(rLCDC),
    .io_startX(rSCX),
    .io_startY(rSCY),
    .io_windowX(rWX),
    .io_windowY(rWY),
    .io_bgPalette(rBGP),
    .io_mode(_zz_23),
    .io_currentY(_zz_24),
    .io_dataIn(ppuIn),
    .io_diag(_zz_25),
    .io_cpuSelOam(_zz_6),
    .oamAddr(_zz_7),
    .io_cpuDataOut(_zz_8),
    .io_cpuWr(_zz_14),
    .io_cpuDataIn(_zz_26),
    .clkout0(clkout0),
    ._zz_1(_zz_4) 
  );
  always @ (*) begin
    _zz_1 = 1'b0;
    _zz_2 = 1'b0;
    if(_zz_14)begin
      if(_zz_27)begin
        _zz_2 = 1'b1;
      end else begin
        _zz_1 = 1'b1;
      end
    end
  end

  assign io_oled_csn = 1'b1;
  assign io_oled_resn = _zz_18;
  assign io_oled_dc = _zz_19;
  assign io_oled_mosi = _zz_20;
  assign io_oled_clk = _zz_21;
  assign _zz_6 = (_zz_11[15 : 8] == (8'b11111110));
  assign _zz_7 = _zz_11[7 : 0];
  assign _zz_8 = _zz_12;
  always @ (*) begin
    if(((16'b1010000000000000) <= _zz_11))begin
      address = (_zz_11 - (16'b0010000000000000));
    end else begin
      address = _zz_11;
    end
  end

  assign _zz_3 = address;
  always @ (*) begin
    case(_zz_11)
      16'b1111111101000000 : begin
        _zz_5 = (rLCDC & (8'b01111111));
      end
      16'b1111111101000001 : begin
        _zz_5 = {{rSTAT[7 : 3],(rLY == rLYC)},_zz_23};
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

  assign io_led = _zz_25;
  assign io_leds = {{{{io_btn[7],io_btn[6]},io_btn[4]},io_btn[5]},(1'b0)};
  always @ (posedge clkout0) begin
    ppuIn <= _zz_10;
    timer <= (timer + (12'b000000000001));
    if(((timer & (12'b001111111111)) == (12'b000000000000)))begin
      rDIV <= (rDIV + (8'b00000001));
    end
    IRQ <= 1'b0;
    if(rTAC[2])begin
      case(_zz_28)
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
        IRQ <= 1'b1;
        rTIMA <= rTMA;
      end
    end
    rJOYP <= ((! rButtonSelect[0]) ? {(4'b0000),(~ io_btn[7 : 4])} : {(4'b0000),(~ io_btn[3 : 0])});
    rLY <= _zz_24;
    dataIn <= _zz_9;
    if(_zz_14)begin
      if(! _zz_27) begin
        case(_zz_11)
          16'b1111111101000000 : begin
            rLCDC <= _zz_12;
          end
          16'b1111111101000001 : begin
            rSTAT <= _zz_12;
          end
          16'b1111111101000010 : begin
            rSCY <= _zz_12;
          end
          16'b1111111101000011 : begin
            rSCX <= _zz_12;
          end
          16'b1111111101000101 : begin
            rLYC <= _zz_12;
          end
          16'b1111111101000110 : begin
            rDMA <= _zz_12;
          end
          16'b1111111101000111 : begin
            rBGP <= _zz_12;
          end
          16'b1111111101001000 : begin
            rOBP0 <= _zz_12;
          end
          16'b1111111101001001 : begin
            rOBP1 <= _zz_12;
          end
          16'b1111111101001010 : begin
            rWY <= _zz_12;
          end
          16'b1111111101001011 : begin
            rWX <= _zz_12;
          end
          16'b1111111100000100 : begin
            rDIV <= (8'b00000000);
          end
          16'b1111111100000101 : begin
            rTIMA <= _zz_12;
          end
          16'b1111111100000110 : begin
            rTMA <= _zz_12;
          end
          16'b1111111100000111 : begin
            rTAC <= _zz_12;
          end
          16'b1111111100000000 : begin
            rButtonSelect <= _zz_12[5 : 4];
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
      input  [6:0] btn,
      output [4:0] leds,
      input  [2:0] button);
  wire [7:0] _zz_2;
  wire  _zz_3;
  wire  _zz_4;
  wire  _zz_5;
  wire  _zz_6;
  wire  _zz_7;
  wire  _zz_8;
  wire  _zz_9;
  wire [7:0] _zz_10;
  wire [4:0] _zz_11;
  wire  _zz_1;
  pll pll_1 ( 
    .clkin(clk_25mhz),
    .clkout0(_zz_3),
    .locked(_zz_4) 
  );
  GameBoy64Ulx3s coreClockingArea_gameboy ( 
    .io_oled_csn(_zz_5),
    .io_oled_resn(_zz_6),
    .io_oled_dc(_zz_7),
    .io_oled_mosi(_zz_8),
    .io_oled_clk(_zz_9),
    .io_led(_zz_10),
    .io_leds(_zz_11),
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
  assign leds = _zz_11;
  assign _zz_2 = {{{{{btn[3],btn[4]},btn[6]},btn[5]},btn[2 : 1]},button[1 : 0]};
endmodule

