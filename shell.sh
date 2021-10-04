:<<EOF
概论
学习技巧
不要死记硬背，遇到含糊不清的地方，可以在AC Terminal里实际运行一遍。
编写 bash 脚本有时候会很别扭和反直觉。例如 shellcheck这样的工具可以帮助你定位sh/bash脚本中的错误。
脚本示例
新建一个test.sh文件，内容如下：
#! /bin/bash
echo "Hello World!"
运行方式
作为可执行文件
acs@9e0ebfcd82d7:~$ chmod +x test.sh  # 使脚本具有可执行权限
acs@9e0ebfcd82d7:~$ ./test.sh  # 当前路径下执行
Hello World!  # 脚本输出
acs@9e0ebfcd82d7:~$ /home/acs/test.sh  # 绝对路径下执行
Hello World!  # 脚本输出
acs@9e0ebfcd82d7:~$ ~/test.sh  # 家目录路径下执行
Hello World!  # 脚本输出
用解释器执行

此外，注意：脚本并不一定只有用bash写才能调用，如python脚本，将输入参数倒序输出：
内核知道去用python解释器而不是shell命令来运行这段脚本，是因为脚本的开头第一行的shebang。
在 shebang 行中使用 env 命令是一种好的实践，它会利用环境变量中的程序来解析该脚本，这样就提高来您的脚本的可移植性。
env 会利用我们第一节讲座中介绍过的PATH 环境变量来进行定位。 例如，使用了env的shebang看上去时这样的#!/usr/bin/env python。
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)

shell函数和脚本有如下一些不同点：
函数只能用与shell使用相同的语言，脚本可以使用任意语言。因此在脚本中包含 shebang 是很重要的。
函数仅在定义时被加载，脚本会在每次被执行时加载。这让函数的加载比脚本略快一些，但每次修改函数定义，都要重新加载一次。
函数会在当前的shell环境中执行，脚本会在单独的进程中执行。因此，函数可以对环境变量进行更改，比如改变当前工作目录，脚本则不行。
脚本需要使用 export 将环境变量导出，并将值传递给环境变量。
与其他程序语言一样，函数可以提高代码模块性、代码复用性并创建清晰性的结构。shell脚本中往往也会包含它们自己的函数定义。
EOF

:<<EOF
注释 
# 注释一
#":<<EOF"
#"注释二"
#"EOF"
echo "hello world"
EOF
:<<EOF
变量
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
单引号中的内容会原样输出，不会执行、不会取变量；
双引号中的内容可以执行、可以取变量

name=yxc
echo 'hello,$name \"hh\"'
echo "hello,$name \"hh\""

''不会替换变量值但双引号会
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo

