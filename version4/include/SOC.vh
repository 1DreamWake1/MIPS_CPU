/**
 * @file	SOC.vh
 * @author	LiuChuanXi
 * @date	2021.05.29
 * @version	V4.1
 * @brief	SOC顶层所需宏定义文件
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.25	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>修改包含关系
 * <tr><td>2021.05.29	<td>V4.1		<td>LiuChuanXi	<td>添加输入输出IO模块
 * </table>
 */


`ifndef __SOC_H
`define __SOC_H



/* MIPS CPU CORE */
`include "MIPS.vh"

/* InstMem(ROM)*/
`include "InstMem.vh"

/* DataMem(RAM) */
`include "DataMem.vh"

/* IO(input and output) */
`include "IO.vh"


`endif // __SOC_H
