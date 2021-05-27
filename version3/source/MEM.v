/**
 * @file	MEM.v
 * @author	LiuChuanXi
 * @date	2021.05.27
 * @version	V3.0
 * @brief	内存管理模块，用于区分操作寄存器堆还是内存模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	内存管理模块，用于区分操作寄存器堆还是内存模块
 * @param	rst			input，复位信号
 * @param	op			input，指令编码(`CMD_XXX)
 * @param	regcData	input，目的寄存器数据输入
 * @param	regcAddr	input，目的寄存器地址输入
 * @param	regcWr		input，目的寄存器写操作控制信号
 * @param	memAddr_i	input，内存单元地址输入
 * @param	memData		input，内存单元数据输入
 * @param	rdData		input，内存单元读取到的数据输入
 * @param	regData		output，寄存器数据输出
 * @param	regAddr		output，寄存器地址输出
 * @param	regWr		output，寄存器写操作控制信号
 * @param	memAddr		output，内存单元地址输出
 * @param	wtData		output，内存单元写数据输出
 * @param	memWr		output，内存单元读写控制信号(read:`DISABLE, write:`ENABLE)
 * @param	memCe		output，内存单元DataMem模块片选控制信号
 * @warning	内存单元的地址宽度和数据宽度都定义为与寄存器长度相同
 */
module MEM(
	rst, op, regcData, regcAddr, regcWr,
	memAddr_i, memData, rdData,
	regData, regAddr, regWr,
	memAddr, wtData, memWr, memCe
);

	/* input 1 */
	input wire rst;								//复位信号
	input wire[`OP_LENGTH-1:0] op;				//指令编码(CMD_XXX)
	input wire[`REG_LENGTH-1:0] regcData;		//目的寄存器数据输入
	input wire[`REG_ADDR_LEN-1:0] regcAddr;		//目的寄存器地址输入
	input wire regcWr;							//目的寄存器写操作控制信号

	/* input 2 */
	input wire[`REG_LENGTH-1:0] memAddr_i;		//内存单元地址输入
	input wire[`REG_LENGTH-1:0] memData;		//内存单元数据输入
	input wire[`REG_LENGTH-1:0] rdData;			//内存单元读取到的数据

	/* output 1 */
	output reg[`REG_LENGTH-1:0] regData;		//寄存器数据输出
	output reg[`REG_ADDR_LEN-1:0] regAddr;		//寄存器地址输出
	output reg regWr;							//寄存器写控制信号

	/* output 2 */
	output reg[`REG_LENGTH-1:0] memAddr;		//内存单元地址输出
	output reg[`REG_LENGTH-1:0] wtData;			//内存单元写数据输出
	output reg memWr;							//内存单元读写控制信号(read:`DISABLE, write:`ENABLE)
	output reg memCe;							//内存单元DataMem模块片选信号


	/* 模块初始化 */
	initial begin
		/* 寄存器部分 */
		regData <= {`REG_LENGTH{1'b0}};
		regcAddr <= {`REG_LENGTH{1'b0}};
		regWr <= `DISABLE;
		/* DataMem模块 */
		memAddr <= {`REG_LENGTH{1'b0}};
		wtData <= {`REG_LENGTH{1'b0}};
		memWr <= `DISABLE;
		memCe <= `DISABLE;
	end


	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* 寄存器部分 */
			regData <= {`REG_LENGTH{1'b0}};
			regcAddr <= {`REG_LENGTH{1'b0}};
			regWr <= `DISABLE;
			/* DataMem模块 */
			memAddr <= {`REG_LENGTH{1'b0}};
			wtData <= {`REG_LENGTH{1'b0}};
			memWr <= `DISABLE;
			memCe <= `DISABLE;
		end
	end


	/* 模块功能部分 */
	always@(*) begin
		/* 复位信号rst无效 */
		if(rst == `DISABLE) begin
			/* 根据op进行相应的操作 */
		end
	end


endmodule
