# 目录
- [目录](#目录)
- [Version 1](#version-1)
- [Version 2](#version-2)
- [Version 3](#version-3)
- [Version 4](#version-4)

# Version 1
* 2021.04.28
	1. 初始化仓库
	2. 添加Doxygen风格的文件注释
	3. 添加指令存储器**InstMem**模块(`InstMem.vh`，`InstMem.v`，`InstMemFile.txt`)
	4. 添加取指**IF**模块(`IF.vh`，`IF.v`)
	5. 添加寄存器堆**RegFile模块**(`RegFile.vh`，`RegFile.v`，`RegFile.txt`)
* 2021.04.29
	1. 添加指令译码**ID**模块(`ID.vh`，`ID.v`)
	2. 发现**InstMem**指令存储模块与**ID**译码模块之间数据线**data**宽度存在问题，应该为*32*位
* 2021.05.13
	1. 修改**InstMem**指令存储模块的数据输出宽度为**ID**译码模块指令宽度*32*位
	2. 增加了**ID**指令译码模块的初始化和*rst*功能
* 2021.05.24
	1. 增加了**EX**指令执行模块(`EX.vh`，`EX.v`)，和一些基础的*R型*和*I型*指令
	2. 给**ID**指令译码模块增加了一些基础的*R型*和*I型*指令
	3. 将**RegFile**寄存器堆*读(Read)*改成*组合逻辑*，将*写(Write)*改成*时序逻辑*
	4. 增加*MIPS CPU*的顶层模块(`MIPS.v`)
# Version 2


# Version 3


# Version 4


