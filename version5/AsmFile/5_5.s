########################################################
# 作者：LiuChuanXi										#
# 日期：2020.06.02										#
# 简介：除法指令DIV,DIVU测试							  #
########################################################

.text
.globl main

main:
	lui		$t0, 0xFFFF
	ori		$t0, $t0, 0xFFFF
	ori		$t1, $t1, 0x8000
	divu	$t0, $t1
	div		$t0, $t1

end:
	j	end							#死循环，程序结束



.data

