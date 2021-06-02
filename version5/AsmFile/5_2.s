########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.30										#
# 简介：SLT指令测试									     #
########################################################

.text
.globl main

main:
	ori		$t0, $t0, 0x0005
	lui		$t1, 0xFFFF
	ori		$t1, 0xFFFA

loop1:
	addi	$t0, $t0, -1
	bgtz	$t0, loop1

loop2:
	addi	$t1, $t1, 1
	bltz	$t1, loop2

end:
	j	end							#死循环，程序结束



.data


