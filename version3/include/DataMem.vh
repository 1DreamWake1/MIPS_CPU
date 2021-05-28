/**
 * @file	DataMem.vh
 * @author	LiuChuanXi
 * @date	2021.05.28
 * @version	V3.1
 * @brief	DataMem模块的宏定义
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.28	<td>V3.1		<td>LiuChuanXi	<td>添加地址掩码
 * </table>
 */


`ifndef __DATAMEM_H
`define __DATAMEM_H


/* RAM的深度和宽度，以及地址位数 */
`define WIDTH_RAM		8		//width of the ram
`define DEPTH_RAM		1024	//depth of the ram
`define LEN_ADDR_RAM	32		//length of the ram address

/* 定义数据输入输出的宽度，与寄存器大小相同 */
`define LEN_DATA_RAM	32		//length of the ram IO data length

/* 定义地址掩码，截取地址中实际有用的低(log2(`DEPTH_RAM)-1)位 */
`define ADDR_MASK_RAM	{{`LEN_ADDR_RAM{1'b0}} + (`DEPTH_RAM - 1)}

/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif


`endif //__DATAMEM_H
