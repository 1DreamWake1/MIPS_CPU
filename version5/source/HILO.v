/**
 * @file	HILO.vh
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V5.1
 * @brief	MIPS_CPU hi、lo寄存器模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.06.02	<td>V5.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.06.02	<td>V5.1		<td>LiuChuanXi	<td>修改写回操作为clk上升沿
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	hi、lo寄存器模块
 * @note	---HILO---
 * @param	clk			input，时钟信号
 * @param	rst			input，复位信号，高有效
 * @note	---ID---
 * @param	hiRdCe		input，hi寄存器读使能信号
 * @param	loRdCe		input，lo寄存器读使能信号
 * @param	hiRdData	output，hi寄存器读出的数据
 * @param	loRdData	output，lo寄存器读出的数据
 * @note	---MEM---
 * @param	hiWtCe		input，hi寄存器写使能信号
 * @param	loWtCe		input，lo寄存器写使能信号
 * @param	hiWtData	input，hi寄存器所写数据
 * @param	loWtData	input，lo寄存器所写数据
 */
module HILO(
	clk, rst,
	hiRdCe, loRdCe, hiRdData, loRdData,
	hiWtCe, loWtCe, hiWtData, loWtData
);

	/* HILO */
	input wire clk;								//时钟信号
	input wire rst;								//复位信号

	/* ID */
	input wire hiRdCe;							//hi寄存器读使能信号
	input wire loRdCe;							//lo寄存器读使能信号
	output wire[`REG_LENGTH-1:0] hiRdData;		//hi寄存器读出的数据
	output wire[`REG_LENGTH-1:0] loRdData;		//lo寄存器读出的数据

	/* MEM */
	input wire hiWtCe;							//hi寄存器写使能信号
	input wire loWtCe;							//lo寄存器写使能信号
	input wire[`REG_LENGTH-1:0] hiWtData;		//hi寄存器所写数据
	input wire[`REG_LENGTH-1:0] loWtData;		//lo寄存器所写数据

	/* private */
	reg[`REG_LENGTH-1:0] hi_reg;				//hi寄存器
	reg[`REG_LENGTH-1:0] lo_reg;				//lo寄存器


	/* 模块初始化 */
	initial begin
		hi_reg <= {`REG_LENGTH{1'b0}};
		lo_reg <= {`REG_LENGTH{1'b0}};
	end


	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			hi_reg <= {`REG_LENGTH{1'b0}};
			lo_reg <= {`REG_LENGTH{1'b0}};
		end
	end


	/* 读操作，组合逻辑 */
	assign hiRdData = ((rst == `DISABLE) && (hiRdCe == `ENABLE)) ? hi_reg : {`REG_LENGTH{1'bz}};
	assign loRdData = ((rst == `DISABLE) && (loRdCe == `ENABLE)) ? lo_reg : {`REG_LENGTH{1'bz}};


	/* 写操作，时序逻辑 */
	always@(posedge clk) begin
		/* hi_reg */
		if((rst == `DISABLE) && (hiWtCe == `ENABLE)) begin
			hi_reg <= hiWtData;
		end
		/* lo_reg */
		if((rst == `DISABLE) && (loWtCe == `ENABLE)) begin
			lo_reg <= loWtData;
		end
	end


endmodule
