########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.30										#
# 简介：乘法指令mult,multu测试							  #
########################################################

.text
.globl main

main:
	lui		$t0, 0x8FFF
	ori		$t0, $t0, 0xFFFF
	ori		$t1, $t1, 0x8000
	multu	$t0, $t1
	mult	$t0, $t1

end:
	j	end							#死循环，程序结束



.data


