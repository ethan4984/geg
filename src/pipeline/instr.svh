`ifndef INSTR_SVH_
`define INSTR_SVH_

`define RV32I_OPCODE_R 7'b0110011
`define RV32I_OPCODE_I 7'b0010011
`define RV32I_OPCODE_L 7'b0000011
`define RV32I_OPCODE_S 7'b0100011
`define RV32I_OPCODE_B 7'b1100011

typedef struct packed {
  logic [6:0] FUNC7;
  logic [4:0] RS2;
  logic [4:0] RS1;
  logic [2:0] FUNC3;
  logic [4:0] RD;
  logic [6:0] OPCODE;
} instrr_t;

typedef union packed {
  struct packed {
    logic [6:0] OPCODE;
    logic [4:0] RD;
    logic [2:0] FUNC3;
    logic [4:0] RS1;
    logic [11:0] IMM;
  } IMM;

  struct packed {
    logic [6:0] OPCODE;
    logic [4:0] RD1;
    logic [2:0] FUNC3;
    logic [4:0] RS2;
    logic [4:0] SHAMT;
    logic [6:0] IMM;
  } SHIFT;
} instri_t;

typedef struct packed {
  logic [6:0] OPCODE;
  logic [4:0] RD;
  logic [19:0] IMM;
} instru_t;

typedef struct packed {
  logic [6:0] OPCODE;
  logic [4:0] IMM1;
  logic [2:0] FUNC3;
  logic [4:0] RS1;
  logic [4:0] RS2;
  logic [6:0] IMM2;
} instrs_t;

typedef struct packed {
  logic [6:0] OPCODE;
  logic [0:0] IMM1;
  logic [3:0] IMM2;
  logic [2:0] FUNC3;
  logic [4:0] RS1;
  logic [4:0] RS2;
  logic [5:0] IMM3;
  logic [0:0] IMM4;
} instrb_t;

typedef struct packed {
  logic [6:0] OPCODE;
  logic [4:0] RD;
  logic [7:0] IMM1;
  logic [0:0] IMM2;
  logic [9:0] IMM3;
  logic [0:0] IMM4;
} instrj_t;

typedef union packed {
  instrr_t INSTRR;
  instri_t INSTRI;
  instru_t INSTRU;
  instrs_t INSTRS;
  instrb_t INSTRB;
  instrj_t INSTRJ;
  logic [31:0] RAW;
} instr_t;

`define OP_CLASS_ALU 0

`define INSTRR_INSTANTIATE_OP(FUNCTION) \
  OP.CLASS <= `OP_CLASS_ALU; \
  OP.FUNC <= (FUNCTION); \
  OP.RS1 <= INSTR.RS1; \
  OP.RS2 <= INSTR.RS2; \
  OP.RD <= INSTR.RD;

typedef struct packed {
  logic [2:0] CLASS;
  logic [3:0] FUNC;
  logic [4:0] RS1;
  logic [4:0] RS2;
  logic [4:0] RD;
} op_t;

`endif