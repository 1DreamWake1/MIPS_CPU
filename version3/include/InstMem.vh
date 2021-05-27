/**
 * @file	InstMem.vh
 * @author	LiuChuanXi
 * @date	2021.05.26
 * @version	V2.1
 * @brief	InstMem模块的宏定义
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.13	<td>V1.1		<td>LiuChuanXi	<td>修改输出数据宽度与指令宽度相同
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * <tr><td>2021.05.26	<td>V2.1		<td>LiuChuanXi	<td>修改指令存储器深度为1024
 * </table>
 */

`ifndef __INSTMEM_H
`define __INSTMEM_H

/* ROM的长和宽，以及地址位数 */
`define WIDTH_ROM		8		//width of the rom
`define DEPTH_ROM		1024	//depth of the rom
`define LEN_ADDR_ROM	32		//length of the rom address

/* 定义输出数据宽度，与指令宽度相同 */
`ifndef INST_LENGTH
`define INST_LENGTH		32		//length of the inst
`endif

/* 定义一次取输出的数据为几个字节，与PC每次自增的大小相等 */
`ifndef PC_STEP
`define PC_STEP			4		//step of the PC
`endif

`endif // __INSTMEM_H
