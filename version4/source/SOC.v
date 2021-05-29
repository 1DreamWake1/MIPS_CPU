/**
 * @file	SOC.v
 * @author	LiuChuanXi
 * @date	2021.05.29
 * @version	V4.0
 * @brief	MIPS CPU顶层SOC
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.25	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>增加DataMem(RAM)模块
 * <tr><td>2021.05.27	<td>V3.1		<td>LiuChuanXi	<td>DataMem(RAM)模块连线成功
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>修改包含关系
 * </table>
 */


`include "SOC.vh"


/**
 * @author	LiuChuanXi
 * @brief	MIPS CPU最顶层SOC模块
 * @param	clk			input，时钟信号
 * @param	rst			input，复位信号
 */
module SOC(
	clk, rst
);

	/* input */
	input wire clk;					//时钟信号
	input wire rst;					//复位信号

	/* output */

	/* private */
	/* MIPS InstMem */
	wire romCe;						//MIPS->InstMem，InstMem(ROM)片选使能信号
	wire[`PC_LENGTH-1:0] pc;		//MIPS->InstMem，程序指针对应InstMem(ROM)的地址
	wire[`INST_LENGTH-1:0] inst;	//InstMem->MIPS，指令
	/* MIPS DataMem */
	wire[`REG_LENGTH-1:0] rdData;	//DataMem->MIPS，从DataMem(RAM)读入的数据
	wire[`REG_LENGTH-1:0] memAddr;	//MIPS->DataMem，访问DataMem(RAM)的地址输出
	wire[`REG_LENGTH-1:0] wtData;	//MIPS->DataMem，向DataMem(RAM)对应地址写入的数据
	wire memWr;						//MIPS->DataMem，DataMem(RAM)对应的读写操作控制信号(read:`DISABLE，write:`ENABLE)
	wire memCe;						//MIPS->DataMem，DataMem(RAM)的片选使能信号


	/* module */
	MIPS mips_m(
		.clk(clk), .rst(rst),
		.inst(inst), .romCe(romCe), .pc(pc),
		.rdData(rdData), .memAddr(memAddr), .wtData(wtData), .memWr(memWr), .memCe(memCe)
	);
	InstMem instmem_m(
		.ce(romCe), .addr(pc), .data(inst)
	);
	DataMem datamem_m(
		.clk(clk),
		.ce(memCe), .we(memWr), .wtData(wtData), .addr(memAddr),
		.rdData(rdData)
	);


endmodule

