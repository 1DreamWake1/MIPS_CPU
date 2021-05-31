# 目录
- [目录](#目录)
- [Version 1](#version-1)
- [Version 2](#version-2)
- [Version 3](#version-3)
- [Version 4](#version-4)
- [vivado-v4](#vivado-v4)

# Version 1
* 2021.04.28
	1. 初始化仓库
	2. 添加*Doxygen*风格的文件注释
	3. 添加指令存储器**InstMem**模块(`InstMem.vh`，`InstMem.v`，`InstMemFile.txt`)
	4. 添加取指**IF**模块(`IF.vh`，`IF.v`)
	5. 添加寄存器堆**RegFile**模块(`RegFile.vh`，`RegFile.v`，`RegFile.txt`)
* 2021.04.29
	1. 添加指令译码**ID**模块(`ID.vh`，`ID.v`)
	2. 发现**InstMem**指令存储模块与**ID**译码模块之间数据线*data(inst)*宽度存在问题，应该为*32*位
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
	2. 增加最顶层**SOC**模块(`SOC.v`)
	3. 第一次使用`test_bench.v`测试**SOC**
	4. 将所有宏定义文件(`*.vh`)集中到`SOC.vh`和`MIPS.vh`，进行统一管理，以防重复包含或者缺少包含
	5. 第一次仿真通过，即语法没问题，开始检查逻辑错误
	6. 修改指令译码**ID**模块的BUG，第一次指令仿真通过
* 2021.05.26
	1. 修改指令执行模块**EX**中的*SRA*指令BUG
	2. ***version1***完成，开始***version2***
# Version 2
* 2021.05.26
	1. 增加了*J型*指令，第一次运行无条件跳转*j*指令
	2. 完善其余跳转指令(*函数调用*、*条件跳转*)
	3. 指令测试通过
	4. ***version2***完成
# Version 3
* 2021.05.27
	1. 开始***version3***
	2. 添加*RAM*模块**DataMem**(`DataMem.vh`，`DataMem.v`)
	3. 修改**DataMem**数据存储模块的存储模式为*大端模式*
	4. 添加内存管理模块**MEM**(`MEM.v`)
	5. 修改指令执行模块*EX*，增加了与*MEM*模块的三根连线
	6. 修改`RegFile.v`的格式和注释
	7. 为`MIPS.v`和`SOC.v`增加更多的注释
	8. `MIPS.v`中添加内存管理**MEM**模块，`SOC.v`中添加**DataMem(RAM)**模块，连线测试通过
	9. 增加对指令*sw*和*lw*的支持，测试完毕，无法直接使用*QtSpim*中的*User data segment*
* 2021.05.28
	1. **发现重大BUG**：**InstMem***指令存储器(ROM)*模块和**DataMem***内存(RAM)*模块存在*地址*问题
	2. 修改**MEM**和**RegFile**模块之间*RegAddr*连线的宽度为正确宽度
	3. 向**InstMem**和**DataMem**模块添加对地址的掩码运算(*地址重映射*)，取得*有效的地址*，注意不要使用超出范围的地址
	4. 向`InstMem.vh`和`DataMem.vh`中添加*固定的地址掩码宏*
	5. 将**InstMem**和**DataMem**中的对地址的掩码运算移动到独立的*always*块中
	6. 增加目录`ASmFile/`，用来存放*汇编测试代码*
	7. ***version3***完成
# Version 4
* 2021.05.29
	1. 开始***version4***
	2. 添加*输入输出*模块**IO**(`IO.vh`，`IO.v`)
	3. 修改`SOC.vh`和`SOC.v`中的包含关系
	4. 修改`test_bench.v`中仿真时间为*2000个单位*
	5. 直接使用**IO**模块替代**DataMem**模块测试成功
	6. 增加了对空指令*nop*的支持
	7. 增加了对*零号寄存器(zero)*的写禁止
	8. 添加对**RAM**和**IO**访问的控制模块**MIOC**(`MIOC.vh`，`MIOC.v`)
	9. 向**IO**输入输出模块添加*rst*复位信号
	10. `3_1.s`测试通过，即对**DataMem(RAM)**的访问成功，未测试对**IO**的访问
* 2021.05.30
	1. 修改**MIOC**模块中不工作时，对**DataMem(RAM)**和**IO(register)**的*地址线*和*写数据线*为0
	2. 通过`4_3.s`测试**MIOC**访问**IO(register)**成功
	3. ***version4***完成
	4. 添加对***version5***和***version6***的设计
	5. 更新`README.md`有关***version5***和***version6***的描述

# vivado-v4
* 2021.05.31
	1. 向`IO.vh`和`IO.v`和`SOC.v`添加有关**GPIO**输入输出的说明(**不是模块!**)
	2. 添加下板代码`4_4v.s`(未完成)
	3. 添加下板用的**InstMem(ROM)**指令初始化
	4. 添加下板用**RegFile**的寄存器初始化
	5. `vivado-v4`第一次迁移完成，准备下板

