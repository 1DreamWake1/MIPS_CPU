/**
 * @file	InstMem.vh
 * @author	LiuChuanXi
 * @date	2021.05.31
 * @version	V4.0-1
 * @brief	InstMem模块的宏定义
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.13	<td>V1.1		<td>LiuChuanXi	<td>修改输出数据宽度与指令宽度相同
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * <tr><td>2021.05.26	<td>V2.1		<td>LiuChuanXi	<td>修改指令存储器深度为1024
 * <tr><td>2021.05.28	<td>V3.0		<td>LiuChuanXi	<td>version3,添加地址掩码
 * <tr><td>2021.05.31	<td>V4.0-1		<td>LiuChuanXi	<td>添加指令初始化，下板用
 * </table>
 */

`ifndef __INSTMEM_H
`define __INSTMEM_H


/* ROM的长和宽，以及地址位数 */
`define WIDTH_ROM		8		//width of the rom
`define DEPTH_ROM		1024	//depth of the rom
`define LEN_ADDR_ROM	32		//length of the rom address

/* 定义输出数据宽度，与指令宽度(`INST_LENGTH)相同 */
`define LEN_DATA_ROM	32	//length of the inst

/* 定义地址掩码，截取地址中实际有用的低(log2(`DEPTH_ROM)-1)位 */
`define ADDR_MASK_ROM	(`LEN_ADDR_ROM'h0000_03FF)

/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif

/* 定义程序入口地址地址，即第一条指令 */
`define TEXT_ADDR_ROM	(`LEN_ADDR_ROM'h0000_0000)

/* InstMem(ROM)指令初始化宏 */
`define INIT_ROM(a, y3, y2, y1, y0) \
	rom[a + `LEN_ADDR_ROM'h3] <= y0;\
	rom[a + `LEN_ADDR_ROM'h2] <= y1;\
	rom[a + `LEN_ADDR_ROM'h1] <= y2;\
	rom[a + `LEN_ADDR_ROM'h0] <= y3;


`endif // __INSTMEM_H
