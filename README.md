# 总体概述

1. 为了加深自己对`CPU`的认识以及完成***计算机组成原理***这门课程的任务要求，使用`Verilog`实现`MIPS CPU`的设计。
2. 整个过程从简单到复杂，每个版本单独占用一个目录。
3. 开发环境使用在`Deepin20`下使用`VScode`、`iverilog`、`GTKWave`



# 目录

[TOC]






# 版本简介

## Version 1

### 说明

1. 仅完成最基础的框架

### 原理图

![Version 1](doc/MIPS_1.jpg)

## Version 2

### 说明

1. 在`Version 1`的基础上加入了对**跳转(J型)指令**的支持

### 原理图

![Version 2](doc/MIPS_2.jpg)

## Version 3

### 说明

1. 在`Version 2`的基础上增加了`MEM`(存储管理)模块，用于区分`RegFile`和`DataMem`
2. 使用**哈佛结构**，**指令存储**和**数据存储**分开

### 原理图

![Version 3](doc/MIPS_3.jpg)

## Version 4

### 说明

1. 在`Version 3`的基础上增加了`MIOC`模块，用于区分`DataMem`和`IO`

### 原理图

![Version 4](doc/MIPS_4.jpg)