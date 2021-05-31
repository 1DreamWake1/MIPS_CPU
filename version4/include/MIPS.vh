/**
 * @file	MIPS.vh
 * @author	LiuChuanXi
 * @date	2021.05.31
 * @version	V4.0-1
 * @brief	MIPS所需宏定义文件
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.25	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * <tr><td>2021.05.28	<td>V3.0		<td>LiuChuanXi	<td>开始version3，增加了对PC初始值(复位值)的宏定义
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>开始version4，增加对空指令nop的支持
 * <tr><td>2021.05.31	<td>V4.0-1		<td>LiuChuanXi	<td>添加下板用寄存器初始化宏
 * </table>
 */


`ifndef __MIPS_H
`define __MIPS_H


/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif


/* IF */
/* PC(程序指针)每次自加多少 */
`define PC_STEP 4
/* PC(程序指针)多少位，应该与InstMem中的地址宽度保持一致(`LEN_ADDR_ROM) */
`define PC_LENGTH	32
/* 定义PC的初始值(复位值) */
`define PC_START ({`PC_LENGTH{1'b0}} - `PC_STEP)
/* PC空地址，即当jCe无效的时候jAddr的数值 */
`define PC_NULL {`PC_LENGTH{1'b0}}

/* RegFile */
/* 寄存器个数，MIPS默认32个 */
`define REG_NUM 32
/* 寄存器地址宽度，默认为5位 */
`define REG_ADDR_LEN	5
/* 寄存器位宽，MIPS默认32位 */
`define REG_LENGTH	32
/* 寄存器初始化宏 */
`define REG_INIT\
	register[0] <= `REG_LENGTH'h0000_0000;\
	register[1] <= `REG_LENGTH'h0000_0000;\
	register[2] <= `REG_LENGTH'h0000_0000;\
	register[3] <= `REG_LENGTH'h0000_0000;\
	register[4] <= `REG_LENGTH'h0000_0000;\
	register[5] <= `REG_LENGTH'h0000_0000;\
	register[6] <= `REG_LENGTH'h0000_0000;\
	register[7] <= `REG_LENGTH'h0000_0000;\
	register[8] <= `REG_LENGTH'h0000_0000;\
	register[9] <= `REG_LENGTH'h0000_0000;\
	register[10] <= `REG_LENGTH'h0000_0000;\
	register[11] <= `REG_LENGTH'h0000_0000;\
	register[12] <= `REG_LENGTH'h0000_0000;\
	register[13] <= `REG_LENGTH'h0000_0000;\
	register[14] <= `REG_LENGTH'h0000_0000;\
	register[15] <= `REG_LENGTH'h0000_0000;\
	register[16] <= `REG_LENGTH'h0000_0000;\
	register[17] <= `REG_LENGTH'h0000_0000;\
	register[18] <= `REG_LENGTH'h0000_0000;\
	register[19] <= `REG_LENGTH'h0000_0000;\
	register[20] <= `REG_LENGTH'h0000_0000;\
	register[21] <= `REG_LENGTH'h0000_0000;\
	register[22] <= `REG_LENGTH'h0000_0000;\
	register[23] <= `REG_LENGTH'h0000_0000;\
	register[24] <= `REG_LENGTH'h0000_0000;\
	register[25] <= `REG_LENGTH'h0000_0000;\
	register[26] <= `REG_LENGTH'h0000_0000;\
	register[27] <= `REG_LENGTH'h0000_0000;\
	register[28] <= `REG_LENGTH'h0000_0000;\
	register[29] <= `REG_LENGTH'h0000_0000;\
	register[30] <= `REG_LENGTH'h0000_0000;\
	register[31] <= `REG_LENGTH'h0000_0000;

/* ID */
/* 定义指令inst长度 */
`define INST_LENGTH	32
/* 定义指令中OP段的长度 */
`define OP_LENGTH 6
/* 定义指令的编码 */
`define CMD_NOP		{`OP_LENGTH{1'b0}}
`define CMD_ADD		(`CMD_NOP + `OP_LENGTH'h01)
`define CMD_SUB		(`CMD_NOP + `OP_LENGTH'h02)
`define CMD_AND		(`CMD_NOP + `OP_LENGTH'h03)
`define CMD_OR		(`CMD_NOP + `OP_LENGTH'h04)
`define CMD_XOR		(`CMD_NOP + `OP_LENGTH'h05)
`define CMD_SLL		(`CMD_NOP + `OP_LENGTH'h06)
`define CMD_SRL		(`CMD_NOP + `OP_LENGTH'h07)
`define CMD_SRA		(`CMD_NOP + `OP_LENGTH'h08)
`define CMD_JR		(`CMD_NOP + `OP_LENGTH'h09)
`define CMD_ADDI	(`CMD_NOP + `OP_LENGTH'h0A)
`define CMD_ANDI	(`CMD_NOP + `OP_LENGTH'h0B)
`define CMD_ORI		(`CMD_NOP + `OP_LENGTH'h0C)
`define CMD_XORI	(`CMD_NOP + `OP_LENGTH'h0D)
`define CMD_LW		(`CMD_NOP + `OP_LENGTH'h0E)
`define CMD_SW		(`CMD_NOP + `OP_LENGTH'h0F)
`define CMD_BEQ		(`CMD_NOP + `OP_LENGTH'h10)
`define CMD_BNE		(`CMD_NOP + `OP_LENGTH'h11)
`define CMD_LUI		(`CMD_NOP + `OP_LENGTH'h12)
`define CMD_J		(`CMD_NOP + `OP_LENGTH'h13)
`define CMD_JAL		(`CMD_NOP + `OP_LENGTH'h14)


`endif //__MIPS_H

