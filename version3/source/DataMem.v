/**
 * @file	DataMem.v
 * @author	LiuChuanXi
 * @date	2021.05.28
 * @version	V3.3
 * @brief	数据段DataMem模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.27	<td>V3.1		<td>LiuChuanXi	<td>修改存储模式为大端模式
 * <tr><td>2021.05.28	<td>V3.2		<td>LiuChuanXi	<td>添加对地址的掩码运算，取出有效地址
 * <tr><td>2021.05.28	<td>V3.3		<td>LiuChuanXi	<td>将对地址的掩码运算放入独立的always块
 * </table>
 */


`include "DataMem.vh"


/**
 * @author	LiuChuanXi
 * @brief	DataMem模块，也就是一块RAM
 * @detail	当前版本有效地址空间为[1023:0]，其中[2047:1024]用于IO映射
 * @detail	使用大端形式存储，即数据高位存在低地址单元
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
 * @warning	通过对地址进行掩码运算来取得有效地址(地址重映射)，读取写入数据时不要超出范围
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
	reg[`LEN_ADDR_RAM-1:0] addrMask;		//保存经过掩码运算(地址重映射)后的地址


	/* 初始化 */
	initial begin
		/* 读取数据输出为高阻态 */
		rdData <= {`LEN_DATA_RAM{1'bz}};
		/* 地址掩码运算结果 */
		addrMask <= {`LEN_ADDR_RAM{1'bz}};
	end


	/* 读操作，组合逻辑 */
	always@(*) begin
		/* 片选使能信号ce有效(`ENABLE)，读写控制信号we无效(`DISABLE) */
		if((ce == `ENABLE) && (we == `DISABLE)) begin
			/* 警告：这里不检查地址最低两位是否为00 */
			rdData <= {
				ram[addrMask + `REG_LENGTH'h0],
				ram[addrMask + `REG_LENGTH'h1],
				ram[addrMask + `REG_LENGTH'h2],
				ram[addrMask + `REG_LENGTH'h3]
			};
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
			/**
			 * 警告：这里不检查地址最低两位是否为00
			 * 注意：使用大端序存储
			 */
			ram[addrMask + `REG_LENGTH'h0] <= wtData[31:24];
			ram[addrMask + `REG_LENGTH'h1] <= wtData[23:16];
			ram[addrMask + `REG_LENGTH'h2] <= wtData[15:8];
			ram[addrMask + `REG_LENGTH'h3] <= wtData[7:0];
		end
	end

	/* 地址掩码运算(地址重映射) */
	always@(*) begin
		/* 片选使能信号ce有效(`ENABLE) */
		if(ce == `ENABLE) begin
		/* 对地址进行掩码运算，得到有效地址(地址重映射) */
			addrMask <= addr & `ADDR_MASK_RAM;
		end
		else begin
			/* 片选信号ce无效时，运算结果为高阻态 */
			addrMask <= {`LEN_ADDR_RAM{1'bz}};
		end
	end

endmodule
