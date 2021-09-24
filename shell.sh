
# 注释一
:<<EOF
注释二
EOF
echo "hello world"

# 变量
name1='l'
name2="l"
name3=l
echo ${name3}

# 只读变量
readonly r=ll
declare -r name=abc
echo $r $name

# 删除变量，不能unset readonly变量
nameunset="test"
unset nameunset
echo $nameunset

# 变量类ii型
#1自定义变量(局部变量)子进程可访问
#2环境变量(全局变量)子进程不可访问

#1->2 export var或declare -x var
#2->1 export var=val或declare +x var

# 字符串，可用单引号，可用双引号也可不用双引号
:<<EOF
单引号中的内容会原样输出，不会执行、不会取变量；
双引号中的内容可以执行、可以取变量
EOF

name=yxc
echo 'hello,$name \"hh\"'
echo "hello,$name \"hh\""

#获取字符串长度
echo ${#name}
#提取子串
name2="hello,yxc"
echo ${name2:0:5}

#文件参数变量
:<<EOF
在执行shell脚本时，可以向脚本传递参数。$1是第一个参数，$2是第二个参数，以此类推。特殊的，$0是文件名（包含路径
EOF
echo "文件名："$o
echo "第一个参数"$1
echo "第二个参数"$2
echo "第三个参数"$3

:<<EOF
其它参数相关变量
参数	说明
$#	代表文件传入的参数个数，如上例中值为4
$*	由所有参数构成的用空格隔开的字符串，如上例中值为"$1 $2 $3 $4"
$@	每个参数分别用双引号括起来的字符串，如上例中值为"$1" "$2" "$3" "$4"
$$	脚本当前运行的进程ID
$?	上一条命令的退出状态（注意不是stdout，而是exit code）。0表示正常退出，其他值表示错误
$(command)	返回command这条命令的stdout（可嵌套）
`command`	返回command这条命令的stdout（不可嵌套）
EOF

#数组
:<<EOF
类似js数组，数组中可以存放多个不同类型的值，只支持一维数组，初始化时不需要指明数组大小。数组下标从0开始。
EOF
#定义用小括号表示，元素间空格隔开，也可直接定义数组元素值
array=(1 abc "def" yxc)
#可以array[1000]=test，不用连续
array[100]=111
#读取某个元素的值${array[index]}
#读取整个数组
echo ${array[@]}
echo ${array[*]}

#数组长度，类似字符串长
echo ${#array[@]}
echo ${#array[*]}

#expr本质是第三方命令，可以借之实现计算
str="hellolll"
echo $(expr length "$str")

:<<EOF
用空格隔开每一项
用反斜杠放在shell特定的字符前面（发现表达式运行错误时，可以试试转义）
对包含空格和其他特殊字符的字符串要用引号括起来
expr会在stdout中输出结果。如果为逻辑关系表达式，则结果为真，stdout为1，否则为0。
expr的exit code：如果为逻辑关系表达式，则结果为真，exit code为0，否则为1。
EOF

#字符串表达式
:<<EOF
length str
index str charset 返回单个字符在str中最前面的字符位置，下标从1开始，若str中完全不存在charset中字符返回0
substr str POSITION LENGTH 返回str字符串中从POSITION开始，长度最大为LENGTH的子串，若POSITION或LENGTH为负，0或非数值返回空字符串
EOF

temp="hello world!"
echo `expr length "$temp"` #``不是单引号，表示执行该命令，输出12
echo `expr index "$temp" awd` #输出7,下标从1开始
echo `expr substr "$temp" 2 3` #输出ell

#整数表达式
#expr支持普通的算术操作，算术表达式优先级低于字符串表达式，高于逻辑关系表达式。
#+-两端参数会转为证书，若失败报错
#*/$乘除取模运算，两端参数会转换为整数，若转换失败则报错
#()可以该表优先级，但要用反斜杠转义
a=3
b=4
echo `expr $a + $b` #7
echo `expr $a - $b` #-1
echo `expr $a \* $b` #12 ，注意*要转义
echo `expr $a / $b` #0整除
echo `expr $a % $b` #3
echo `expr \( $a + 1 \) \* \( $b + 1 \)` #20 (a+1)*(b+1)

#逻辑关系表达式 
# | 和 & 短路原则
:<<EOF
< <= = == != >= >
比较两端的参数，如果为true，则返回1，否则返回0。”==”是”=”的同义词。”expr”首先尝试将两端参数转换为整数，并做算术比较，如果转换失败，则按字符集排序规则做字符比较。
()可以该表优先级，但需要用反斜杠转义
EOF

c=0
d=5

echo `expr $c \& $d`  # 输出0
echo `expr $a \& $b`  # 输出3
echo `expr $c \| $d`  # 输出5
echo `expr $a \| $b`  # 输出3

#read命令，用于从标准输入读取单行数据，当读到文件结束时，exit code为1否则为0
#-p后面可接提示信息 -t后面跟秒数，超过时间自动忽略此命令

read -p "please input your name:" -t 10 inputname
echo $inputname

#echo命令
#普通字符串，引号可省略
#显示转义字符
echo "\"hello ac terminal\""
echo \"hello ac terminal\"
#显示变量
namet=yxc
echo "My name is $namet"  # 输出 My name is yxc
#显示换行
echo -e "Hi\n"  # -e 开启转义
echo "acwing"
#显示不换行
echo -e "Hi \c" # -e 开启转义 \c 不换行
echo "acwing"
#显示结果定向至文件
echo "Hello World" > output.txt  # 将内容以覆盖的方式输出到output.txt中

#原样输出字符串，不进行转义或取变量(用单引号)
name111=acwing
echo '$name111\"'

#显示命令的执行结果
echo `date`

:<<EOF
printf命令用于格式化输出，类似于C/C++中的printf函数。默认不会在字符串末尾添加换行符。命令格式：
printf format-string [arguments...]
EOF
printf "%10d.\n" 123  # 占10位，右对齐
printf "%-10.2f.\n" 123.123321  # 占10位，保留2位小数，左对齐
printf "My name is %s\n" "yxc"  # 格式化输出字符串
printf "%d * %d = %d\n"  2 3 `expr 2 \* 3` # 表达式的值作为参数


