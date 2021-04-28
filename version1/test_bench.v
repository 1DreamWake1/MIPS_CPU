/**
 * @file	test_bench.v
 * @author	LiuChuanXi
 * @date	2021.04.28
 * @version	V1.0
 * @brief	MIPS_CPU顶层测试模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */

`timescale 1ns/1ns

`define LINUX_VERILOG //Verilog in Linux



module test_bench();

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


