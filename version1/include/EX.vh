/**
 * @file	EX.vh
 * @author	LiuChuanXi
 * @date	2021.05.24
 * @version	V1.0
 * @brief	MIPS_CPU执行模块EX头文件
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.24	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`ifndef __EX_H
`define __EX_H


/**
 * 添加ID模块的头文件，使用部分宏定义
 * 
 * //定义指令中OP段的长度
 * 		`define OP_LENGTH 6
 * //与ID模块使用的指令编码
 * 		`define CMD_XXX
 * 
 * 包含RegFile.vh，使用其中有关寄存器的宏定义
 * //寄存器个数，MIPS默认32个
 * 		`define REG_NUM 32
 * //寄存器地址宽度，默认为5位
 * 		`define REG_ADDR_LEN	5
 * //寄存器位宽，MIPS默认32位 
 * 		`define REG_LENGTH	32
 * 
 */
`include "ID.vh"


/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif


`endif // __EX_H
