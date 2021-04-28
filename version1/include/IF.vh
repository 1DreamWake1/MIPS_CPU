/**
 * @file	IF.vh
 * @author	LiuChuanXi
 * @date	2021.04.28
 * @version	V1.0
 * @brief	定义IF(取指令)模块使用的宏
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`ifndef __IF_H
`define __IF_H


/* 包含InstMem模块 */
`include "InstMem.vh"

/* PC(程序指针)每次自加多少 */
`define PC_STEP 4

/* PC(程序指针)多少位，应该与InstMem中的地址宽度保持一致(`LEN_ADDR_ROM) */
`define PC_LENGTH	`LEN_ADDR_ROM

/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif


`endif // __IF_H
