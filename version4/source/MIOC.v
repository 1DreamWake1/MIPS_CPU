/**
 * @file	MIOC.vh
 * @author	LiuChuanXi
 * @date	2021.05.29
 * @version	V4.1
 * @brief	对RAM和IO控制的MIOC模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.29	<td>V4.1		<td>LiuChuanXi	<td>修改读写控制信号xxWr为xxWe
 * </table>
 */


`include "MIOC.vh"


/**
 * @author	LiuChuanXi
 * @brief	对RAM和IO控制的MIOC模块
 * @detail	当前版本有效IO空间为[2047:1024]，有效RAM空间为[1023:0]
 * @detail	使用掩码运算区分操作地址是RAM还是IO
 * @note	---MIOC---
 * @param	rst			input，复位信号
 * @note	---MIPS---
 * @param	memCe		input，MIOC使能信号
 * @param	memWr		input，MIOC读写操作控制(read:`ENABLE, write:`DISABLE)
 * @param	memAddr		input，MIOC地址输入
 * @param	wtData		inout，MIOC写数据输入
 * @param	rdData		output，MIOC数据输出
 * @note	---DataMem(RAM)---
 * @param	ramCe		output，DataMem(RAM)的使能控制信号
 * @param	ramWe		output，DataMem(RAM)的读写操作控制(read:`ENABLE, write:`DISABLE)
 * @param	ramAddr		output，DataMem(RAM)的地址输出
 * @param	ramWtData	output，DataMem(RAM)的数据输出
 * @param	ramRdData	inout，DataMem(RAM)的数据读出
 * @note	---IO(register)---
 * @param	ioCe		output，IO(register)的使能控制信号
 * @param	ioWe		output，IO(register)的读写操作控制(read:`ENABLE, write:`DISABLE)
 * @param	ioAddr		output，IO(register)的地址输出
 * @param	ioWtData	output，IO(register)的数据输出
 * @param	ioRdData	input，IO(register)的数据读入
 */
module MIOC(
	rst,
	memCe, memWr, memAddr, wtData, rdData,
	ramCe, ramWe, ramAddr, ramWtData, ramRdData,
	ioCe, ioWe, ioAddr, ioWtData, ioRdData
);

	/* MIOC */
	input wire rst;								//复位信号

	/* MIPS */
	input wire memCe;							//MIOC使能信号
	input wire memWr;							//MIOC读写操作控制(read:`ENABLE, write:`DISABLE)
	input wire[`LEN_ADDR_MIOC-1:0] memAddr;		//MIOC地址输入
	input wire[`LEN_DATA_MIOC-1:0] wtData;		//MIOC写数据输入
	output reg[`LEN_DATA_MIOC-1:0] rdData;		//MIOC数据输出

	/* DataMem(RAM) */
	output reg ramCe;							//DataMem(RAM)的使能控制信号
	output reg ramWe;							//DataMem(RAM)的读写操作控制(read:`ENABLE, write:`DISABLE)
	output reg[`LEN_ADDR_MIOC-1:0] ramAddr;		//DataMem(RAM)的地址输出
	output reg[`LEN_DATA_MIOC-1:0] ramWtData;	//DataMem(RAM)的数据输出
	input wire[`LEN_DATA_MIOC-1:0] ramRdData;	//DataMem(RAM)的数据读出

	/* IO(register) */
	output reg ioCe;							//IO(register)的使能控制信号
	output reg ioWe;							//IO(register)的读写操作控制(read:`ENABLE, write:`DISABLE)
	output reg[`LEN_ADDR_MIOC-1:0] ioAddr;		//IO(register)的地址输出
	output reg[`LEN_DATA_MIOC-1:0] ioWtData;	//IO(register)的数据输出
	input wire[`LEN_DATA_MIOC-1:0] ioRdData;	//IO(register)的数据读入


	/* MIOC模块初始化 */
	initial begin
		/* MIPS */
		rdData <= {`LEN_DATA_MIOC{1'bz}};
		/* DataMem(RAM) */
		ramCe <= `DISABLE;
		ramWe <= `DISABLE;
		ramAddr <= {`LEN_ADDR_MIOC{1'bz}};
		ramWtData <= {`LEN_DATA_MIOC{1'bz}};
		/* IO(register) */
		ioCe <= `DISABLE;
		ioWe <= `DISABLE;
		ioAddr <= {`LEN_ADDR_MIOC{1'bz}};
		ioWtData <= {`LEN_DATA_MIOC{1'bz}};
	end


	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* MIPS */
			rdData <= {`LEN_DATA_MIOC{1'bz}};
			/* DataMem(RAM) */
			ramCe <= `DISABLE;
			ramWe <= `DISABLE;
			ramAddr <= {`LEN_ADDR_MIOC{1'bz}};
			ramWtData <= {`LEN_DATA_MIOC{1'bz}};
			/* IO(register) */
			ioCe <= `DISABLE;
			ioWe <= `DISABLE;
			ioAddr <= {`LEN_ADDR_MIOC{1'bz}};
			ioWtData <= {`LEN_DATA_MIOC{1'bz}};
		end
	end


	/* DataMem(RAM) */
	always@(*) begin
		if((rst == `DISABLE) && (`MIOC_ADDR_IS_RAM(memAddr))) begin
			/* 复位信号rst无效，且操作地址对应DataMem(RAM) */
			ramCe <= memCe;
			ramWe <= memWr;
			ramAddr <= memAddr;
			ramWtData <= wtData;
			/* 数据输出 */
			rdData <= ramRdData;
		end
		else begin
			/* 其余情况(包括复位)一律按照复位处理 */
			ramCe <= `DISABLE;
			ramWe <= `DISABLE;
			ramAddr <= {`LEN_ADDR_MIOC{1'bz}};
			ramWtData <= {`LEN_DATA_MIOC{1'bz}};
		end
	end


	/* IO(register) */
	always@(*) begin
		if((rst == `DISABLE) && (`MIOC_ADDR_IS_IO(memAddr))) begin
			/* 复位信号rst无效，且操作地址对应DataMem(RAM) */
			ioCe <= memCe;
			ioWe <= memWr;
			ioAddr <= memAddr;
			ioWtData <= wtData;
			/* 数据输出 */
			rdData <= ioRdData;
		end
		else begin
			/* 其余情况(包括复位)一律按照复位处理 */
			ioCe <= `DISABLE;
			ioWe <= `DISABLE;
			ioAddr <= {`LEN_ADDR_MIOC{1'bz}};
			ioWtData <= {`LEN_DATA_MIOC{1'bz}};
		end
	end


endmodule
