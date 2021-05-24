/**
 * @file	ID.vh
 * @author	LiuChuanXi
 * @date	2021.04.29
 * @version	V1.0
 * @brief	MIPS_CPU指令译码ID模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.29	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`include "ID.vh"


/**
 * @author	LiuChuanXi
 * @brief	ID(译码)模块
 * @param	rst			input，复位信号，高有效
 * @param	inst		input，从InstMem读过来的指令
 * @param	regaData_i	input，寄存器A数据输入
 * @param	regbData_i	input，寄存器B数据输入
 * @param	op			output，指令译码后对应的指令编码(CMD_XXX)
 * @param	regaData	output，寄存器A数据输出
 * @param	regbData	output，寄存器B数据输出
 * @param	regcWr		output，目的寄存器C写控制信号
 * @param	regcAddr	output，目的寄存器C地址
 * @param	regaRd		output，寄存器A读控制信号
 * @param	regbRd		output，寄存器B读控制信号
 * @param	regaAddr	output，寄存器A地址输出
 * @param	regbAddr	output，寄存器B地址输出
 */
module ID(
	rst, inst, regaData_i, regbData_i,
	op, regaData, regbData, regcWr, regcAddr,
	regaRd, regbRd, regaAddr, regbAddr
);

	/* input */
	input wire rst;									//复位信号
	input wire[`INST_LENGTH-1:0] inst;				//输入的指令
	input wire[`REG_LENGTH-1:0] regaData_i;			//寄存器A数据输入
	input wire[`REG_LENGTH-1:0] regbData_i;			//寄存器B数据输入
	/* output 1 */
	output reg[`OP_LENGTH-1:0] op;					//指令译码后对应的指令编码(CMD_XXX)
	output wire[`REG_LENGTH-1:0] regaData;			//寄存器A数据输出
	output wire[`REG_LENGTH-1:0] regbData;			//寄存器B数据输出
	output reg regcWr;								//目的寄存器C写控制信号
	output reg[`REG_ADDR_LEN-1:0] regcAddr;			//目的寄存器C地址
	/* output 2 */
	output reg regaRd;								//寄存器A读控制信号
	output reg regbRd;								//寄存器B读控制信号
	output reg[`REG_ADDR_LEN-1:0] regaAddr;			//寄存器A地址输出
	output reg[`REG_ADDR_LEN-1:0] regbAddr;			//寄存器B地址输出

	/* 模块初始化 */
	initial begin

		/* op段输出空指令CMD_NONE */
		op = `CMD_NONE;
		/* 寄存器读写控制信号关闭 */
		regaRd = `DISABLE;
		regbRd = `DISABLE;
		regcWr = `DISABLE;
		/* 寄存器地址清零 */
		regaAddr = {`REG_ADDR_LEN{1'b0}};
		regbAddr = {`REG_ADDR_LEN{1'b0}};
		regcAddr = {`REG_ADDR_LEN{1'b0}};

	end

	/* 功能 */
	/* 数据线直连 */
	assign regaData = regaData_i;
	assign regbData = regbData_i;
	/* 译码 */
	always@(*) begin

		/* 复位信号rst有效 */
		if(ret == `ENABLE) begin
			/* op段输出空指令CMD_NONE */
			op = `CMD_NONE;
			/* 寄存器读写控制信号关闭 */
			regaRd = `DISABLE;
			regbRd = `DISABLE;
			regcWr = `DISABLE;
			/* 寄存器地址清零 */
			regaAddr = {`REG_ADDR_LEN{1'b0}};
			regbAddr = {`REG_ADDR_LEN{1'b0}};
			regcAddr = {`REG_ADDR_LEN{1'b0}};
		end
		

	end

endmodule //module ID
