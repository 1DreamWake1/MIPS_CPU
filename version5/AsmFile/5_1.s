########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.30										#
# 简介：SLT指令测试									     #
########################################################

.text
.globl main

main:
	ori		$t0, $t0, 0x000F
	ori		$t1, $t1, 0x00F0
	lui		$t2, 0x800F
	lui		$t3, 0x80F0

	slt		$t4, $t0, $t1
	sw		$t4, 0x0000($zero)
	slt		$t4, $t0, $t2
	sw		$t4, 0x0004($zero)
	slt		$t4, $t2, $t3
	sw		$t4, 0x0008($zero)

end:
	j	end							#死循环，程序结束



.data


