/**
 * @file	ID.vh
 * @author	LiuChuanXi
 * @date	2021.05.25
 * @version	V1.2
 * @brief	MIPS_CPU指令译码ID模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.29	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.24	<td>V1.1		<td>LiuChuanXi	<td>增加了基础的R型I型指令
 * <tr><td>2021.05.25	<td>V1.2		<td>LiuChuanXi	<td>整理包含头文件
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	ID(译码)模块
 * @param	rst			input，复位信号，高有效
 * @param	inst		input，从InstMem读过来的指令
 * @param	regaData_i	input，寄存器A数据输入
 * @param	regbData_i	input，寄存器B数据输入
 * @param	op			output，指令译码后对应的指令编码(CMD_XXX)
 * @param	regaData	output，寄存器A数据输出
 * @param	regbData	output，寄存器B数据输出
 * @param	regcWr		output，目的寄存器C写控制信号
 * @param	regcAddr	output，目的寄存器C地址
 * @param	regaRd		output，寄存器A读控制信号
 * @param	regbRd		output，寄存器B读控制信号
 * @param	regaAddr	output，寄存器A地址输出
 * @param	regbAddr	output，寄存器B地址输出
 */
module ID(
	rst, inst, regaData_i, regbData_i,
	op, regaData, regbData, regcWr, regcAddr,
	regaRd, regbRd, regaAddr, regbAddr
);

	/* input */
	input wire rst;									//复位信号
	input wire[`INST_LENGTH-1:0] inst;				//输入的指令
	input wire[`REG_LENGTH-1:0] regaData_i;			//寄存器A数据输入
	input wire[`REG_LENGTH-1:0] regbData_i;			//寄存器B数据输入
	/* output 1 */
	output reg[`OP_LENGTH-1:0] op;					//指令译码后对应的指令编码(CMD_XXX)
	output reg[`REG_LENGTH-1:0] regaData;			//寄存器A数据输出
	output reg[`REG_LENGTH-1:0] regbData;			//寄存器B数据输出
	output reg regcWr;								//目的寄存器C写控制信号
	output reg[`REG_ADDR_LEN-1:0] regcAddr;			//目的寄存器C地址
	/* output 2 */
	output reg regaRd;								//寄存器A读控制信号
	output reg regbRd;								//寄存器B读控制信号
	output reg[`REG_ADDR_LEN-1:0] regaAddr;			//寄存器A地址输出
	output reg[`REG_ADDR_LEN-1:0] regbAddr;			//寄存器B地址输出

	/* 模块初始化 */
	initial begin
		/* op段输出空指令CMD_NONE */
		op = `CMD_NONE;
		/* 寄存器读写控制信号关闭 */
		regaRd = `DISABLE;
		regbRd = `DISABLE;
		regcWr = `DISABLE;
		/* 寄存器地址清零 */
		regaAddr = {`REG_ADDR_LEN{1'b0}};
		regbAddr = {`REG_ADDR_LEN{1'b0}};
		regcAddr = {`REG_ADDR_LEN{1'b0}};
	end


	/* 功能 */
	
	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* op段输出空指令CMD_NONE */
			op = `CMD_NONE;
			/* 寄存器读写控制信号关闭 */
			regaRd = `DISABLE;
			regbRd = `DISABLE;
			regcWr = `DISABLE;
			/* 寄存器地址清零 */
			regaAddr = {`REG_ADDR_LEN{1'b0}};
			regbAddr = {`REG_ADDR_LEN{1'b0}};
			regcAddr = {`REG_ADDR_LEN{1'b0}};
		end
	end

	/* 译码功能*/

	/**
	 * instructions		ADD
	 * type				R
	 * detail			rd <- rs + rt
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	5'b00000
	 * inst[5:0]	==	6'b100000
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[10:6] == 5'b00000)
			&& (inst[5:0] == 6'b100000))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_ADD;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
		end
	end

	/**
	 * instructions		SUB
	 * type				R
	 * detail			rd <- rs - rt
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	5'b00000
	 * inst[5:0]	==	6'b100010
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[10:6] == 5'b00000)
			&& (inst[5:0] == 6'b100010))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_SUB;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
		end
	end

	/**
	 * instructions		AND
	 * type				R
	 * detail			rd <- rs and rt
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	5'b00000
	 * inst[5:0]	==	6'b100100
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[10:6] == 5'b00000)
			&& (inst[5:0] == 6'b100100))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_AND;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
		end
	end

	/**
	 * instructions		OR
	 * type				R
	 * detail			rd <- rs or rt
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	5'b00000
	 * inst[5:0]	==	6'b100101
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[10:6] == 5'b00000)
			&& (inst[5:0] == 6'b100101))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_OR;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
		end
	end

	/**
	 * instructions		XOR
	 * type				R
	 * detail			rd <- rs xor rt
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	5'b00000
	 * inst[5:0]	==	6'b100110
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[10:6] == 5'b00000)
			&& (inst[5:0] == 6'b100110))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_XOR;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
		end
	end

	/**
	 * instructions		SLL
	 * type				R
	 * detail			rd <- rt << sa
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	5'b00000
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	sa
	 * inst[5:0]	==	6'b000000
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[25:21] == 5'b00000)
			&& (inst[5:0] == 6'b000000))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_SLL;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regbData_i;
			regbData <= {{27{1'b0}} ,inst[10:6]};
		end
	end

	/**
	 * instructions		SRL
	 * type				R
	 * detail			rd <- rt >> sa
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	5'b00000
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	sa
	 * inst[5:0]	==	6'b000010
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[25:21] == 5'b00000)
			&& (inst[5:0] == 6'b000010))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_SRL;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regbData_i;
			regbData <= {{27{1'b0}} ,inst[10:6]};
		end
	end

	/**
	 * instructions		SRA
	 * type				R
	 * detail			rd <- rt sra sa)
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	5'b00000
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:6] 	==	sa
	 * inst[5:0]	==	6'b000011
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[25:21] == 5'b00000)
			&& (inst[5:0] == 6'b000011))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_SRA;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regbData_i;
			regbData <= {{27{1'b0}}, inst[10:6]};
		end
	end

	/**
	 * instructions		ADDI
	 * type				I
	 * detail			rt <- rs + immediate
	 * inst[31:26]	==	6'b001000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	immediate
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b001000)) begin
			/* op传递CMD操作码 */
			op <= `CMD_ADDI;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{inst[15]}}, inst[15:0]};
		end
	end

	/**
	 * instructions		ANDI
	 * type				I
	 * detail			rt <- rs and immediate
	 * inst[31:26]	==	6'b001100
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	immediate
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b001100)) begin
			/* op传递CMD操作码 */
			op <= `CMD_ANDI;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{1'b0}}, inst[15:0]};
		end
	end

	/**
	 * instructions		ORI
	 * type				I
	 * detail			rt <- rs or immediate
	 * inst[31:26]	==	6'b001101
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	immediate
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b001101)) begin
			/* op传递CMD操作码 */
			op <= `CMD_ORI;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{1'b0}}, inst[15:0]};
		end
	end

	/**
	 * instructions		XORI
	 * type				I
	 * detail			rt <- rs xor immediate
	 * inst[31:26]	==	6'b001110
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	immediate
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b001110)) begin
			/* op传递CMD操作码 */
			op <= `CMD_XORI;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{1'b0}}, inst[15:0]};
		end
	end

	/**
	 * instructions		LUI
	 * type				I
	 * detail			rt <- immediate << 16
	 * inst[31:26]	==	6'b001111
	 * inst[25:21]	==	5'b00000
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	immediate
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b001111)) begin
			/* op传递CMD操作码 */
			op <= `CMD_LUI;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= {{16{1'b0}}, inst[15:0]};
			regbData <= {`REG_LENGTH{1'b0}};
		end
	end



endmodule //module ID
