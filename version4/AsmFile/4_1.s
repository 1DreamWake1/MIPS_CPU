########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.29										#
# 简介：空指令nop和sll指令区分测试						   #
########################################################

.text
.globl main

main:
	addi	$s0, $zero, 1		#赋初值
	sll		$s0, $s0, 0			#测试1
	nop							#测试2
	sll		$s0, $s0, 1			#测试3
	nop							#测试4
	sll		$zero, $zero, 0		#测试5
	lui		$s1, 15				#测试6

end:
	j	end						#死循环，程序结束


.data

