/**
 * @file	SOC.v
 * @author	LiuChuanXi
 * @date	2021.05.29
 * @version	V4.1
 * @brief	MIPS CPU顶层SOC
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.25	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>增加DataMem(RAM)模块
 * <tr><td>2021.05.27	<td>V3.1		<td>LiuChuanXi	<td>DataMem(RAM)模块连线成功
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>修改包含关系
 * <tr><td>2021.05.29	<td>V4.1		<td>LiuChuanXi	<td>添加RAM和IO访问控制模块MIOC
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
	input wire clk;						//时钟信号
	input wire rst;						//复位信号

	/* output */

	/* private */
	/* MIPS InstMem */
	wire romCe;							//MIPS->InstMem，InstMem(ROM)片选使能信号
	wire[`PC_LENGTH-1:0] pc;			//MIPS->InstMem，程序指针对应InstMem(ROM)的地址
	wire[`INST_LENGTH-1:0] inst;		//InstMem->MIPS，指令
	/* MIPS MIOC */
	wire memCe;							//MIPS->MIOC，MIOC的片选使能信号
	wire memWr;							//MIPS->MIOC，MIOC对应的读写操作控制信号(read:`DISABLE，write:`ENABLE)
	wire[`REG_LENGTH-1:0] memAddr;		//MIPS->MIOC，访问MIOC的地址输出
	wire[`REG_LENGTH-1:0] wtData;		//MIPS->MIOC，向MIOC对应地址写入的数据
	wire[`REG_LENGTH-1:0] rdData;		//MIOC->MIPS，从MIOC读入的数据
	/* MIOC DataMem(RAM) */
	wire ramCe;							//MIOC->DataMem(RAM)，DataMem(RAM)的使能控制信号
	wire ramWe;							//MIOC->DataMem(RAM)，DataMem(RAM)的读写操作控制(read:`ENABLE, write:`DISABLE)
	wire[`REG_LENGTH-1:0] ramAddr;		//MIOC->DataMem(RAM)，DataMem(RAM)的地址输出
	wire[`REG_LENGTH-1:0] ramWtData;	//MIOC->DataMem(RAM)，DataMem(RAM)的数据输出
	wire[`REG_LENGTH-1:0] ramRdData;	//DataMem(RAM)->MIOC，DataMem(RAM)的数据读出
	/* MIOC IO(register) */
	wire ioCe;							//MIOC->IO(register)，IO(register)的使能控制信号
	wire ioWe;							//MIOC->IO(register)，IO(register)的读写操作控制(read:`ENABLE, write:`DISABLE)
	wire[`REG_LENGTH-1:0] ioAddr;		//MIOC->IO(register)，IO(register)的地址输出
	wire[`REG_LENGTH-1:0] ioWtData;		//MIOC->IO(register)，IO(register)的数据输出
	wire[`REG_LENGTH-1:0] ioRdData;		//IO(register)->MIOC，IO(register)的数据读出


	/* module */
	MIPS mips_m(
		.clk(clk), .rst(rst),
		.inst(inst), .romCe(romCe), .pc(pc),
		.rdData(rdData), .memAddr(memAddr), .wtData(wtData), .memWr(memWr), .memCe(memCe)
	);
	InstMem instmem_m(
		.ce(romCe), .addr(pc), .data(inst)
	);
	MIOC mioc_m(
		.rst(rst),
		.memCe(memCe), .memWr(memWr), .memAddr(memAddr), .wtData(wtData), .rdData(rdData),
		.ramCe(ramCe), .ramWe(ramWe), .ramAddr(ramAddr), .ramWtData(ramWtData), .ramRdData(ramRdData),
		.ioCe(ioCe), .ioWe(ioWe), .ioAddr(ioAddr), .ioWtData(ioWtData), .ioRdData(ioRdData)
	);
	DataMem datamem_m(
		.clk(clk),
		.ce(ramCe), .we(ramWe), .wtData(ramWtData), .addr(ramAddr),
		.rdData(ramRdData)
	);
	IO io_m(
		.clk(clk), .rst(rst),
		.ce(ioCe), .we(ioWe), .wtData(ioWtData), .addr(ioAddr),
		.rdData(ioRdData)
	);


endmodule

