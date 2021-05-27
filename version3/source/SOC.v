/**
 * @file	SOC.v
 * @author	LiuChuanXi
 * @date	2021.05.25
 * @version	V1.0
 * @brief	MIPS CPU顶层SOC
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.25	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


/* MIPS CPU CORE */
`include "MIPS.vh"
/* InstMem指令存储器 */
`include "InstMem.vh"

module SOC(
	clk, rst
);

	/* input */
	input wire clk;
	input wire rst;

	/* output */


	/* private */
	wire[`PC_LENGTH-1:0] pc;
	wire romCe;
	wire[`INST_LENGTH-1:0] inst;

	/* module */
	MIPS mips_m(
		.clk(clk), .rst(rst),
		.inst(inst), .romCe(romCe), .pc(pc)
	);
	InstMem instmem_m(
		.ce(romCe), .addr(pc), .data(inst)
	);


endmodule

