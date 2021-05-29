/**
 * @file	InstMem.v
 * @author	LiuChuanXi
 * @date	2021.05.28
 * @version	V3.2
 * @brief	InstMem模块使用ROM
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.13	<td>V1.1		<td>LiuChuanXi	<td>修改输出数据宽度与指令宽度相同
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>修改存储器变量名，改进代码格式
 * <tr><td>2021.05.28	<td>V3.1		<td>LiuChuanXi	<td>添加对地址的掩码运算，取出有效地址
 * <tr><td>2021.05.28	<td>V3.2		<td>LiuChuanXi	<td>将对地址的掩码运算放入独立的always块
 * </table>
 */


`include "InstMem.vh"


/**
 * @author	LiuChuanXi
 * @brief	InstMem模块，也就是一块ROM
 * @param	ce		input，ROM片选，为1时可读，为0时输出高阻态
 * @param	addr	input，所读取空间的地址(源地址,未经过重映射)
 * @param	data	output，读出的数据(经地址重映射对应单元的数据)
 * @warning	会输出addr对应的空间以及后续3个空间的值，共32位
 * @warning	通过对地址进行掩码运算来取得有效地址(地址重映射)，读取数据时不要超出范围
 */
module InstMem(
	ce, addr,
	data
);

	/* input */
	input wire ce;								//ROM片选，为1时可读，为0时输出高阻态
	input wire[`LEN_ADDR_ROM-1:0] addr;			//所读取空间的地址(源地址,未经过重映射)

	/* output */
	output reg[`LEN_DATA_ROM-1:0] data;			//读出的数据(经地址重映射对应单元的数据)

	/* private */
	reg[`WIDTH_ROM-1:0] rom [`DEPTH_ROM-1:0];	//实际存储单元，大小：WIDTH_ROM x DEPTH_ROM
	reg[`LEN_ADDR_ROM-1:0] addrMask;			//保存经过掩码运算(地址重映射)后的地址


	/* 模块初始化 */
	initial begin
		/* 输出高阻态 */
		data = {`LEN_DATA_ROM{1'bz}};
		/* 对地址进行掩码运算结果 */
		addrMask <= {`LEN_ADDR_ROM{1'bz}};
		/* 读取InstMemFile.txt初始化ROM指令存储器 */
		$readmemh("MemFile/InstMemFile.txt", rom);
	end


	/* 功能 */
	always@(*) begin
		/* 当ce有效输出addr对应的数据，否则输出高阻态 */
		if(ce == `ENABLE) begin
			data <= {
				rom[addrMask + `LEN_ADDR_ROM'h0],
				rom[addrMask + `LEN_ADDR_ROM'h1],
				rom[addrMask + `LEN_ADDR_ROM'h2],
				rom[addrMask + `LEN_ADDR_ROM'h3]
			};
		end
		else begin
			data <= {`LEN_DATA_ROM{1'bz}};
		end
	end


	/* 地址掩码运算(地址重映射) */
	always@(*) begin
		/* 片选使能信号ce有效(`ENABLE) */
		if(ce == `ENABLE) begin
		/* 对地址进行掩码运算，得到有效地址(地址重映射) */
			addrMask <= addr & `ADDR_MASK_ROM;
		end
		else begin
			/* 片选信号ce无效时，运算结果为高阻态 */
			addrMask <= {`LEN_ADDR_ROM{1'bz}};
		end
	end

endmodule
