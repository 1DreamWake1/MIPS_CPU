/**
 * @file	ID.vh
 * @author	LiuChuanXi
 * @date	2021.04.29
 * @version	V1.0
 * @brief	MIPS_CPU指令译码ID模块头文件
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.29	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */

`ifndef __ID_H
`define __ID_H

/**
 * 包含RegFile.vh，使用其中有关寄存器的宏定义
 * //寄存器个数，MIPS默认32个
 * 		`define REG_NUM 32
 * //寄存器地址宽度，默认为5位
 * 		`define REG_ADDR_LEN	5
 * //寄存器位宽，MIPS默认32位 
 * 		`define REG_LENGTH	32
 */
`include "RegFile.vh"


/* 定义指令inst长度 */
`define INST_LENGTH	32

/* 定义指令中OP段的长度 */
`define OP_LENGTH 6

/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif


`endif //__ID_H
