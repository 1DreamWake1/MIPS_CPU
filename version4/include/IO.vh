/**
 * @file	IO.vh
 * @author	LiuChuanXi
 * @date	2021.05.31
 * @version	V4.0-1
 * @brief	输入输出IO模块的宏定义
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.31	<td>V4.0-1		<td>LiuChuanXi	<td>添加有关GPIO的地址映射
 * </table>
 */


`ifndef __IO_H
`define __IO_H


/* 定义IO寄存器的深度和宽度 */
`define WIDTH_IO_REG	8		//width of the IO register
`define DEPTH_IO_REG	1024	//depth of the IO register

/* 定义地址位数 */
`define LEN_ADDR_IO		32		//length of the IO register address

/* 定义数据输入输出的宽度，与寄存器大小相同 */
`define LEN_DATA_IO		32		//length of the IO data length

/* 定义地址掩码，截取地址中实际有用的低(log2(`DEPTH_RAM)-1)位 */
`define ADDR_MASK_IO	`LEN_ADDR_IO'h0000_03FF

/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif

/* IO Device Address */
/* GPIO */
`define GPIO_CR_ADDR	(`LEN_ADDR_IO'h0000_0000)	//GPIO输入/输出配置寄存器
`define GPIO_OR_ADDR	(`LEN_ADDR_IO'h0000_0004)	//GPIO输出寄存器
`define GPIO_IR_ADDR	(`LEN_ADDR_IO'h0000_0008)	//GPIO输入寄存器


`endif //__IO_H
