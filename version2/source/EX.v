/**
 * @file	EX.v
 * @author	LiuChuanXi
 * @date	2021.05.26
 * @version	V2.2
 * @brief	MIPS_CPU执行模块EX
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.24	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.25	<td>V1.1		<td>LiuChuanXi	<td>整理包含头文件
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * <tr><td>2021.05.26	<td>V2.1		<td>LiuChuanXi	<td>增加对J型指令的支持
 * <tr><td>2021.05.26	<td>V2.2		<td>LiuChuanXi	<td>J型指令完成，version2完成
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	EX(执行)模块
 * @param	rst			input，复位信号，高有效
 * @param	op			input，指令译码后对应的指令编码(CMD_XXX)
 * @param	regaData	input，寄存器A数据输入
 * @param	regbData	input，寄存器B数据输入
 * @param	regcWr_i	input，目的寄存器c写使能信号
 * @param	regcAddr_i	input，目的寄存器c对应地址(寄存器编号)
 * @param	regcData	output，目的寄存器c数据输出
 * @param	regcAddr	output，目的寄存器c地址输出
 * @param	regcWr		output，目的寄存器c写控制信号
 */
module EX(
	rst, op, regaData, regbData, regcWr_i, regcAddr_i,
	regcData, regcAddr, regcWr
);

	/* input */
	input wire rst;								//复位信号
	input wire[`OP_LENGTH-1:0] op;				//指令译码后对应的指令编码(CMD_XXX)
	input wire[`REG_LENGTH-1:0] regaData;		//寄存器A数据输入
	input wire[`REG_LENGTH-1:0] regbData;		//寄存器B数据输入
	input wire regcWr_i;						//目的寄存器c写使能信号
	input wire[`REG_ADDR_LEN-1:0] regcAddr_i;	//目的寄存器c对应地址(寄存器编号)

	/* output */
	output reg[`REG_LENGTH-1:0] regcData;		//目的寄存器c数据输出
	output reg[`REG_ADDR_LEN-1:0] regcAddr;		//目的寄存器c地址输出
	output reg regcWr;							//目的寄存器c写控制信号


	/* 模块初始化 */
	initial begin
		/* 目标寄存器c输出数据为0 */
		regcData = {`REG_LENGTH{1'b0}};
		/* 目标寄存器c地址对应0号寄存器 */
		regcAddr = {`REG_ADDR_LEN{1'b0}};
		/* 目标寄存器写不使能 */
		regcWr = `DISABLE;
	end


	/* 功能 */

	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* 目标寄存器c输出数据为0 */
			regcData = {`REG_LENGTH{1'b0}};
			/* 目标寄存器c地址对应0号寄存器 */
			regcAddr = {`REG_ADDR_LEN{1'b0}};
			/* 目标寄存器写不使能 */
			regcWr = `DISABLE;
		end
	end

	/* 执行指令 */
	always@(*) begin
		/* 复位信号rst无效 */
		if(rst == `DISABLE) begin
			/* 根据op进行相应运算 */
			case(op)
				`CMD_ADD: begin
					/* 运算与写回 */
					regcData <= regaData + regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_SUB: begin
					/* 运算与写回 */
					regcData <= regaData - regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_AND: begin
					/* 运算与写回 */
					regcData <= regaData & regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_OR: begin
					/* 运算与写回 */
					regcData <= regaData | regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_XOR: begin
					/* 运算与写回 */
					regcData <= regaData ^ regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_SLL: begin
					/* 运算与写回 */
					regcData <= regaData << regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_SRL: begin
					/* 运算与写回 */
					regcData <= regaData >> regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_SRA: begin
					/* 运算与写回 */
					regcData <= (regaData >> regbData) | ({`REG_LENGTH{regaData[`REG_LENGTH-1]}} << (`REG_LENGTH - regbData));
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_JR: begin
					/* 运算与写回 */
					regcData <= {`REG_LENGTH{1'b0}};
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_ADDI: begin
					/* 运算与写回 */
					regcData <= regaData + regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_ANDI: begin
					/* 运算与写回 */
					regcData <= regaData & regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_ORI: begin
					/* 运算与写回 */
					regcData <= regaData | regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_BEQ: begin
					/* 运算与写回 */
					regcData <= {`REG_LENGTH{1'b0}};
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_BNE: begin
					/* 运算与写回 */
					regcData <= {`REG_LENGTH{1'b0}};
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_XORI: begin
					/* 运算与写回 */
					regcData <= regaData ^ regbData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_LUI: begin
					/* 运算与写回 */
					regcData <= regaData << 16;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_J: begin
					/* 运算与写回 */
					regcData <= {`REG_LENGTH{1'b0}};
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				`CMD_JAL: begin
					/* 运算与写回 */
					regcData <= regaData;
					/* 目的寄存器写使能信号 */
					regcWr <= regcWr_i;
					/* 目的寄存器地址 */
					regcAddr <= regcAddr_i;
				end
				default: begin
					/* 输出全零 */
					regcData <= {`REG_LENGTH{1'b0}};
					/* 目的寄存器写使能信号 */
					regcWr <= `DISABLE;
					/* 目的寄存器地址 */
					regcAddr <= {`REG_ADDR_LEN{1'b0}};
				end
			endcase
		end
	end

endmodule
