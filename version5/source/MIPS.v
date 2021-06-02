/**
 * @file	MIPS.v
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V5.1
 * @brief	MIPS CPU顶层模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.24	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.25	<td>V1.1		<td>LiuChuanXi	<td>整理包含头文件
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>开始Version3，增加MEM模块
 * <tr><td>2021.05.27	<td>V3.1		<td>LiuChuanXi	<td>增加连线的注释，增加与DataMem的输入输出口
 * <tr><td>2021.05.27	<td>V3.2		<td>LiuChuanXi	<td>内存管理MEM模块添加成功
 * <tr><td>2021.06.02	<td>V5.0		<td>LiuChuanXi	<td>开始version5，更改注释和变量框架
 * <tr><td>2021.06.02	<td>V5.1		<td>LiuChuanXi	<td>添加HILO模块
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	MIPS CPU 顶层模块
 * @note	---MIPS---
 * @param	clk			input，时钟信号
 * @param	rst			input，复位信号，高有效
 * @note	---InstMem(ROM)---
 * @param	inst		input，从指令存储器InstMem(ROM)读入的指令
 * @param	romCe		output，指令存储器InstMem(ROM)的片选使能信号
 * @param	pc			output，程序计数器
 * @note	---MIOC---
 * @param	rdData		input，从DataMem(RAM)读入的数据
 * @param	memAddr		output，访问DataMem(RAM)的地址输出
 * @param	wtData		output，向DataMem(RAM)对应地址写入的数据
 * @param	memWr		output，DataMem(RAM)对应的读写操作控制信号(read:`DISABLE，write:`ENABLE)
 * @param	memCe		output，DataMem(RAM)的片选使能信号
 * @warning	对DataMem(RAM)模块的数据和地址宽度都与寄存器长度相同(32)
 */
