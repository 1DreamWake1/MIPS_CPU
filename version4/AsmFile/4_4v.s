########################################################
# 作者：LiuChuanXi										#
# 日期：2020.05.31										#
# 简介：下板代码，灯全交替亮(GPIO_OR)						   #
########################################################

.text
.globl main

main:
	ori		$t0, $t0, 0xAAAA
	sw		$t0, 0x0404($zero)

end:
	j		end


.data


