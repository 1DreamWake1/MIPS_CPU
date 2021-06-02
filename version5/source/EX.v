/**
 * @file	EX.v
 * @author	LiuChuanXi
 * @date	2021.06.02
 * @version	V5.0
 * @brief	MIPS_CPU执行模块EX
 * @par	修改日志
 * <table>
 * <tr><th>Date			<th>Version		<th>Author		<th>Description
 * <tr><td>2021.05.24	<td>V1.0		<td>LiuChuanXi	<td>创建初始版本
 * <tr><td>2021.05.25	<td>V1.1		<td>LiuChuanXi	<td>整理包含头文件
 * <tr><td>2021.05.26	<td>V2.0		<td>LiuChuanXi	<td>开始Version2
 * <tr><td>2021.05.26	<td>V2.1		<td>LiuChuanXi	<td>增加对J型指令的支持
 * <tr><td>2021.05.26	<td>V2.2		<td>LiuChuanXi	<td>J型指令完成，version2完成
 * <tr><td>2021.05.26	<td>V3.0		<td>LiuChuanXi	<td>version3开始，增加与MEM间的三根线
 * <tr><td>2021.05.26	<td>V3.1		<td>LiuChuanXi	<td>修改与MEM模块端口的名称加上"_i"
 * <tr><td>2021.05.29	<td>V4.0		<td>LiuChuanXi	<td>开始Version4，增加对空指令nop的支持
 * <tr><td>2021.06.02	<td>V5.0		<td>LiuChuanXi	<td>开始version5，添加有关hilo指令的支持
 * </table>
 */


