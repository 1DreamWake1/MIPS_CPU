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
* 2021.05.25
	1. 完善*MIPS CPU*顶层模块
	2. 增加最顶层*SOC*模块(`SOC.v`)
	3. 第一次使用`test_bench.v`测试*SOC*
	4. 将所有宏定义文件(`*.vh`)集中到`SOC.vh`和`MIPS.vh`，进行统一管理，以防重复包含或者缺少包含
	5. 第一次仿真通过，即语法没问题，开始检查逻辑错误
	6. 修改指令译码*ID*模块的BUG，第一次指令仿真通过
* 2021.05.26
	1. 修改指令执行模块*EX*中的*SRA*指令BUG
	2. **version1**完成，开始**version2**
# Version 2
* 2021.05.26
	1. 增加了*J型*指令，第一次运行无条件跳转*j*指令
	2. 完善其余跳转指令(*函数调用*、*条件跳转*)
	3. 指令测试通过
	4. **version2**完成
# Version 3
* 2021.05.27
	1. 开始**version3**
	2. 添加*RAM*模块*DataMem*(`DataMem.vh`，`DataMem.v`)
	3. 修改**DataMem**数据存储模块的存储模式为*大端模式*
	4. 添加内存管理模块**MEM**(`MEM.v`)
	5. 修改指令执行模块*EX*，增加了与*MEM*模块的三根连线
	6. 修改`RegFile.v`的格式和注释
	7. 为`MIPS.v`和`SOC.v`增加更多的注释
	8. `MIPS.v`中添加内存管理*MEM*模块，`SOC.v`中添加*DataMem(RAM)*模块，连线测试通过
	9. 增加对指令*sw*和*lw*的支持，测试完毕，无法直接使用*QtSpim*中的*User data segment*
# Version 4


