/**
 * @file	test_bench.v
 * @author	LiuChuanXi
 * @date	2021.05.25
 * @version	V1.1
 * @brief	MIPS_CPU顶层测试模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
  * <tr><td>2021.05.25	<td>V1.1		<td>LiuChuanXi	<td>整理包含头文件
 * </table>
 */

`timescale 1ns/1ns

`define LINUX_VERILOG //Verilog in Linux


/* 包含SOC顶层 */
`include "SOC.vh"


module test_bench();

	/* private */
	reg clk;
	reg rst;


	/* module */
	SOC soc_m(
		.clk(clk), .rst(rst)
	);


	/* 测试模块 */
	initial begin
		#0	clk = 1'b0;
			rst = `ENABLE;
		#30	rst = `DISABLE;

	end


	/* 产生时钟信号clk */
	always begin
		#5 clk = ~clk;
	end


	/* Linux下测试模块 */
`ifdef LINUX_VERILOG
	initial begin

		$dumpfile("./build/wave.vcd");
		$dumpvars(0, test_bench);

		#1000
			$stop(2);

	end
`endif //LINUX_VERIOLG

endmodule


