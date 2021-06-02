/**
 * @file	MIOC.vh
 * @author	LiuChuanXi
 * @date	2021.05.29
 * @version	V4.0
 * @brief	对RAM和IO控制的MIOC模块所需宏
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`ifndef __MIOC_H
`define __MIOC_H


/* 定义数据宽度 */
`define LEN_DATA_MIOC	32		//length of the MIOC data

/* 定义地址宽度 */
`define LEN_ADDR_MIOC	32		//length of the MIOC address

/**
 * 定义地址掩码，通过掩码区分RAM和IO
 * warning 	这里因为要兼容QtSpim中数据段地址范围([0x1000_0000-0x1004_0000])
 * 			所以只截取地址的address[11:10]来区分RAM和IO
 */
`define MIOC_ADDR_MASK	(`LEN_ADDR_MIOC'h0000_0C00)

/**
 * DataMem(RAM)
 * Address Start:	0x0000_0000
 * Address End:		0x0000_03FF
 * 通过掩码运算判断当前地址是否是DataMem(RAM)的地址
 */
`define MIOC_ADDR_RAM	(`LEN_ADDR_MIOC'h0000_0000)
`define MIOC_ADDR_IS_RAM(address)	((address & `MIOC_ADDR_MASK) == `MIOC_ADDR_RAM)

/**
 * IO(register)
 * Address Start:	0x0000_0400
 * Address End:		0x0000_07FF
 * 通过掩码运算判断当前地址是否是IO(register)的地址
 */
`define MIOC_ADDR_IO	(`LEN_ADDR_MIOC'h0000_0400)
`define MIOC_ADDR_IS_IO(address)	((address & `MIOC_ADDR_MASK) == `MIOC_ADDR_IO)

/* 定义使能ENABLE和关闭DISABLE */
`ifndef ENABLE
`define ENABLE	1'b1	//使能
`define DISABLE	1'b0	//关闭
`endif


`endif //__MIOC_H
