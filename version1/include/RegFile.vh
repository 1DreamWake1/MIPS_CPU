/**
 * @file	RegFile.vh
 * @author	LiuChuanXi
 * @date	2021.04.28
 * @version	V1.0
 * @brief	MIPS_CPU寄存器堆(RegFile)模块头文件
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`ifndef __REGFILE_H
`define __REGFILE_H


/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1
`define DISABLE	1'b0
`endif

/* 寄存器个数，MIPS默认32个 */
`define REG_NUM 32

/* 寄存器地址宽度，默认为5位 */
`define REG_ADDR_LEN	5

/* 寄存器位宽，MIPS默认32位 */
`define REG_LENGTH	32



`endif // __REGFILE_H
