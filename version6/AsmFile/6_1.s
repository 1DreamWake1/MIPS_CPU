########################################################
# 作者：LiuChuanXi										#
# 日期：2020.06.02										#
# 简介：GPIO输入输出模块测试							   #
########################################################

.text
.globl main

main:
	lw		$t0, 0x0408($zero)		#读入数据
	lw		$t0, 0x0408($zero)		#读入数据
	lui		$t1, 0xFFFF
	ori		$t1, $t1, 0xFFFF
	sw		$t1, 0x0400($zero)		#全部输出
	lui		$t2, 0xABAB
	ori		$t2, $t2, 0xCDCD
	sw		$t2, 0x0404($zero)		#输出

end:
	j	end							#死循环，程序结束



.data


