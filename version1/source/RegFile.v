/**
 * @file	RegFile.v
 * @author	LiuChuanXi
 * @date	2021.04.28
 * @version	V1.0
 * @brief	MIPS_CPU寄存器堆(RegFile)模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.28	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * </table>
 */


`include "RegFile.vh"


/**
 * @author	LiuChuanXi
 * @brief	RegFile(寄存器堆)模块
 * @param	clk			input，时钟信号
 * @param	rst			input，复位信号，高有效
 * @param	regaAddr	input，寄存器A的地址
 * @param	regbAddr	input，寄存器B的地址
 * @param	regaRd		input，寄存器A的读使能信号
 * @param	regbRd		input，寄存器B的读使能信号
 * @param	we			input，寄存器写回使能信号
 * @param	wAddr		input，写回寄存器地址
 * @param	wData		input，写回寄存器的值
 * @param	regaData	output，寄存器A读出的数据
 * @param	regbData	output，寄存器B读出的数据
 * @warning	没有增加同时对同一个寄存器进行读写的隔离
 */
module RegFile(clk, rst, regaAddr, regaRd, regbAddr, regbRd, we, wAddr, wData, regaData, regbData);

	/* input */
	input wire clk;									//时钟信号
	input wire rst;									//复位信号
	input wire[`REG_ADDR_LEN-1:0] regaAddr;			//寄存器A的地址
	input wire[`REG_ADDR_LEN-1:0] regbAddr;			//寄存器B的地址
	input wire regaRd;								//寄存器A的读使能信号
	input wire regbRd;								//寄存器B的读使能信号
	input wire we;									//寄存器写回使能信号
	input wire[`REG_ADDR_LEN-1:0] wAddr;			//写回寄存器地址
	input wire[`REG_LENGTH-1:0] wData;				//写回寄存器的值
	/* output */
	output reg[`REG_LENGTH-1:0] regaData;			//寄存器A读出的数据
	output reg[`REG_LENGTH-1:0] regbData;			//寄存器B读出的数据
	/* private */
	reg[`REG_LENGTH-1:0] register [`REG_NUM-1:0];	//寄存器register[31:0]

	/* 模块初始化 */
	initial begin

		/* 输出零，等价于输出零号寄存器(register[0])的值 */
		regaData <= {`REG_LENGTH{1'b0}};
		regbData <= {`REG_LENGTH{1'b0}};
		/* 读取RegFile.txt初始化所有寄存器的值 */
		$readmemh("MemFile/RegFile.txt", register);

	end

	/* 功能 */
	always@(posedge clk, rst) begin

		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* 输出零，等价于输出零号寄存器(register[0])的值 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 读取RegFile.txt初始化所有寄存器的值 */
			$readmemh("MemFile/RegFile.txt", register);
		end
		/* 正常工作 */
		else begin
			/* 如果读使能则输出对应寄存器的值，否则输出零号寄存器(register[0])的值 */
			regaData <= regaRd == `ENABLE ? register[regaAddr] : register[0];
			regbData <= regbRd == `ENABLE ? register[regbAddr] : register[0];
			/* 如果写信号we有效，则向目标寄存器写入 */
			if(we == `ENABLE) begin
				/* 警告：如果同时读写同一个寄存器会出现不可预料的错误，后续需要增加隔离操作 */
				register[wAddr] <= wData;
			end
		end

	end


endmodule
