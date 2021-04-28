#!/bin/bash

# 通过查看是否有build文件夹来判断是否是第一次创建项目
# 并且，如果没有build文件夹，则创建build文件夹
if [ ! -d "build" ]; then
    mkdir build
#   echo -e "\t\tWellcome!!!!\t\tLiuChuanXi~~~~~\t\t" | toilet -f term -F border --gay
	toilet -f mono12 -F gay "Wellcome" 
    echo "$(date '+%D %T' | toilet -f term --gay)"
fi

# 如果没有include文件夹，则进行创建
if [ ! -d "include" ]; then
    mkdir "include"
fi

# 如果没有source文件夹，则进行创建
if [ ! -d "source" ]; then
    mkdir "source"
fi

# 如果没有test_bench.v，则进行创建，并添加时间和`timescale
# 创建完成后退出
if [ ! -f "test_bench.v" ]; then
    touch "test_bench.v"
	echo -e "/* $(date '+%Y %D %T') */\n" >> test_bench.v
	echo -e "\`timescale 1ns/1ns\n" >> test_bench.v
	echo -e "\`define LINUX_VERILOG //Verilog in Linux\n\n\n" >> test_bench.v
	echo -e "module test_bench();\n" >> test_bench.v
	echo -e "\t/* Linux下测试模块 */" >> test_bench.v
	echo -e "\`ifdef LINUX_VERILOG" >> test_bench.v
	echo -e "\tinitial begin\n" >> test_bench.v
	echo -e "\t\t\$dumpfile(\"./build/wave.vcd\");" >> test_bench.v
	echo -e "\t\t\$dumpvars(0, test_bench);\n" >> test_bench.v
	echo -e "\t\t#1000\n\t\t\t\$stop(2);\n" >> test_bench.v
	echo -e "\tend" >> test_bench.v
	echo -e "\`endif //LINUX_VERIOLG\n" >> test_bench.v
	echo -e "endmodule\n\n" >> test_bench.v
	exit
fi

# 包含路径
INCLUDE_DIR="./include"
# 源码路径
SOURCE_DIR="./source/*"

# 编译前先清理上次生成的文件
if [ -d "./build" ]; then
	echo -e "Delete build's files"
	rm ./build/wave*
fi

# 编译，在build下生成wave的vvp脚本
echo -e "\t\tStart compiling......\t\t" | toilet -f term -F border --gay
iverilog -o ./build/wave test_bench.v ${SOURCE_DIR} -I ${INCLUDE_DIR}
echo -e "---------------------------------------------" | toilet -f term --gay

# 查看是否拥有编译生成的wave
echo -e "\tGenerating waveform file......\t\t" | toilet -f term -F border --gay
echo -e "---------------------------------------------" | toilet -f term --gay
if [ -f "./build/wave" ]; then
	vvp -n ./build/wave -lxt2 -o ./build/
else
	echo -e "\033[31m Error: File \"./build/wave\" does not exist!!!\033[0m"
	exit
fi
echo -e "---------------------------------------------" | toilet -f term --gay

# 调用GTKwave显示波形
echo -e "\tStart display the waveform......\t" | toilet -f term -F border --gay
if [ ! -f "./build/wave.vcd" ]; then
	echo -e "\033[31m Error: File \"./build/wave.vcd\" does not exist!!!\033[0m"
	exit
else
	gtkwave ./build/wave.vcd
fi
echo -e "\t\tSee you~~~\t\t" | toilet -f term -F border --gay
