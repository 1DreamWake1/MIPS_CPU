/**
 * @file	ID.vh
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V5.2
 * @brief	MIPS_CPU指令译码ID模块
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.04.29	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.24	<td>V1.1		<td>LiuChuanXi	<td>增加了基础的R型I型指令
 * <tr><td>2021.05.25	<td>V1.2		<td>LiuChuanXi	<td>整理包含头文件
 * <tr><td>2021.05.25	<td>V1.3		<td>LiuChuanXi	<td>修改指令译码的bug
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始version2
 * <tr><td>2021.05.26	<td>V2.1		<td>LiuChuanXi	<td>增加对J型指令的支持
 * <tr><td>2021.05.26	<td>V2.2		<td>LiuChuanXi	<td>J型指令完成，version2完成
 * <tr><td>2021.05.27	<td>V3.0		<td>LiuChuanXi	<td>开始version3,增加对lw和sw指令的支持
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>开始version4，增加对空指令nop的支持
 * <tr><td>2021.06.02	<td>V5.0		<td>LiuChuanXi	<td>开始version5，更改注释和变量框架
 * <tr><td>2021.06.02	<td>V5.1		<td>LiuChuanXi	<td>添加有关HILO模块内容，未添加有关hilo指令的支持
 * <tr><td>2021.06.02	<td>V5.2		<td>LiuChuanXi	<td>添加有关hilo指令的支持
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	ID(译码)模块
 * @note	---ID---
 * @param	rst			input，复位信号，高有效
 * @note	---IF---
 * @param	pc			input，跳转指令功能，当前的PC
 * @param	jAddr		output，跳转指令功能，跳转地址
 * @param	jCe			output，跳转指令功能，跳转使能信号
 * @note	---InstMem(ROM)---
 * @param	inst		input，从InstMem读过来的指令
 * @note	---RegFile---
 * @param	regaRd		output，寄存器A读控制信号
 * @param	regbRd		output，寄存器B读控制信号
 * @param	regaAddr	output，寄存器A地址输出
 * @param	regbAddr	output，寄存器B地址输出
 * @param	regaData_i	input，寄存器A数据输入
 * @param	regbData_i	input，寄存器B数据输入
 * @note	---EX---
 * @param	op			output，指令译码后对应的指令编码(CMD_XXX)
 * @param	regaData	output，寄存器A数据输出
 * @param	regbData	output，寄存器B数据输出
 * @param	regcWr		output，目的寄存器C写控制信号
 * @param	regcAddr	output，目的寄存器C地址
 * @note	---HILO---
 * @param	hiRdCe		output，hi寄存器读使能信号
 * @param	loRdCe		output，lo寄存器读使能信号
 * @param	hiRdData	input，hi寄存器读出的数据
 * @param	loRdData	input，lo寄存器读出的数据
 */