module MIPS(
	clk, rst,
	inst, romCe, pc,
	rdData, memAddr, wtData, memWr, memCe
);

	/* MIPS */
	input wire clk;								//时钟信号
	input wire rst;								//复位信号

	/* InstMem(ROM) */
	input wire[`INST_LENGTH-1:0] inst;			//从指令存储器InstMem(ROM)读入的指令
	output wire romCe;							//指令存储器InstMem(ROM)的片选使能信号
	output wire[`PC_LENGTH-1:0] pc;				//程序计数器

	/* MIOC */
	input wire[`REG_LENGTH-1:0] rdData;			//从DataMem(RAM)读入的数据
	output wire[`REG_LENGTH-1:0] memAddr;		//访问DataMem(RAM)的地址输出
	output wire[`REG_LENGTH-1:0] wtData;		//向DataMem(RAM)对应地址写入的数据
	output wire memWr;							//DataMem(RAM)对应的读写操作控制信号(read:`DISABLE，write:`ENABLE)
	output wire memCe;							//DataMem(RAM)的片选使能信号
	
	/* private */
	/* ID RegFile */
	wire[`REG_LENGTH-1:0] regaData_i, regbData_i;		//RegFile->ID，读取到的寄存器数值
	wire[`REG_ADDR_LEN-1:0] regaAddr, regbAddr;			//ID->RegFile，要读取寄存器的地址
	wire regaRd, regbRd;								//ID->RegFile，读取控制信号
	/* ID EX */
	wire[`OP_LENGTH-1:0] op_i;							//ID->EX，指令编码
	wire[`REG_LENGTH-1:0] regaData, regbData;			//ID->EX，两个原操作数
	wire regcWr_i;										//ID->EX，目的寄存器的写使能信号
	wire[`REG_ADDR_LEN-1:0] regcAddr_i;					//ID->EX，目的寄存器的地址
	/* EX MEM */
	wire[`REG_LENGTH-1:0] regcData;						//EX->MEM，目的寄存器的值
	wire[`REG_ADDR_LEN-1:0] regcAddr;					//EX->MEM，目的寄存器的地址
	wire regcWr;										//EX->MEM，目的寄存器的写控制信号
	wire[`OP_LENGTH-1:0] op;							//EX->MEM，指令编码
	wire[`REG_LENGTH-1:0] memAddr_i;					//EX->MEM，传递给MEM的地址
	wire[`REG_LENGTH-1:0] memData_i;					//EX->MEM，传递给MEM的数据
	/* MEM RegFile */
	wire[`REG_LENGTH-1:0] regData;						//MEM->RegFile，目的寄存器的值
	wire[`REG_ADDR_LEN-1:0] regAddr;					//MEM->RegFile，目的寄存器的地址
	wire regWr;											//MEM->RegFile，目的寄存器的写控制信号
	/* IF ID */
	wire[`PC_LENGTH-1:0] jAddr;							//ID->IF，跳转指令跳转目标地址
	wire jCe;											//ID->IF，跳转指令跳转使能信号
	/* HILO ID */
	wire hiRdCe;										//ID->HILO，hi寄存器读使能信号
	wire loRdCe;										//ID->HILO，lo寄存器读使能信号
	wire[`REG_LENGTH-1:0] hiRdData;						//HILO->ID，hi寄存器读出的数据
	wire[`REG_LENGTH-1:0] loRdData;						//HILO->ID，lo寄存器读出的数据
	/* HILO MEM */
	wire hiWtCe;										//MEM->HILO，hi寄存器写使能信号
	wire loWtCe;										//MEM->HILO，lo寄存器写使能信号
	wire[`REG_LENGTH-1:0] hiWtData;						//MEM->HILO，hi寄存器所写的数据
	wire[`REG_LENGTH-1:0] loWtData;						//MEM->HILO，lo寄存器所写的数据


	/* module */
	IF if_m(
		.clk(clk), .rst(rst),
		.jCe(jCe), .jAddr(jAddr),
		.pc(pc), .romCe(romCe)
	);
	ID id_m(
		.rst(rst), .inst(inst), .regaData_i(regaData_i), .regbData_i(regbData_i), .pc(pc),
		.op(op_i), .regaData(regaData), .regbData(regbData), .regcWr(regcWr_i), .regcAddr(regcAddr_i),
		.regaRd(regaRd), .regbRd(regbRd), .regaAddr(regaAddr), .regbAddr(regbAddr),
		.jCe(jCe), .jAddr(jAddr),
		.hiRdCe(hiRdCe), .loRdCe(loRdCe), .hiRdData(hiRdData), .loRdData(loRdData)
	);
	EX ex_m(
		.rst(rst),
		.op_i(op_i), .regaData(regaData), .regbData(regbData), .regcWr_i(regcWr_i), .regcAddr_i(regcAddr_i),
		.regcData(regcData), .regcAddr(regcAddr), .regcWr(regcWr),
		.op(op), .memAddr_i(memAddr_i), .memData_i(memData_i)
	);
	RegFile regfile_m(
		.clk(clk), .rst(rst),
		.regaAddr(regaAddr), .regbAddr(regbAddr), .regaRd(regaRd), .regbRd(regbRd),
		.we(regWr), .wAddr(regAddr), .wData(regData),
		.regaData(regaData_i), .regbData(regbData_i)
	);
	MEM mem_m(
		.rst(rst), .op(op), .regcData(regcData), .regcAddr(regcAddr), .regcWr(regcWr),
		.memAddr_i(memAddr_i), .memData_i(memData_i), .rdData(rdData),
		.regData(regData), .regAddr(regAddr), .regWr(regWr),
		.memAddr(memAddr), .wtData(wtData), .memWr(memWr), .memCe(memCe),
		.hiWtCe(hiWtCe), .loWtCe(loWtCe), .hiWtData(hiWtData), .loWtData(loWtData)
	);
	HILO hilo_m(
		.clk(clk), .rst(rst),
		.hiRdCe(hiRdCe), .loRdCe(loRdCe), .hiRdData(hiRdData), .loRdData(loRdData),
		.hiWtCe(hiWtCe), .loWtCe(loWtCe), .hiWtData(hiWtData), .loWtData(loWtData)
	);


endmodule

