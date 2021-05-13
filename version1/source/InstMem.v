/**
 * @file	InstMem.v
 * @author	LiuChuanXi
 * @date	2021.04.28
 * @version	V1.0
 * @brief	InstMem模块使用ROM
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.13	<td>V1.1		<td>LiuChuanXi	<td>修改输出数据宽度与指令宽度相同
 * </table>
 */


`include "InstMem.vh"


/**
 * @author	LiuChuanXi
 * @brief	InstMem模块，也就是一块ROM
 * @param	ce		input，ROM片选，为1时可读，为0时输出高阻态
 * @param	addr	input，所读取空间的地址
 * @param	data	output，读出的数据
 * @warning	会输出addr对应的空间以及后续3个空间的值，共32位
 */
module InstMem(ce, addr, data);

	/* input */
	input wire ce;
	input wire[`LEN_ADDR_ROM-1:0] addr;
	/* output */
	output reg[`INST_LENGTH-1:0] data;
	/* private */
	reg[`WIDTH_ROM-1:0] romFile [`DEPTH_ROM-1:0];

	/* 模块初始化 */
	initial begin

		/* 输出高阻态 */
		data = {`INST_LENGTH{1'bz}};
		/* 读取InstMemFile.txt初始化ROM指令存储器 */
		$readmemh("MemFile/InstMemFile.txt", romFile);

	end

	/* 功能 */
	always@(*) begin

		/* 当ce有效输出addr对应的数据，否则输出高阻态 */
		data = ce ? {romFile[addr], romFile[addr + 1], romFile[addr + 2], romFile[addr + 3]} : {`INST_LENGTH{1'bz}};
		
	end

endmodule