`include "MIPS.vh"


/**
 * @author	LiuChuanXi
 * @brief	EX(执行)模块
 * @param	rst			input，复位信号，高有效
 * @param	op_i		input，指令译码后对应的指令编码(CMD_XXX)
 * @param	regaData	input，寄存器A数据输入
 * @param	regbData	input，寄存器B数据输入
 * @param	regcWr_i	input，目的寄存器c写使能信号
 * @param	regcAddr_i	input，目的寄存器c对应地址(寄存器编号)
 * @param	regcData	output，目的寄存器c数据输出
 * @param	regcAddr	output，目的寄存器c地址输出
 * @param	regcWr		output，目的寄存器c写控制信号
 * @param	op			output，指令编号输出给内存管理模块MEM
 * @param	memAddr_i	output，传递给MEM的地址输出
 * @param	memData_i	output，传递给MEM的数据输出
 * @warning 对MEM模块输出的数据和地址宽度都为寄存器长度(32bit)
 */
module EX(
	rst,
	op_i, regaData, regbData, regcWr_i, regcAddr_i,
	regcData, regcAddr, regcWr,
	op, memAddr_i, memData_i
);

	/* input */
	input wire rst;								//复位信号
	input wire[`OP_LENGTH-1:0] op_i;			//指令译码后对应的指令编码(CMD_XXX)
	input wire[`REG_LENGTH-1:0] regaData;		//寄存器A数据输入
	input wire[`REG_LENGTH-1:0] regbData;		//寄存器B数据输入
	input wire regcWr_i;						//目的寄存器c写使能信号
	input wire[`REG_ADDR_LEN-1:0] regcAddr_i;	//目的寄存器c对应地址(寄存器编号)

	/* output 1 */
	output reg[`REG_LENGTH-1:0] regcData;		//目的寄存器c数据输出
	output reg[`REG_ADDR_LEN-1:0] regcAddr;		//目的寄存器c地址输出
	output reg regcWr;							//目的寄存器c写控制信号

	/* output 2 */
	output reg[`OP_LENGTH-1:0] op;				//指令编号输出给内存管理模块MEM
	output reg[`REG_LENGTH-1:0] memAddr_i;		//传递给MEM的地址输出
	output reg[`REG_LENGTH-1:0] memData_i;		//传递给MEM的数据输出


	/* 模块初始化 */
	initial begin
		/* 寄存器部分 */
		regcData <= {`REG_LENGTH{1'b0}};
		regcAddr <= {`REG_ADDR_LEN{1'b0}};
		regcWr <= `DISABLE;
		/* 非寄存器部分(RAM或IO) */
		op <= op_i;
		memAddr_i <= {`REG_LENGTH{1'b0}};
		memData_i <= {`REG_LENGTH{1'b0}};
	end


	/* 复位信号rst */
	always@(rst) begin
		/* 复位信号rst有效 */
		if(rst == `ENABLE) begin
			/* 寄存器部分 */
			regcData <= {`REG_LENGTH{1'b0}};
			regcAddr <= {`REG_ADDR_LEN{1'b0}};
			regcWr <= `DISABLE;
			/* 非寄存器部分(RAM或IO) */
			op <= op_i;
			memAddr_i <= {`REG_LENGTH{1'b0}};
			memData_i <= {`REG_LENGTH{1'b0}};
		end
	end


	/* 执行指令 */
	always@(*) begin
		/* 复位信号rst无效 */
		if(rst == `DISABLE) begin
			/* 根据op进行相应运算 */
			case(op_i)
				`CMD_NOP: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_ADD: begin
			 		/* 寄存器部分 */
					regcData <= regaData + regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_SUB: begin
			 		/* 寄存器部分 */
					regcData <= regaData - regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_AND: begin
			 		/* 寄存器部分 */
					regcData <= regaData & regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_OR: begin
			 		/* 寄存器部分 */
					regcData <= regaData | regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_XOR: begin
			 		/* 寄存器部分 */
					regcData <= regaData ^ regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_SLL: begin
			 		/* 寄存器部分 */
					regcData <= regaData << regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_SRL: begin
			 		/* 寄存器部分 */
					regcData <= regaData >> regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_SRA: begin
			 		/* 寄存器部分 */
					regcData <= (regaData >> regbData) | ({`REG_LENGTH{regaData[`REG_LENGTH-1]}} << (`REG_LENGTH - regbData));
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_JR: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_ADDI: begin
			 		/* 寄存器部分 */
					regcData <= regaData + regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_ANDI: begin
			 		/* 寄存器部分 */
					regcData <= regaData & regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_ORI: begin
			 		/* 寄存器部分 */
					regcData <= regaData | regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_BEQ: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_BNE: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_XORI: begin
			 		/* 寄存器部分 */
					regcData <= regaData ^ regbData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_LW: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					/* 注意：这里不检查地址最低两位是否是2'b00 */
					memAddr_i <= regaData;
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_SW: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					/* 注意：这里不检查地址最低两位是否是2'b00 */
					memAddr_i <= regaData;
					memData_i <= regbData;
				end
				`CMD_LUI: begin
			 		/* 寄存器部分 */
					regcData <= regaData << 16;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_J: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_JAL: begin
			 		/* 寄存器部分 */
					regcData <= regaData;
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_SLT: begin
					/* 寄存器部分 */
					if(regaData[`REG_LENGTH-1] == regbData[`REG_LENGTH-1]) begin
						/* ((a>=0) && (b>=0)) || ((a<0) && (b<0)) */
						regcData <= (regaData < regbData) ? `REG_LENGTH'h0000_0001 : `REG_LENGTH'h0000_0000;
					end
					else begin
						regcData <= (regaData[`REG_LENGTH-1] == 1'b1) ? `REG_LENGTH'h0000_0001 : `REG_LENGTH'h0000_0000;
					end
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_BGTZ: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				`CMD_BLTZ: begin
			 		/* 寄存器部分 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= regcWr_i;
					regcAddr <= regcAddr_i;
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
				default: begin
					/* 输出全零 */
					regcData <= {`REG_LENGTH{1'b0}};
					regcWr <= `DISABLE;
					regcAddr <= {`REG_ADDR_LEN{1'b0}};
					/* 非寄存器部分(RAM或IO) */
					op <= op_i;
					memAddr_i <= {`REG_LENGTH{1'b0}};
					memData_i <= {`REG_LENGTH{1'b0}};
				end
			endcase
		end
	end

endmodule
