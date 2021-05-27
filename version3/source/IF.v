/**
 * @file	IF.v
 * @author	LiuChuanXi
 * @date	2021.05.26
 * @version	V2.1
 * @brief	MIPS CPU的取指令模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.25	<td>V1.1		<td>LiuChuanXi	<td>整理包含头文件
 * <tr><td>2021.05.25	<td>V1.2		<td>LiuChuanXi	<td>将rst和pc功能分成两个always块，pc初始值改为FC
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始version2
 * <tr><td>2021.05.26	<td>V2.1		<td>LiuChuanXi	<td>增加了对J型指令的支持
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	IF(取指令)模块
 * @param	clk		input，时钟信号
 * @param	rst		input，复位信号，高有效
 * @param	jAddr	input，跳转指令将要跳转到的地址，长度与PC相同
 * @param	jCe		input，跳转功能使能信号
 * @param	pc		output，程序指针，每次自加大小为`PC_STEP(默认为4)
 * @param	romCe	output，指令存储器InstMem(rom)模块片选信号
 */
module IF(
	clk, rst,
	jAddr, jCe,
	pc, romCe
);

	/* input */
	input wire clk;							//时钟信号
	input wire rst;							//复位信号
	input wire[`PC_LENGTH-1:0] jAddr;		//跳转指令功能，跳转地址
	input wire jCe;							//跳转指令功能，跳转使能信号

	/* output */
	output reg[`PC_LENGTH-1:0] pc;			//程序指针
	output reg romCe;						//指令存储器的片选使能信号


	/* 模块初始化 */
	initial begin
		/* PC归零 */
		pc <= ({`PC_LENGTH{1'b0}} - `PC_STEP);
		/* 指令存储器InstMem模块使能 */
		romCe <= `DISABLE;
	end

	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* PC归零 */
			pc <= ({`PC_LENGTH{1'b0}} - `PC_STEP);
			/* 指令存储器InstMem模块使能 */
			romCe <= `DISABLE;
		end
		else begin
			/* InstMem指令存储器使能信号romCe有效 */
			romCe <= `ENABLE;
		end
	end

	/* PC正常工作 */
	always@(posedge clk) begin
		/**
		 * 复位信号rst无效
		 * 正常工作，当jCe无效时PC自加(`PC_STEP)，jCe有效则跳转到jAddr
		 */
		if(rst == `DISABLE) begin
			pc <= (jCe == `ENABLE) ? jAddr : pc + `PC_STEP;
		end
	end


endmodule