module ID(
	rst,
	pc, jAddr, jCe,
	inst,
	regaRd, regbRd, regaAddr, regbAddr, regaData_i, regbData_i,
	op, regaData, regbData, regcWr, regcAddr,
	hiRdCe, loRdCe, hiRdData, loRdData
);

	/* ID */
	input wire rst;									//复位信号

	/* IF */
	input wire[`PC_LENGTH-1:0] pc;					//跳转指令功能，当前的PC
	output reg[`PC_LENGTH-1:0] jAddr;				//跳转指令功能，跳转地址
	output reg jCe;									//跳转指令功能，跳转使能信号

	/* InstMem(ROM) */
	input wire[`INST_LENGTH-1:0] inst;				//输入的指令

	/* RegFile */
	output reg regaRd;								//寄存器A读控制信号
	output reg regbRd;								//寄存器B读控制信号
	output reg[`REG_ADDR_LEN-1:0] regaAddr;			//寄存器A地址输出
	output reg[`REG_ADDR_LEN-1:0] regbAddr;			//寄存器B地址输出
	input wire[`REG_LENGTH-1:0] regaData_i;			//寄存器A数据输入
	input wire[`REG_LENGTH-1:0] regbData_i;			//寄存器B数据输入
	
	/* EX */
	output reg[`OP_LENGTH-1:0] op;					//指令译码后对应的指令编码(CMD_XXX)
	output reg[`REG_LENGTH-1:0] regaData;			//寄存器A数据输出
	output reg[`REG_LENGTH-1:0] regbData;			//寄存器B数据输出
	output reg regcWr;								//目的寄存器C写控制信号
	output reg[`REG_ADDR_LEN-1:0] regcAddr;			//目的寄存器C地址

	/* HILO */
	output reg hiRdCe;								//hi寄存器读使能信
	output reg loRdCe;								//lo寄存器读使能信
	input wire[`REG_LENGTH-1:0] hiRdData;			//hi寄存器读出的数据
	input wire[`REG_LENGTH-1:0] loRdData;			//lo寄存器读出的数据


	/* 模块初始化 */
	initial begin
		/* op段输出空指令CMD_NONE */
		op <= `CMD_NOP;
		/* 寄存器读写控制信号关闭 */
		regaRd <= `DISABLE;
		regbRd <= `DISABLE;
		regcWr <= `DISABLE;
		/* 寄存器地址清零 */
		regaAddr <= {`REG_ADDR_LEN{1'b0}};
		regbAddr <= {`REG_ADDR_LEN{1'b0}};
		regcAddr <= {`REG_ADDR_LEN{1'b0}};
		/* 跳转指令功能关闭 */
		jAddr <= `PC_NULL;
		jCe <= `DISABLE;
		/*HILO*/
		hiRdCe <= `DISABLE;
		loRdCe <= `DISABLE;
	end


	/* 功能 */
	
	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* op段输出空指令CMD_NONE */
			op <= `CMD_NOP;
			/* 寄存器读写控制信号关闭 */
			regaRd <= `DISABLE;
			regbRd <= `DISABLE;
			regcWr <= `DISABLE;
			/* 寄存器地址清零 */
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end


	/* 译码功能*/

	/**
	 * instructions		NOP
	 * type				NOP
	 * detail			To perform no operation
	 * inst[31:0]	==	32'h0000_0000
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst == `INST_LENGTH'h0000_0000))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_NOP;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

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
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regaRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{27{1'b0}}, inst[10:6]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regaRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{27{1'b0}} ,inst[10:6]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regaRd <= `ENABLE;
			regaAddr <= inst[20:16];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{27{1'b0}}, inst[10:6]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		JR
	 * type				R(J)
	 * detail			pc <- rs
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	5'b00000
	 * inst[15:11]	==	5'b00000
	 * inst[10:6] 	==	5'b00000
	 * inst[5:0]	==	6'b001000
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[20:16] == 5'b00000)
			&& (inst[15:11] == 5'b00000) && (inst[10:6] == 5'b00000) && (inst[5:0] == 6'b001000))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_JR;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			/* 注意：这里直接将从寄存器取来的地址最低两位变成2'b00 */
			jAddr <= {regaData_i[`PC_LENGTH-1:2], 2'b00};
			jCe <= `ENABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{inst[15]}}, inst[15:0]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{1'b0}}, inst[15:0]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{1'b0}}, inst[15:0]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= {{16{1'b0}}, inst[15:0]};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		LW
	 * type				I(load)
	 * detail			rt <- memory[rs + sign_extend(offset)]
	 * inst[31:26]	==	6'b100011
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	offset
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b100011)) begin
			/* op传递CMD操作码 */
			op <= `CMD_LW;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/**
			 * 寄存器a和b数据输出
			 * 注意：这里直接将要读取的RAM地址最低两位置成2'b00
			 * regaData传递的是要load的RAM的地址
			 * regcAddr为写回到的寄存器的地址(号)
			 */
			regaData <= ((regaData_i + {{16{inst[15]}}, inst[15:0]}) & ({`REG_LENGTH{1'b1}}<<2));
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		SW
	 * type				I(store)
	 * detail			memory[rs + sign_extend(offset)] <- rt
	 * inst[31:26]	==	6'b101011
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	offset
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b101011)) begin
			/* op传递CMD操作码 */
			op <= `CMD_SW;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/**
			 * 寄存器a和b数据输出
			 * 注意：这里直接将要写入的RAM地址最低两位置成2'b00
			 * regaData传递的是要store的RAM的地址
			 * regbData传递的是要写入的值
			 * regcAddr为写回到的寄存器的地址(号)
			 */
			regaData <= ((regaData_i + {{16{inst[15]}}, inst[15:0]}) & ({`REG_LENGTH{1'b1}}<<2));
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		BEQ
	 * type				I(J)
	 * detail			if(rs == rt) pc <- pc + sign_extend({offset, 2'b00})
	 * inst[31:26]	==	6'b000100
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	offset
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000100)) begin
			/* op传递CMD操作码 */
			op <= `CMD_BEQ;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= (regaData_i == regbData_i) ? (pc + {{14{inst[15]}}, inst[15:0], 2'b00}) : `PC_NULL;
			jCe <= (regaData_i == regbData_i) ? `ENABLE : `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		BNE
	 * type				I(J)
	 * detail			if(rs != rt) pc <- pc + sign_extend({offset, 2'b00})
	 * inst[31:26]	==	6'b000101
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	offset
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000101)) begin
			/* op传递CMD操作码 */
			op <= `CMD_BNE;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= (regaData_i != regbData_i) ? (pc + {{14{inst[15]}}, inst[15:0], 2'b00}) : `PC_NULL;
			jCe <= (regaData_i != regbData_i) ? `ENABLE : `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
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
		if((rst == `DISABLE) && (inst[31:26] == 6'b001111) && (inst[25:21] == 5'b00000))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_LUI;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[20:16];
			/* 寄存器a和b数据输出 */
			regaData <= {{16{1'b0}}, inst[15:0]};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		J
	 * type				J
	 * detail			pc <- {pc[pc_len-1:28], address, 2'b00}
	 * inst[31:26]	==	6'b000010
	 * inst[25:0]	==	address
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000010)) begin
			/* op传递CMD操作码 */
			op <= `CMD_J;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= {pc[`PC_LENGTH-1:28], inst[25:0], 2'b00};
			jCe <= `ENABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		JAL
	 * type				J
	 * detail			1. reg[31] <- pc + 4(`PC_STEP)
	 * detail			2. pc <- {pc[pc_len-1:28], address, 2'b00}
	 * inst[31:26]	==	6'b000011
	 * inst[25:0]	==	address
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000011)) begin
			/* op传递CMD操作码 */
			op <= `CMD_JAL;
			/* a读使能信号，与地址 */
			regaRd <= `DISABLE;
			regaAddr <= {`REG_ADDR_LEN{1'b0}};
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= `REG_ADDR_LEN'h1F;
			/* 寄存器a和b数据输出 */
			/* 注意：非流水线下存当前jal指令的下一条指令的地址，即pc+4(`PC_STEP) */
			regaData <= pc + `PC_STEP;
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= {pc[`PC_LENGTH-1:28], inst[25:0], 2'b00};
			jCe <= `ENABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		SLT
	 * type				R
	 * detail			rd <- (rs < rt)
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:11]	==	rd
	 * inst[10:0]	==	11'b000_0010_1010
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[10:0] == 11'b000_0010_1010))
		begin
			/* op传递CMD操作码 */
			op <= `CMD_SLT;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		BGTZ
	 * type				J
	 * detail			if(rs > 0) then branch
	 * inst[31:26]	==	6'b000111
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	5'b00000
	 * inst[15:0]	==	offset
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000111) && (inst[20:16] == 5'b00000)) begin
			/* op传递CMD操作码 */
			op <= `CMD_BGTZ;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= {pc + {{14{inst[15]}}, inst[16:0], 2'b00}};
			jCe <= ((regaData_i[`REG_LENGTH-1] == 1'b0) && (regaData_i != {`REG_LENGTH{1'b0}})) ? `ENABLE : `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		BLTZ
	 * type				J
	 * detail			if(rs < 0) then branch
	 * inst[31:26]	==	6'b000001
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	5'b00000
	 * inst[15:0]	==	offset
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000001) && (inst[20:16] == 5'b00000)) begin
			/* op传递CMD操作码 */
			op <= `CMD_BLTZ;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= {`REG_LENGTH{1'b0}};
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= {pc + {{14{inst[15]}}, inst[16:0], 2'b00}};
			jCe <= ((regaData_i[`REG_LENGTH-1] == 1'b1) && (regaData_i != {`REG_LENGTH{1'b0}})) ? `ENABLE : `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		JALR
	 * type				J
	 * detail			1. rd(reg[31]) <- pc + 4(`PC_STEP)
	 * detail			2. pc <- rs
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	5'b00000
	 * inst[15:11]	==	rd
	 * inst[10:6]	==	hint
	 * inst[5:0]	==	6'b001001
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[20:16] == 5'b00000) && (inst[5:0] == 6'b001001)) begin
			/* op传递CMD操作码 */
			op <= `CMD_JALR;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `DISABLE;
			regbAddr <= {`REG_ADDR_LEN{1'b0}};
			/* c写使能信号，与地址 */
			regcWr <= `ENABLE;
			regcAddr <= inst[15:11];
			/* 寄存器a和b数据输出 */
			/* 注意：非流水线下存当前jal指令的下一条指令的地址，即pc+4(`PC_STEP) */
			regaData <= pc + `PC_STEP;
			regbData <= {`REG_LENGTH{1'b0}};
			/* 跳转指令功能 */
			jAddr <= {regaData_i[`REG_LENGTH-1:2], 2'b00};
			jCe <= `ENABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		MULT
	 * type				hilo
	 * detail			{hi, lo} <- signed(rs x rt)
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	16'b0000_0000_0001_1000
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[15:0] == 16'b0000_0000_0001_1000)) begin
			/* op传递CMD操作码 */
			op <= `CMD_MULT;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end

	/**
	 * instructions		MULTU
	 * type				hilo
	 * detail			{hi, lo} <- unsigned(rs x rt)
	 * inst[31:26]	==	6'b000000
	 * inst[25:21]	==	rs
	 * inst[20:16]	==	rt
	 * inst[15:0]	==	16'b0000_0000_0001_1001
	 */
	always@(*) begin
		/* 复位信号rst无效 */
		if((rst == `DISABLE) && (inst[31:26] == 6'b000000) && (inst[15:0] == 16'b0000_0000_0001_1001)) begin
			/* op传递CMD操作码 */
			op <= `CMD_MULTU;
			/* a读使能信号，与地址 */
			regaRd <= `ENABLE;
			regaAddr <= inst[25:21];
			/* b读使能信号，与地址 */
			regbRd <= `ENABLE;
			regbAddr <= inst[20:16];
			/* c写使能信号，与地址 */
			regcWr <= `DISABLE;
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			/* 寄存器a和b数据输出 */
			regaData <= regaData_i;
			regbData <= regbData_i;
			/* 跳转指令功能 */
			jAddr <= `PC_NULL;
			jCe <= `DISABLE;
			/*HILO*/
			hiRdCe <= `DISABLE;
			loRdCe <= `DISABLE;
		end
	end


endmodule //module ID
