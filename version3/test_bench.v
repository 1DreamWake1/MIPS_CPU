/* 2021 04/28/21 12:16:29 */

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


