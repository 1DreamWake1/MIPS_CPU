/**
 * @file	SOC.vh
 * @author	LiuChuanXi
 * @date	2021.05.25
 * @version	V1.0
 * @brief	SOC顶层所需宏定义文件
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.25	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`ifndef __SOC_H
`define __SOC_H



/* 包含MIPS CPU模块宏定义 */
`include "MIPS.vh"
/* 包含InstMem指令存储器模块宏定义 */
`include "InstMem.vh"



`endif // __SOC_H
