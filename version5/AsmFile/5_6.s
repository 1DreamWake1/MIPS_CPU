########################################################
# 作者：LiuChuanXi										#
# 日期：2020.06.02										#
# 简介：hilo寄存器访问指令MFHI,MFLO,MTFI,MTLO测试		   #
########################################################

.text
.globl main

main:
	lui		$t0, 0xFFFF
	ori		$t0, $t0, 0xFFFF
	lui		$t1, 0xAAAA
	ori		$t1, $t1, 0xAAAA

	mthi	$t0
	mtlo	$t1
	mfhi	$t2
	mflo	$t3
	sw		$t2, 0x0000($zero)
	sw		$t3, 0x0004($zero)

end:
	j	end							#死循环，程序结束



.data


