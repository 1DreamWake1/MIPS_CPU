/**
 * @file	MEM.v
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V5.1
 * @brief	内存管理模块，用于区分操作寄存器堆还是内存模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>创建初始版本，未增加对lw和sw指令的支持
 * <tr><td>2021.05.27	<td>V3.1		<td>LiuChuanXi	<td>增加对lw和sw指令的支持
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>开始Version4，增加对空指令nop的支持
 * <tr><td>2021.06.02	<td>V5.0		<td>LiuChuanXi	<td>开始version5，更改注释和变量框架
 * <tr><td>2021.06.02	<td>V5.1		<td>LiuChuanXi	<td>添加有关HILO模块内容，未添加有关hilo指令的支持
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	内存管理模块，用于区分操作寄存器堆还是内存模块
 * @note	---MEM---
 * @param	rst			input，复位信号
 * @note	---EX---
 * @param	op			input，指令编码(`CMD_XXX)
 * @param	regcData	input，目的寄存器数据输入
 * @param	regcAddr	input，目的寄存器地址输入
 * @param	regcWr		input，目的寄存器写操作控制信号
 * @param	memAddr_i	input，内存单元地址输入
 * @param	memData_i	input，内存单元数据输入
 * @note	---MIOC---
 * @param	rdData		input，内存单元读取到的数据输入
 * @param	memAddr		output，内存单元地址输出
 * @param	wtData		output，内存单元写数据输出
 * @param	memCe		output，内存单元DataMem模块片选控制信号，只有进行读/写操作时有效
 * @param	memWr		output，内存单元读写控制信号(read:`DISABLE, write:`ENABLE)
 * @note	---RegFile---
 * @param	regWr		output，寄存器写操作控制信号
 * @param	regData		output，寄存器数据输出
 * @param	regAddr		output，寄存器地址输出
 * @note	---HILO---
 * @param	hiWtCe		output，hi寄存器写使能
 * @param	loWtCe		output，lo寄存器写是能
 * @param	hiWtData	output，hi寄存器写入数据
 * @param	loWtData	output，lo寄存器写入数据
 * @warning	内存单元的地址宽度和数据宽度都定义为与寄存器长度相同
 * @warning	当前版本当进行写操作时，写回在下一个始终clk上升沿时写回
 * @warning	内存单元DataMem模块片选控制信号memCe，只有进行读/写操作时有效
 */
module MEM(
	rst, 
	op, regcData, regcAddr, regcWr, memAddr_i, memData_i,
	rdData, memAddr, wtData, memWr, memCe,
	regData, regAddr, regWr,
	hiWtCe, loWtCe, hiWtData, loWtData
);

	/* MEM */
	input wire rst;								//复位信号

	/* EX */
	input wire[`OP_LENGTH-1:0] op;				//指令编码(CMD_XXX)
	input wire[`REG_LENGTH-1:0] regcData;		//目的寄存器数据输入
	input wire[`REG_ADDR_LEN-1:0] regcAddr;		//目的寄存器地址输入
	input wire regcWr;							//目的寄存器写操作控制信号
	input wire[`REG_LENGTH-1:0] memAddr_i;		//内存单元地址输入
	input wire[`REG_LENGTH-1:0] memData_i;		//内存单元数据输入

	/* MIOC */
	input wire[`REG_LENGTH-1:0] rdData;			//内存单元读取到的数据
	output reg[`REG_LENGTH-1:0] memAddr;		//内存单元地址输出
	output reg[`REG_LENGTH-1:0] wtData;			//内存单元写数据输出
	output reg memWr;							//内存单元读写控制信号(read:`DISABLE, write:`ENABLE)
	output reg memCe;							//内存单元DataMem模块片选信号，只有进行读/写操作时有效

	/* RegFile */
	output reg regWr;							//寄存器写控制信号
	output reg[`REG_LENGTH-1:0] regData;		//寄存器数据输出
	output reg[`REG_ADDR_LEN-1:0] regAddr;		//寄存器地址输出

	/* HILO */
	output reg hiWtCe;							//hi寄存器写使能
	output reg loWtCe;							//lo寄存器写是能
	output reg[`REG_LENGTH-1:0] hiWtData;		//hi寄存器写入数据
	output reg[`REG_LENGTH-1:0] loWtData;		//lo寄存器写入数据


	/* 模块初始化 */
	initial begin
		/* 寄存器部分 */
		regData <= {`REG_LENGTH{1'b0}};
		regAddr <= {`REG_LENGTH{1'b0}};
		regWr <= `DISABLE;
		/* 非寄存器模块(RAM或IO) */
		memAddr <= {`REG_LENGTH{1'b0}};
		wtData <= {`REG_LENGTH{1'b0}};
		memWr <= `DISABLE;
		memCe <= `DISABLE;
		/* HILO */
		hiWtCe <= `DISABLE;
		loWtCe <= `DISABLE;
		hiWtData <= {`REG_LENGTH{1'b0}};
		loWtData <= {`REG_LENGTH{1'b0}};
	end


	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* 寄存器部分 */
			regData <= {`REG_LENGTH{1'b0}};
			regAddr <= {`REG_LENGTH{1'b0}};
			regWr <= `DISABLE;
			/* 非寄存器模块(RAM或IO) */
			memAddr <= {`REG_LENGTH{1'b0}};
			wtData <= {`REG_LENGTH{1'b0}};
			memWr <= `DISABLE;
			memCe <= `DISABLE;
			/* HILO */
			hiWtCe <= `DISABLE;
			loWtCe <= `DISABLE;
			hiWtData <= {`REG_LENGTH{1'b0}};
			loWtData <= {`REG_LENGTH{1'b0}};
		end
	end


	/* 模块功能部分 */
	always@(*) begin
		/* 复位信号rst无效 */
		if(rst == `DISABLE) begin
			/* 根据op进行相应的操作 */
			case(op)
			`CMD_ADD: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_ADD: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_SUB: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_AND: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_OR: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_XOR: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_SLL: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_SRL: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_SRA: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_JR: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_ADDI: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_ANDI: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_ORI: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_BEQ: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_BNE: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_XORI: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_LW: begin
				/* 寄存器部分 */
				regData <= rdData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `ENABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_SW: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `ENABLE;
				memCe <= `ENABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_LUI: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_J: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			`CMD_JAL: begin
				/* 寄存器部分 */
				regData <= regcData;
				regAddr <= regcAddr;
				regWr <= regcWr;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= memAddr_i;
				wtData <= memData_i;
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			default: begin
				/* 寄存器部分 */
				regData <= {`REG_LENGTH{1'b0}};
				regAddr <= {`REG_LENGTH{1'b0}};
				regWr <= `DISABLE;
				/* 非寄存器模块(RAM或IO) */
				memAddr <= {`REG_LENGTH{1'b0}};
				wtData <= {`REG_LENGTH{1'b0}};
				memWr <= `DISABLE;
				memCe <= `DISABLE;
				/* HILO */
				hiWtCe <= `DISABLE;
				loWtCe <= `DISABLE;
				hiWtData <= {`REG_LENGTH{1'b0}};
				loWtData <= {`REG_LENGTH{1'b0}};
			end
			endcase
		end
	end


endmodule
