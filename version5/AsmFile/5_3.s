########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.30										#
# 简介：JALR指令测试									 #
########################################################

.text
.globl main

main:
	ori		$t0, $t0, 0x0001
	ori		$t1, $t1, 0x0008

loop1:
	add		$t0, $t0, $t0
	jalr	$t2, $t1

end:
	j	end							#死循环，程序结束



.data


