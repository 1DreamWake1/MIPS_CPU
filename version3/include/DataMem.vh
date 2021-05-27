/**
 * @file	DataMem.vh
 * @author	LiuChuanXi
 * @date	2021.05.27
 * @version	V3.0
 * @brief	DataMem模块的宏定义
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>创建初始版本
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


`endif //__DATAMEM_H
