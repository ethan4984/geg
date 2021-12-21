`ifndef DECODE_SVH_
`define DECODE_SVH_

`define OPCODE_R_TYPE 7'b0110011
`define OPCODE_I_TYPE 7'b0010011
`define OPCODE_MI_TYPE 7'b0000011
`define OPCODE_S_TYPE 7'b0100011
`define OPCODE_B_TYPE 7'b1100011

typedef struct packed {
	logic [6:0] func7;
	logic [4:0] rs2;
	logic [4:0] rs1;
	logic [2:0] func3;
	logic [4:0] rd;
	logic [6:0] opcode;
} instr_t;

typedef union packed {
	struct packed {
		logic [6:0] opcode;
		logic [4:0] rd;
		logic [2:0] func3;
		logic [4:0] rs1;
		logic [11:0] imm;
	} imm; 

	struct packed {
		logic [6:0] opcode;
		logic [4:0] rd1;
		logic [2:0] func3;
		logic [4:0] rs2;
		logic [4:0] shamt;
		logic [6:0] imm;
	} shift;
} insti_t;

typedef struct packed {
	logic [6:0] opcode;
	logic [4:0] rd;
	logic [19:0] imm;
} instu_t;

typedef struct packed {
	logic [6:0] opcode;
	logic [4:0] imm1;
	logic [2:0] func3;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [6:0] imm2;
} insts_t;

typedef struct packed {
	logic [6:0] opcode;
	logic [0:0] imm1;
	logic [3:0] imm2;
	logic [2:0] func3;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [5:0] imm3;
	logic [0:0] imm4;
} instb_t;

typedef struct packed {
	logic [6:0] opcode;
	logic [4:0] rd;
	logic [7:0] imm1;
	logic [0:0] imm2;
	logic [9:0] imm3;
	logic [0:0] imm4;
} instj_t;

typedef union packed {
	instr_t instr;
	insti_t insti;
	instu_t instu;
	insts_t insts;
	instb_t instb;
	instj_t instj;
	logic [31:0] raw;
} instruction_t;

`endif
