/**
 * @file	GPIO.v
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V6.0
 * @brief	通用输入输出端口GPIO(GPIO_CR, GPIO_OR, GPIO_IR)
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.06.02	<td>V6.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`include "IO.vh"


/**
 * @author	LiuChuanXi
 * @brief	通用输入输出模块GPIO
 * @note	---GPIO---
 * @param	rst			input，复位信号
 * @note	---IO---
 * @param	GPIO_CR		input，输入输出方向控制寄存器(0为输入，1为输出，默认输入)
 * @param	GPIO_OR		input，从IO来的输出信号(1在对应端口PX输出高电平，0在对应端口输出低电平)
 * @param	GPIO_IR		output，从端口PX读入的电平信号传递给IO模块
 * @note	---SOC---
 * @param	GPIO_IN		input，输入端口
 * @param	GPIO_OUT	output，输出端口
 */
module GPIO(
	rst,
	GPIO_CR, GPIO_OR, GPIO_IR,
	GPIO_IN, GPIO_OUT
);

	/* GPIO */
	input wire rst;								//复位信号

	/* IO */
	input wire[`LEN_DATA_IO-1:0] GPIO_CR;		//输入输出方向控制寄存器(0为输入，1为输出，默认输入)
	input wire[`LEN_DATA_IO-1:0] GPIO_OR;		//从IO来的输出信号(1在对应端口PX输出高电平，0在对应端口输出低电平)
	output wire[`LEN_DATA_IO-1:0] GPIO_IR;		//从端口PX读入的电平信号传递给IO模块

	/* SOC */
	input wire[`LEN_DATA_IO-1:0] GPIO_IN;		//输入端口
	output wire[`LEN_DATA_IO-1:0] GPIO_OUT;		//输出端口


	/* 功能 */
	assign GPIO_OUT = (GPIO_CR & GPIO_OR);
	assign GPIO_IR = (~GPIO_CR & GPIO_IN);


endmodule
