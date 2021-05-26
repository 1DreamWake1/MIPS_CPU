/**
 * @file	MIPS.v
 * @author	LiuChuanXi
 * @date	2021.05.26
 * @version	V2.0
 * @brief	MIPS CPU顶层模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.24	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.25	<td>V1.1		<td>LiuChuanXi	<td>整理包含头文件
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	MIPS CPU 顶层模块
 * @param	clk			input，时钟
 * @param	rst			input，复位信号，高有效
 * @param	inst		input，从指令存储器读出来的指令
 * @param	romCe		output，指令存储器使能信号
 * @param	pc			output，程序计数器
 */
module MIPS(
	clk, rst, inst,
	romCe, pc
);

	/* input */
	input wire clk;
	input wire rst;
	input wire[`INST_LENGTH-1:0] inst;
	/* output */
	output wire romCe;
	output wire[`PC_LENGTH-1:0] pc;
	
	/* private */
	/* ID RegFile */
	wire[`REG_LENGTH-1:0] regaData_i, regbData_i;
	wire[`REG_ADDR_LEN-1:0] regaAddr, regbAddr;
	wire regaRd, regbRd;
	/* ID EX */
	wire[`OP_LENGTH-1:0] op;
	wire[`REG_LENGTH-1:0] regaData, regbData;
	wire regcWr_i;
	wire[`REG_ADDR_LEN-1:0] regcAddr_i;
	/* EX RegFile */
	wire[`REG_LENGTH-1:0] regcData;
	wire[`REG_ADDR_LEN-1:0] regcAddr;
	wire regcWr;
	/* IF ID */
	wire[`PC_LENGTH-1:0] jAddr;
	wire jCe;

	/* module */
	IF if_m(
		.clk(clk), .rst(rst),
		.jCe(jCe), .jAddr(jAddr),
		.pc(pc), .romCe(romCe)
	);
	ID id_m(
		.rst(rst), .inst(inst), .regaData_i(regaData_i), .regbData_i(regbData_i), .pc(pc),
		.op(op), .regaData(regaData), .regbData(regbData), .regcWr(regcWr_i), .regcAddr(regcAddr_i),
		.regaRd(regaRd), .regbRd(regbRd), .regaAddr(regaAddr), .regbAddr(regbAddr),
		.jCe(jCe), .jAddr(jAddr)
	);
	EX ex_m(
		.rst(rst), .op(op), .regaData(regaData), .regbData(regbData), .regcWr_i(regcWr_i), .regcAddr_i(regcAddr_i),
		.regcData(regcData), .regcAddr(regcAddr), .regcWr(regcWr)
	);
	RegFile regfile_m(
		.clk(clk), .rst(rst),
		.regaAddr(regaAddr), .regbAddr(regbAddr), .regaRd(regaRd), .regbRd(regbRd),
		.we(regcWr), .wAddr(regcAddr), .wData(regcData),
		.regaData(regaData_i), .regbData(regbData_i)
	);


endmodule