#获取字符串长度
echo ${#name}
#提取子串
name2="hello,yxc"
echo ${name2:0:5}
EOF

#文件参数变量
:<<EOF
在执行shell脚本时，可以向脚本传递参数。$1是第一个参数，$2是第二个参数，以此类推。特殊的，$0是文件名（包含路径
echo "文件名："$o
echo "第一个参数"$1
echo "第二个参数"$2
echo "第三个参数"$3
命令通常使用 STDOUT来返回输出值，使用STDERR 来返回错误及错误码
其它参数相关变量
参数	说明
$#	代表文件传入的参数个数，如上例中值为4
$*	由所有参数构成的用空格隔开的字符串，如上例中值为"$1 $2 $3 $4"
$@	每个参数分别用双引号括起来的字符串，如上例中值为"$1" "$2" "$3" "$4"
$$	脚本当前运行的进程ID
$?	上一条命令的返回值（注意不是stdout，而是exit code）。0表示正常退出，其他值表示错误
$(command)	返回command这条命令的stdout（可嵌套）
`command`	返回command这条命令的stdout（不可嵌套）
$$ 当前脚本进程的PID
!! 完整的上一条命令，常见应用：当你因为权限不足执行命令失败时，可以使用 sudo !!再尝试一次。
$_ - 上一条命令的最后一个参数。如果你正在使用的是交互式shell，你可以通过按下 Esc 之后键入 . 来获取这个值。

命令替换和进程替换
另一个常见的模式是以变量的形式获取一个命令的输出，当通过$(command)执行command时，输出结果会替换掉$(command)
如for file in $(ls)先调用ls，再遍历返回值
还有另外冷门特性是进程替换，<(command)会执行cmd并将结果输出到临时文件，并将<(cmd)替换成临时文件名，希望返回值
通过文件而不是STDIN传递时很有用。如diff <(ls foo) <(ls bar)会显示foo和bar文件夹的区别

例子：脚本遍历提供参数，用grep搜索字符串foobar，若没找到将其作为注释追加到文件中
#!/bin/bash
echo "Starting program at $(date)" # date会被替换成日期和时间
echo "Running program $0 with $# arguments with pid $$"
for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # 如果模式没有找到，则grep退出状态为 1
    # 我们将标准输出流和标准错误流重定向到Null，因为我们并不关心这些信息
    #在bash中进行比较时，尽量使用双方括号 [[ ]] 而不是单方括号 [ ]
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done

通配符
?和*分别匹配一个或人一个字符
{}当有一些列指令，其中包含公共子串时，可用花括号自动展开这些命令，这在批量移动或转换文件时很方便
convert image.{png,jpg}
# 会展开为
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# 会展开为
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# 也可以结合通配使用
mv *{.py,.sh} folder
# 会移动所有 *.py 和 *.sh 文件

mkdir foo bar

# 下面命令会创建foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h这些文件
touch {foo,bar}/{a..h}
touch foo/x bar/y
# 比较文件夹 foo 和 bar 中包含文件的不同
diff <(ls foo) <(ls bar)
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

:<<EOF
#expr本质是第三方命令，可以借之实现计算
str="hellolll"
echo $(expr length "$str")

用空格隔开每一项
用反斜杠放在shell特定的字符前面（发现表达式运行错误时，可以试试转义）
对包含空格和其他特殊字符的字符串要用引号括起来
expr会在stdout中输出结果。如果为逻辑关系表达式，则结果为真，stdout为1，否则为0。
expr的exit code：如果为逻辑关系表达式，则结果为真，exit code为0，否则为1。


#字符串表达式
length str
index str charset 返回单个字符在str中最前面的字符位置，下标从1开始，若str中完全不存在charset中字符返回0
substr str POSITION LENGTH 返回str字符串中从POSITION开始，长度最大为LENGTH的子串，若POSITION或LENGTH为负，0或非数值返回空字符串

temp="hello world!"
echo `expr length "$temp"` #``不是单引号，表示执行该命令，输出12
echo `expr index "$temp" awd` #输出7,下标从1开始
echo `expr substr "$temp" 2 3` #输出ell

#整数表达式
#expr支持普通的算术操作，算术表达式优先级低于字符串表达式，高于逻辑关系表达式。
#\+-两端参数会转为证书，若失败报错
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
< <= = == != >= >
比较两端的参数，如果为true，则返回1，否则返回0。”==”是”=”的同义词。”expr”首先尝试将两端参数转换为整数，并做算术比较，如果转换失败，则按字符集排序规则做字符比较。
()可以该表优先级，但需要用反斜杠转义

c=0
d=5

echo `expr $c \& $d`  # 输出0
echo `expr $a \& $b`  # 输出3
echo `expr $c \| $d`  # 输出5
echo `expr $a \| $b`  # 输出3
EOF

:<<EOF
#read命令，用于从标准输入读取单行数据，当读到文件结束时，exit code为1否则为0
#-p后面可接提示信息 -t后面跟秒数，超过时间自动忽略此命令

read -p "please input your name:" -t 10 inputname
echo $inputname
EOF

:<<EOF
echo命令
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
EOF

:<<EOF
printf命令用于格式化输出，类似于C/Cpp中的printf函数。默认不会在字符串末尾添加换行符。命令格式：
printf format-string [arguments]
EOF
printf "%10d.\n" 123  # 占10位，右对齐
printf "%-10.2f.\n" 123.123321  # 占10位，保留2位小数，左对齐
printf "My name is %s\n" "yxc"  # 格式化输出字符串
printf "%d * %d = %d\n"  2 3 `expr 2 \* 3` # 表达式的值作为参数

:<<EOF
test命令与判断符号[]
逻辑运算符&&和||有短路原则，exit code为0表真，非0表假
test命令用于判断文件类型，以及对变量做比较。test命令用exit code返回结果，而非stdout。0表示真，非0表示假。 
EOF
test 2 -lt 3
echo $?
test -e shell.sh && echo 'exist' || echo "No exist"#-e/f/d分别表示文件是否存在/是否为文件/目录
test -r shell2.sh && echo "Y" || echo "No" # -r/w/x/s是否文件可读/写/执行/非空，只能单个测试好像
#整数比较 test $a -eq $b a是否等于b -eq/ne/gt/lt/ge/le分别表示等于/不等/大于/小于/大于等于/小于等于
#字符串比较，test -z str -z/n str是否为空/非空 test s1==s2是否相等或不等(!=) 
#多重条件判断，test -r file1 -a -x file2 -a/o/!两条件同时成立/至少一个成立/取反
#判断符号[]与test用法几乎一样，更常用于if语句中。另外[[]]是[]的加强版，支持的特性更多。
#注意
#[]内的每一项都要用空格隔开
#中括号内的变量，最好用双引号括起来
#中括号内的常数，最好用单或双引号括起来
[ 1 -lt 2 ] && echo $?
[ -e test.sh ] && echo "exist" || echo "Not exist"
name1="acwing yxc"
[ "$name1" == "acwing yxc" ] && echo $? #注意不是[ $name == "acwing yxc" ]等价于 [ acwing yxc == "acwing yxc" ]，报错参数太多

:<<EOF
判断语句
if-elif-elif-else，类似if-else语句。  
命令格式：
if condition
then
    语句1
elif condition
then
    语句1
elif condition
then
    语句1
else
    语句1
    语句2
fi

case...esac类似switch
命令格式：
case $变量名称 in
    值1)
        语句1
        语句2
        ...
        ;;  # 类似于C/C++中的break
    值2)
        语句1
        语句2
        ...
        ;;
    *)  # 类似于C/C++中的default
        语句1
        语句2
        ...
        ;;
