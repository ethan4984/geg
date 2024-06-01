`ifndef RISCV_SVH_
`define RISCV_SVH_ 

`define ALU_OP_ADD 0
`define ALU_OP_SUB 1
`define ALU_OP_SLL 2
`define ALU_OP_SLT 3
`define ALU_OP_SLTU 4
`define ALU_OP_XOR 5
`define ALU_OP_SRL 6
`define ALU_OP_SRA 7
`define ALU_OP_OR 8
`define ALU_OP_AND 9
`define ALU_OP_EQ 10
`define ALU_OP_BNE 11
`define ALU_OP_BLT 12
`define ALU_OP_BGE 13
`define ALU_OP_BLTU 14
`define ALU_OP_BEGU 15

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
    logic [11:0] IMM;
    logic [4:0] RS1;
    logic [2:0] FUNC3;
    logic [4:0] RD;
    logic [6:0] OPCODE;
  } IMM;

  struct packed {
    logic [6:0] IMM;
    logic [4:0] SHAMT;
    logic [4:0] RS2;
    logic [2:0] FUNC3;
    logic [4:0] RD1;
    logic [6:0] OPCODE;
  } SHIFT;
} instri_t;

typedef struct packed {
  logic [19:0] IMM;
  logic [4:0] RD;
  logic [6:0] OPCODE;
} instru_t;

typedef struct packed {
  logic [6:0] IMM2;
  logic [4:0] RS2;
  logic [4:0] RS1;
  logic [2:0] FUNC3;
  logic [4:0] IMM1;
  logic [6:0] OPCODE;
} instrs_t;

typedef struct packed {
  logic [0:0] IMM4;
  logic [5:0] IMM3;
  logic [4:0] RS2;
  logic [4:0] RS1;
  logic [2:0] FUNC3;
  logic [3:0] IMM2;
  logic [0:0] IMM1;
  logic [6:0] OPCODE;
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

`endif
