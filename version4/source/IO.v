/**
 * @file	IO.v
 * @author	LiuChuanXi
 * @date	2021.05.31
 * @version	V4.0-1
 * @brief	输入输出IO模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.31	<td>V4.0-1		<td>LiuChuanXi	<td>添加对应的GPIO端口
 * </table>
 */


`include "IO.vh"


/**
 * @author	LiuChuanXi
 * @brief	输入输出IO模块
 * @detail	当前版本有效IO空间为[1024:2047]，其中[1023:0]用于RAM
 * @detail	内部使用寄存器堆的方式记录各个IO端口的状态
 * @note	---IO---
 * @param	clk		input，时钟信号
 * @param	rst		input，复位信号
 * @note	---MIOC---
 * @param	ce		input，IO片选使能信号
 * @param	we		input，IO读写控制信号，为0时进行读操作，为1时进行写操作
 * @param	addr	input，所读/写寄存器的地址
 * @param	wtData	input，写操作的数据输入
 * @param	rdData	output，读出的数据
 * @note	---GPIO---
 * @param	GPIO_CR	output，通用输入输出端口配置，对应0x0000_0400
 * @param	GPIO_OR	output，通用输出端口，对应0x0000_0404
 * @param	GPIO_IR	input，通用输入端口，对应0x0000_0408
 * @warning	会输出addr对应的空间以及后续3个空间的值，共32位
 * @warning addr最低两位必须是00，这里不检查最低两位是否为00
 * @warning 读操作为组合逻辑，写操作为时序逻辑
 * @warning	通过对地址进行掩码运算来取得有效地址(地址重映射)，读取写入数据时不要超出范围
 * @warning	仅添加输入输出，未加控制寄存器GPIO_CR
 */
module IO(
	clk, rst,
	ce, we,
	addr, wtData,
	rdData,
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

	/* private */
	reg[`WIDTH_IO_REG-1:0] io_reg[`DEPTH_IO_REG-1:0];	//IO内部寄存器堆
	reg[`LEN_ADDR_IO-1:0] addrMask;						//保存经过掩码运算(地址重映射)后的地址

	/* GPIO */
	output reg[`LEN_DATA_IO-1:0] GPIO_CR;		//通用输入输出端口配置，对应0x0000_0400
	output reg[`LEN_DATA_IO-1:0] GPIO_OR;		//通用输出端口，对应0x0000_0404
	input wire[`LEN_DATA_IO-1:0] GPIO_IR;		//通用输入端口，对应0x0000_0408


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
				io_reg[addrMask + `LEN_ADDR_IO'h3],
				io_reg[addrMask + `LEN_ADDR_IO'h2],
				io_reg[addrMask + `LEN_ADDR_IO'h1],
				io_reg[addrMask + `LEN_ADDR_IO'h0]
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
			io_reg[addrMask + `LEN_ADDR_IO'h3] <= wtData[31:24];
			io_reg[addrMask + `LEN_ADDR_IO'h2] <= wtData[23:16];
			io_reg[addrMask + `LEN_ADDR_IO'h1] <= wtData[15:8];
			io_reg[addrMask + `LEN_ADDR_IO'h0] <= wtData[7:0];
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
	always@(*) begin
		/* 复位信号rst无效 */
		if(rst == `DISABLE) begin
			/* GPIO_CR */
			GPIO_CR <= {
				io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h3],
				io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h2],
				io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h1],
				io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h0]
			};
			/* GPIO_OR */
			GPIO_OR <= {
				io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h3],
				io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h2],
				io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h1],
				io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h0]
			};
			/* GPIO_IR */
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h3] <= GPIO_IR[31:24];
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h2] <= GPIO_IR[23:16];
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h1] <= GPIO_IR[15:8];
			io_reg[`GPIO_IR_ADDR + `LEN_ADDR_IO'h0] <= GPIO_IR[7:0];
		end
		else begin
			/* 复位信号rst有效 */
			/* GPIO_CR */
			io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h3] <= {`LEN_DATA_IO{1'b0}};
			io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h2] <= {`LEN_DATA_IO{1'b0}};
			io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h1] <= {`LEN_DATA_IO{1'b0}};
			io_reg[`GPIO_CR_ADDR + `LEN_ADDR_IO'h0] <= {`LEN_DATA_IO{1'b0}};
			/* GPIO_OR */
			io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h3] <= {`LEN_DATA_IO{1'b0}};
			io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h2] <= {`LEN_DATA_IO{1'b0}};
			io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h1] <= {`LEN_DATA_IO{1'b0}};
			io_reg[`GPIO_OR_ADDR + `LEN_ADDR_IO'h0] <= {`LEN_DATA_IO{1'b0}};
		end
	end


endmodule