esac
EOF
a=4

if [ $a -eq 1 ]
then
    echo ${a}等于1
elif [ $a -eq 2 ]
then
    echo ${a}等于2
elif [ $a -eq 3 ]
then
    echo ${a}等于3
else
    echo 其他
fi

case $a in
    1)
        echo ${a}等于1
        ;;  
    2)
        echo ${a}等于2
        ;;  
    3)                                                
        echo ${a}等于3
        ;;  
    *)
        echo 其他
        ;;  
esac

:<<EOF
循环语句
for…in…do…done
命令格式：
for var in val1 val2 val3
do
    语句1
    语句2
    ...
done

for ((…;…;…)) do…done
命令格式：
for ((expression; condition; expression))
do
    语句1
    语句2
done

while…do…done循环
命令格式：
while condition
do
    语句1
    语句2
    ...
done

until…do…done循环当条件为真时结束。
命令格式：
until condition
do
    语句1
    语句2
    ...
done

break命令跳出当前一层循环，注意与C/C++不同的是：break不能跳出case语句。
示例
while read name
do
    for ((i=1;i<=10;i++))
    do
        case $i in
            8)
                break
                ;;
            *)
                echo $i
                ;;
        esac
    done
done

continue命令跳出当前循环。
示例：
for ((i=1;i<=10;i++))#输出1-10中所有奇数
do
    if [ `expr $i % 2` -eq 0 ]
    then
        continue
    fi
    echo $i
done

死循环的处理方式
如果AC Terminal可以打开该程序，则输入Ctrl+c即可。否则可以直接关闭进程：
使用top命令找到进程的PID
输入kill -9 PID即可关掉此进程
EOF

:<<EOF
bash中函数类似C++函数，但return返回值和C++不同，返回的是exit code取值0-255,0表正常结束
如果想获取函数的输出结果，可以通过echo输出到stdout中，然后通过来获取stdout中的结果。
函数的return值可以通过$?来获取。命令格式：
[function] func_name() {  # function关键字可以省略
    语句1
    语句2
    ...
}
1不获取 return值和stdout值,示例
EOF
func() {
    name=yxc
    echo "Hello $name"
}
func
# 获取 return值和stdout值，不写return时，默认return 0。示例
func2() {
    name=yxc
    echo "Hello $name"
    return 123
}
output=$(func2)
ret=$?
echo "output = $output"
echo "return = $ret"

