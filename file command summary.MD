# 常用文件管理命令
linux命令格式：**命令 -选项 参数** （选项和参数可为空）,**命令 --help或命令 -h及man 命令**是查看命令的好帮手
+ ctrl c: 取消命令，并且换行
+ ctrl u: 清空本行命令
+ ctrl l: 清屏
+ ctrl r: 搜索历史命令
+ ctrl q: 退出
+ \>: 将文本清空并写入
+ \>>: 追加到文本
+ |: 管道命令
+ tab键：可以补全命令和文件名，如果补全不了快速按两下tab键，可以显示备选选项
+ ls: 列出当前目录下所有文件，蓝色的是文件夹，白色的是普通文件，绿色的是可执行文件
+ pwd: 显示当前路径
+ cd XXX: 进入XXX目录下, cd .. 返回上层目录
+ cp XXX YYY: 将XXX文件复制成YYY，XXX和YYY可以是一个路径，比如../dir_c/a.txt，表示上层目录下的dir_c文件夹下的文件a.txt
+ mkdir XXX: 创建目录XXX
+ rm XXX: 删除普通文件;  rm XXX -r: 删除文件夹
+ mv XXX YYY: 将XXX文件移动到YYY，和cp命令一样，XXX和YYY可以是一个路径；重命名也是用这个命令
+ touch XXX: 创建一个文件
+ cat XXX: 展示文件XXX中的内容
+ file xxx: linux文件类型不是靠后缀分，查看文件基本数据
+ head xxx -n number:展示文件xxx前number行
+ tail xxx -n number:展示文件xxx最后number行
+ more xxx:less 按页或按窗口打印文件内容，ctrl+F/B先前/后翻页
+ less xxx:less 按页或按窗口打印文件内容，ctrl+F/B先前/后翻页
+ wc xxx:统计文件中行数子数等
+ grep word xxx:在文件xxx中查找word
+ find location xxx:在location中找xxx 如find . -name "*.c"
+ diff x y:展示x和y文件的不同
+ 复制文本
    windows/Linux下：Ctrl + insert，Mac下：command + c
+ 粘贴文本
    windows/Linux下：Shift + insert，Mac下：command + v
+ top:显示当前系统中耗费资源最多的进程
+ date:系统当前时间
+ ps:process status 很少单独使用，常ps -ef或ps -aux，分别表示全格式显示所有进程或显示无控制终端的进程
+ kill pid:杀掉pid号为pid的进程
+ gzip:gzip (-d) file.gz（解）压 
+ tar:tar -zcvf file.tar.gz file 压缩 tar -zxvf file.tar.gz解压
+ su:switch user,su root
+ chown:change owner,chown -R user1:group1 filedir(改用户和组)
+ chmod:change mode,chmod u+r file.txt(u、g、o、a分别表示用户、组、其他用户、所有用户、(rwx分别读写执行)
+ df/du: disk free和disk usage
+ wget url: 下载
+ uname: 系统信息
+ echo:输出文本，不用""