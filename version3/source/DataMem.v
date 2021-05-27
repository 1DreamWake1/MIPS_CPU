/**
 * @file	DataMem.v
 * @author	LiuChuanXi
 * @date	2021.05.27
 * @version	V3.0
 * @brief	数据段DataMem模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`include "DataMem.vh"


/**
 * @author	LiuChuanXi
 * @brief	DataMem模块，也就是一块RAM
 * @detail	当前版本有效地址空间为[1023:0]，其中[2047:1024]用于IO映射
 * @param	clk		input，时钟信号
 * @param	ce		input，RAM片选，为1时可读，为0时输出高阻态
 * @param	we		input，RAM读写控制信号，为0时进行读操作，为1时进行写操作
 * @param	wtData	input，写操作的数据输入
 * @param	addr	input，所读/写空间的地址
 * @param	rdData	output，读出的数据
 * @warning	会输出addr对应的空间以及后续3个空间的值，共32位
 * @warning addr最低两位必须是00，这里不检查最低两位是否为00
 * @warning 不进行初始化，如果直接读取会得到不定态
 * @warning 读操作为组合逻辑，写操作为时序逻辑
 */
module DataMem(
	clk,
	ce, we, wtData, addr,
	rdData
);

	/* input */
	input wire clk;							//时钟信号
	input wire ce;							//RAM片选使能信号
	input wire we;							//RAM片选，为1时可读，为0时输出高阻态
	input wire[`LEN_DATA_RAM-1:0] wtData;	//写操作的数据输入
	input wire[`LEN_ADDR_RAM-1:0] addr;		//所读/写空间的地址
	
	/* output */
	output reg[`LEN_DATA_RAM-1:0] rdData;	//所读出的数据

	/* private */
	reg[`WIDTH_RAM-1:0] ram[`DEPTH_RAM-1:0];//RAM实际存储单元


	/* 初始化 */
	initial begin
		/* 读取数据输出为高阻态 */
		rdData <= {`LEN_DATA_RAM{1'bz}};
	end


	/* 读操作，组合逻辑 */
	always@(*) begin
		/* 片选使能信号ce有效(`ENABLE)，读写控制信号we无效(`DISABLE) */
		if((ce == `ENABLE) && (we == `DISABLE)) begin
			/* 警告：这里不检查地址最低两位是否为00 */
			rdData <= ram[addr];
		end
		else begin
			/* 除了进行正常读取操作，其余情况一律输出高阻态 */
			rdData <= {`LEN_DATA_RAM{1'bz}};
		end
	end


	/* 写操作，时序逻辑 */
	always@(posedge clk) begin
		/* 片选信号ce有效(`ENABLE)，读写控制信号we有效(`ENABLE) */
		if((ce == `ENABLE) && (we == `ENABLE)) begin
			/* 警告：这里不检查地址最低两位是否为00 */
			ram[addr] <= wtData;
		end
	end


endmodule
