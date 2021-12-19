`ifndef EXECUTE_H_
`define EXECUTE_H_

`define OPERATION_ALU 0
`define OPERATION_MEM 1
`define OPERATION_BRANCH 2

typedef struct packed {
	logic [4:0] operation_type;
	logic [4:0] operation_function;
	logic [31:0] operand0;
	logic [31:0] operand1;
	logic [31:0] dest;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [4:0] dest;
} operation_t;

`endif
