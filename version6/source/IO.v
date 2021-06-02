/**
 * @file	IO.v
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V6.0
 * @brief	输入输出IO模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.06.02	<td>V6.0		<td>LiuChuanXi	<td>添加GPIO模块
 * </table>
 */


`include "IO.vh"


/**
 * @author	LiuChuanXi
 * @brief	输入输出IO模块
 * @detail	当前版本有效IO空间为[1024:2047]，其中[1023:0]用于RAM
 * @detail	内部使用寄存器堆的方式记录各个IO端口的状态
 * @note	---IO---
 * @param	clk			input，时钟信号
 * @param	rst			input，复位信号
 * @note	---MIOC---
 * @param	ce			input，IO片选使能信号
 * @param	we			input，IO读写控制信号，为0时进行读操作，为1时进行写操作
 * @param	addr		input，所读/写寄存器的地址
 * @param	wtData		input，写操作的数据输入
 * @param	rdData		output，读出的数据
 * @note	---GPIO---
 * @param	GPIO_CR		output，GPIO输入输出方向配置
 * @param	GPIO_OR		output，GPIO输出
 * @param	GPIO_IR		input，GPIO输入
 * @warning	会输出addr对应的空间以及后续3个空间的值，共32位
 * @warning addr最低两位必须是00，这里不检查最低两位是否为00
 * @warning 读操作为组合逻辑，写操作为时序逻辑
 * @warning	通过对地址进行掩码运算来取得有效地址(地址重映射)，读取写入数据时不要超出范围
 */
module IO(
	clk, rst,
	ce, we, addr, wtData, rdData,
	GPIO_CR, GPIO_OR, GPIO_IR
);

	/* IO */
	input wire clk;							//时钟信号
	input wire rst;							//复位信号
	
	/* MIOC */
	input wire ce;							//IO片选使能信号
	inout wire we;							//IO读写控制信号，为0时进行读操作，为1时进行写操作
	input wire[`LEN_ADDR_IO-1:0] addr;		//所读/写寄存器的地址
	input wire[`LEN_DATA_IO-1:0] wtData;	//写操作的数据输入
	output reg[`LEN_DATA_IO-1:0] rdData;	//读出的数据

	/* GPIO */
	output wire[`LEN_DATA_IO-1:0] GPIO_CR;	//GPIO输入输出方向控制
	output wire[`LEN_DATA_IO-1:0] GPIO_OR;	//GPIO输出
	input wire[`LEN_DATA_IO-1:0] GPIO_IR;	//GPIO输入

	/* private */
	reg[`WIDTH_IO_REG-1:0] io_reg[`DEPTH_IO_REG-1:0];	//IO内部寄存器堆
	reg[`LEN_ADDR_IO-1:0] addrMask;						//保存经过掩码运算(地址重映射)后的地址


	/* 初始化 */
	initial begin
		/* 读取数据输出为高阻态 */
		rdData <= {`LEN_DATA_IO{1'bz}};
		/* 地址掩码运算结果 */
		addrMask <= {`LEN_ADDR_IO{1'bz}};
	end


	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* 读取数据输出为高阻态 */
			rdData <= {`LEN_DATA_IO{1'bz}};
			/* 地址掩码运算结果 */
			addrMask <= {`LEN_ADDR_IO{1'bz}};
		end
	end


	/* 读操作，组合逻辑 */
	always@(*) begin
		/* 复位信号rst无效，片选使能信号ce有效(`ENABLE)，读写控制信号we无效(`DISABLE) */
		if((rst == `DISABLE) && (ce == `ENABLE) && (we == `DISABLE)) begin
			/* 警告：这里不检查地址最低两位是否为00 */
			rdData <= {
				io_reg[addrMask + `REG_LENGTH'h3],
				io_reg[addrMask + `REG_LENGTH'h2],
				io_reg[addrMask + `REG_LENGTH'h1],
				io_reg[addrMask + `REG_LENGTH'h0]
			};
		end
		else begin
			/* 除了进行正常读取操作，其余情况一律输出高阻态 */
			rdData <= {`LEN_DATA_IO{1'bz}};
		end
	end


	/* 写操作，时序逻辑 */
	always@(posedge clk) begin
		/* 复位信号rst无效，片选信号ce有效(`ENABLE)，读写控制信号we有效(`ENABLE) */
		if((rst == `DISABLE) && (ce == `ENABLE) && (we == `ENABLE)) begin
			/**
			 * 警告：这里不检查地址最低两位是否为00
			 * 注意：使用小端序存储
			 */
			io_reg[addrMask + `REG_LENGTH'h0] <= wtData[7:0];
			io_reg[addrMask + `REG_LENGTH'h1] <= wtData[15:8];
			io_reg[addrMask + `REG_LENGTH'h2] <= wtData[23:16];
			io_reg[addrMask + `REG_LENGTH'h3] <= wtData[31:24];
		end
	end


	/* 地址掩码运算(地址重映射) */
	always@(*) begin
		/* 复位信号rst无效，片选使能信号ce有效(`ENABLE) */
		if((rst == `DISABLE) && (ce == `ENABLE)) begin
		/* 对地址进行掩码运算，得到有效地址(地址重映射) */
			addrMask <= addr & `ADDR_MASK_IO;
		end
		else begin
			/* 片选信号ce无效时，运算结果为高阻态 */
			addrMask <= {`LEN_ADDR_IO{1'bz}};
		end
	end


	/* GPIO */
	initial begin
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h3] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h2] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h1] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h0] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h3] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h2] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h1] <= `WIDTH_IO_REG'h00;
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h0] <= `WIDTH_IO_REG'h00;
	end
	assign GPIO_CR = {
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h3],
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h2],
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h1],
		io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h0]
	};
	assign GPIO_OR = {
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h3],
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h2],
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h1],
		io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h0]
	};
	always@(posedge clk) begin
		/* 复位信号rst无效，且在时钟信号clk上升沿更新GPIO_IR对应的寄存器 */
		if(rst == `DISABLE) begin
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h3] <= GPIO_IR[31:24];
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h2] <= GPIO_IR[23:16];
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h1] <= GPIO_IR[15:8];
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h0] <= GPIO_IR[7:0];
		end
	end


endmodule
