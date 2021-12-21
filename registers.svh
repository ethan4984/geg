`ifndef REGISTERS_SVH_
`define REGISTERS_SVH_

`define REGISTER_OPERATION_GPR 0
`define REGISTER_OPERATION_FLAGS 1
`define REGISTER_OPERATION_PC 2

typedef struct packed {
	logic [1:0] operation;
	logic [31:0] data;
	logic [4:0] rs;
} write_back_t;

`endif
