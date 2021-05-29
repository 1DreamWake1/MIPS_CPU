########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.2										#
# 简介：计算1-10的累加，每步计算结果写入RAM，然后倒序读出	   #
########################################################

.text
.globl main

main:
	addi	$s0, $zero, 10		#累加目标值

loop1:
	beq		$s1, $s0, loop2		#计数器到达目标值
	addi	$s1, $s1, 1			#计数器自加
	add		$s2, $s2, $s1		#计算累加
	sll		$s3, $s1, 2			#得到存储地址
	sw		$s2, 0($s3)			#将结果写入RAM
	j		loop1				#继续循环

loop2:
	beq		$s1, $zero, end		#减到0
	sub		$s1, $s1, 1			#自减
	sll		$s3, $s1, 2			#得到存储地址
	lw		$s4, 0($s3)			#从RAM中读取数据到$s4
	j loop2						#继续循环

end:
	j	end						#死循环，程序结束



.data