#函数的输入参数，在函数内，$1表示第一个输入参数，$2表示第二个输入参数，依此类推。
#注意：函数内的$0仍然是文件名，而不是函数名。示例：
func() {  # 递归计算 $1 + ($1 - 1) + ($1 - 2) + ... + 0
    word=""
    while [ "${word}" != 'y' ] && [ "${word}" != 'n' ]
    do
        read -p "要进入func($1)函数吗？请输入y/n：" word
    done

    if [ "$word" == 'n' ]
    then
        echo 0
        return 0
    fi  

    if [ $1 -le 0 ] 
    then
        echo 0
        return 0
    fi  

    sum=$(func $(expr $1 - 1))
    echo $(expr $sum + $1)
}
echo $(func 10)

#函数内的局部变量，可以在函数内定义局部变量，作用范围仅在当前函数内。可以在递归函数中定义局部变量。命令格式：
#local 变量名=变量值，例如：

#! /bin/bash
func() {
    local name=yxc
    echo $name
}
func
echo $name #错误，函数外调用name变量，会发现此时该变量不存在。


:<<EOF
exit命令
exit命令用来退出当前shell进程，并返回一个退出状态；使用$?可以接收这个退出状态。
exit命令可以接受一个整数值作为参数，代表退出状态。如果不指定，默认状态值是 0。
exit退出状态只能是一个介于 0~255 之间的整数，其中只有 0 表示成功，其它值都表示失败。
示例：创建脚本test.sh，内容如下：
#! /bin/bash
if [ $# -ne 1 ]  # 如果传入参数个数等于1，则正常退出；否则非正常退出。
then
    echo "arguments not valid"
    exit 1
else
    echo "arguments valid"
    exit 0
fi  
./test.sh acwing #正常退出，exit code为0
EOF

:<<EOF
文件重定向
每个进程默认打开3个文件描述符：

stdin标准输入，从命令行读取数据，文件描述符为0
stdout标准输出，向命令行输出数据，文件描述符为1
stderr标准错误输出，向命令行输出数据，文件描述符为2
可以用文件重定向将这三个文件重定向到其他文件中
command > file	将stdout重定向到file中
command < file	将stdin重定向到file中
command >> file	将stdout以追加方式重定向到file中
command n> file	将文件描述符n重定向到file中
command n>> file	将文件描述符n以追加方式重定向到file中
输入和输出重定向
echo -e "Hello \c" > output.txt  # 将stdout重定向到output.txt中
echo "World" >> output.txt  # 将字符串追加到output.txt中
read str < output.txt  # 从output.txt中读取字符串
echo $str  # 输出结果：Hello World

同时重定向stdin和stdout
创建bash脚本：
#! /bin/bash
read a
read b
echo $(expr "$a" + "$b")
创建input.txt，里面的内容为：
3
4
执行命令：
acs@9e0ebfcd82d7:~$ chmod +x test.sh  # 添加可执行权限
acs@9e0ebfcd82d7:~$ ./test.sh < input.txt > output.txt  # 从input.txt中读取内容，将输出写入output.txt中
acs@9e0ebfcd82d7:~$ cat output.txt  # 查看output.txt中的内容
EOF

:<<EOF
引入外部脚本
类似于C/C++中的include操作，bash也可以引入其他文件中的代码。
语法格式：
. filename  # 注意点和文件名之间有一个空格
或
source filename
示例
创建test1.sh，内容为：
#! /bin/bash
name=yxc  # 定义变量name
然后创建test2.sh，内容为：
#! /bin/bash
source test1.sh # 或 . test1.sh
echo My name is: $name  # 可以使用test1.sh中的变量
EOF

:<<EOF
查找文件
程序员们面对的最常见的重复任务就是查找文件或目录。所有的类UNIX系统都包含一个名为 find的工具，它是shell上用于查找文件的绝佳工具。
find命令会递归地搜索符合条件的文件，例如：

# 查找所有名称为src的文件夹
find . -name src -type d
# 查找所有文件夹路径中包含test的python文件
find . -path '*/test/*.py' -type f
# 查找前一天修改的所有文件
find . -mtime -1
# 查找所有大小在500k至10M的tar.gz文件
find . -size +500k -size -10M -name '*.tar.gz'

除了列出所寻找的文件之外，find还能对所有查找到的文件进行操作。这能极大地简化一些单调的任务。
# 删除全部扩展名为.tmp 的文件
find . -name '*.tmp' -exec rm {} \;
# 查找全部的 PNG 文件并将其转换为 JPG
find . -name '*.png' -exec convert {} {}.jpg \;

尽管 find 用途广泛，它的语法却比较难以记忆。例如，为了查找满足模式 PATTERN 的文件，您需要执行 find -name '*PATTERN*' (如果您希望模式匹配时是不区分大小写，可以使用-iname选项）
当然可用alias设置别名简化操作，但shell的哲学之一便是寻找（更好用的）替代方案。 shell最好的特性就是您只是在调用程序，因此只要找到合适的替代程序即可（甚至自己编写）。
例如， fd 就是一个更简单、更快速、更友好的程序，它可以用来作为find的替代品。它有很多不错的默认设置，例如输出着色、默认支持正则匹配、支持unicode并且我认为它的语法更符合直觉。
以模式PATTERN 搜索的语法是 fd PATTERN。大多数人都认为 find 和 fd 已经很好用了，但是有的人可能想知道，我们是不是可以有更高效的方法，例如不要每次都搜索文件而是
通过编译索引或建立数据库的方式来实现更加快速地搜索。这就要靠 locate 了。 locate 使用一个由 updatedb负责更新的数据库，在大多数系统中 updatedb 都会通过 cron每日更新。
这便需要我们在速度和时效性之间作出权衡。而且，find 和类似的工具可以通过别的属性比如文件大小、修改时间或是权限来查找文件，locate则只能通过文件名。
重要的是你要知道有些问题使用合适的工具就会迎刃而解，而具体选择哪个工具则不是那么重要。
EOF

:<<EOF
查找代码
一个最常见的场景是您希望查找具有某种模式的全部文件，并找它们的位置。
为了实现这一点，很多类UNIX的系统都提供了grep命令，它是用于对输入文本进行匹配的通用工具。
-C ：获取查找结果的上下文（Context）；-v 将对结果进行反选（Invert），也就是输出不匹配的结果
-R 会递归地进入子目录并搜索所有的文本文件,我们有很多办法可以对 grep -R 进行改进，例如使其忽略.git 文件夹，使用多CPU等等。
因此也出现了很多它的替代品，包括 ack, ag 和 rg。它们都特别好用，但是功能也都差不多，我比较常用的是 ripgrep (rg) ，因为它速度快，而且用法非常符合直觉。例子如下：
# 查找所有使用了 requests 库的文件
rg -t py 'import requests'
# 查找所有没有写 shebang 的文件（包含隐藏文件）
rg -u --files-without-match "^#!"
# 查找所有的foo字符串，并打印其之后的5行
rg foo -A 5
# 打印匹配的统计信息（匹配的行和文件的数量）
rg --stats PATTERN
EOF

:<<EOF
查找shell命令
随着用shell越久，可能要查找之前输入过的命令
1向上方向键
2history | grep command
可以修改 shell history 的行为，例如，如果在命令的开头加上一个空格，它就不会被加进shell记录中。当你输入包含密码或是其他敏感信息的命令时会用到这一特性。 
为此你需要在.bashrc中添加HISTCONTROL=ignorespace
或者向.zshrc 添加 setopt HIST_IGNORE_SPACE。 如果你不小心忘了在前面加空格，可以通过编辑。bash_history或 .zhistory 来手动地从历史记录中移除那一项。
3Ctrl+R 输入子串进行匹配，查找历史命令行，反复按就会在所有搜素结果中循环，在 zsh中，使用方向键上或下也可以完成这项工作。
4Ctrl+R 可以配合 fzf 使用。fzf 是一个通用对模糊查找工具，它可以和很多命令一起使用。
5基于历史的自动补全，zsh可以使用极大提高用户体验
EOF

:<<EOF
文件夹导航
如何才能高效地在目录 间随意切换呢？有很多简便的方法可以做到，比如设置alias，使用 ln -s创建符号连接等。而开发者们已经想到了很多更为精妙的解决方案。
可以使用fasd和autojump这两个工具来查找最常用或最近使用的文件和目录，Fasd 基于 frecency对文件和文件排序，也就是说它会同时针对频率（frequency ）和时效（ recency）进行排序
例如， 如果您经常访问/home/user/files/cool_project 目录，那么可以直接使用 z cool 跳转到该目录。对于 autojump，则使用j cool代替即可。
EOF
