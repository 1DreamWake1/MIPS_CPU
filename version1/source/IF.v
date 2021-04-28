/**
 * @file	IF.v
 * @author	LiuChuanXi
 * @date	2021.04.28
 * @version	V1.0
 * @brief	MIPS CPU的取指令模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`include "IF.vh"


/**
 * @author	LiuChuanXi
 * @brief	IF(取指令)模块
 * @param	clk		input，时钟信号
 * @param	rst		input，复位信号，高有效
 * @param	pc		output，程序指针，每次自加大小为`PC_STEP(默认为4)
 * @param	romCe	output，指令存储器InstMem(rom)模块片选信号
 */
module IF(clk, rst, pc, romCe);

	/* input */
	input wire clk;
	input wire rst;
	/* output */
	output reg[`PC_LENGTH] pc;
	output reg romCe;

	/* 模块初始化 */
	initial begin

		/* PC归零 */
		pc = {`PC_LENGTH{1'b0}};
		/* 指令存储器InstMem模块使能 */
		romCe = `ENABLE;

	end

	/* 功能 */
	always@(posedge clk, rst) begin

		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* PC归零 */
			pc = {`PC_LENGTH{1'b0}};
			/* 指令存储器InstMem模块使能 */
			romCe = `ENABLE;
		end
		/* 正常工作，PC自加(`PC_STEP) */
		else begin
			pc <= pc + `PC_STEP;
		end

	end


endmodule
