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

/* 定义指令的编码 */
`define CMD_NONE	{`OP_LENGTH{1'b0}}
`define CMD_SUB		(`CMD_NONE + `OP_LENGTH'h01)
`define CMD_AND		(`CMD_NONE + `OP_LENGTH'h02)
`define CMD_OR		(`CMD_NONE + `OP_LENGTH'h03)
`define CMD_XOR		(`CMD_NONE + `OP_LENGTH'h04)
`define CMD_SLL		(`CMD_NONE + `OP_LENGTH'h05)
`define CMD_SRL		(`CMD_NONE + `OP_LENGTH'h06)
`define CMD_SRA		(`CMD_NONE + `OP_LENGTH'h07)
`define CMD_JR		(`CMD_NONE + `OP_LENGTH'h08)
`define CMD_ADDI	(`CMD_NONE + `OP_LENGTH'h09)
`define CMD_ANDI	(`CMD_NONE + `OP_LENGTH'h0A)
`define CMD_ORI		(`CMD_NONE + `OP_LENGTH'h0B)
`define CMD_XORI	(`CMD_NONE + `OP_LENGTH'h0C)
`define CMD_LW		(`CMD_NONE + `OP_LENGTH'h0D)
`define CMD_SW		(`CMD_NONE + `OP_LENGTH'h0E)
`define CMD_BEQ		(`CMD_NONE + `OP_LENGTH'h0F)
`define CMD_BNE		(`CMD_NONE + `OP_LENGTH'h10)
`define CMD_LUI		(`CMD_NONE + `OP_LENGTH'h11)
`define CMD_J		(`CMD_NONE + `OP_LENGTH'h12)
`define CMD_JAL		(`CMD_NONE + `OP_LENGTH'h13)


`endif //__ID_H
