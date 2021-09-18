# tmux
## 基本概念
### 功能：
+ 分屏。
+ 可以连接本地或远程的 sessions
+ 允许断开Terminal连接后，继续运行进程。
### 结构
一个tmux(被设计c/s结构，启动session实际是client,server在服务器)可以包含多个session，一个session可以包含多个window，一个window可以包含多个pane。

![tmux结构](pic/tmux结构.png)
![结构](pic/结构.jpg)
### 配置
tmux 的配置文件位于 $HOME/.tmux.conf (以及一个全局的 /etc/tmux.conf)。在配置文件中可设置**前缀**
### 常用操作
prefix - ? 可以随时查看快捷键列表
+ tmux：新建session，含一window，window含一pane，pane打开一shell。
+ tmux a：打开之前挂起的session。
+ Ctrl + a % 左右平分成两pane。
+ Ctrl + a " 上下平分成两个pane。
+ 按住ctrl + a的同时按方向键，可调整panel尺寸。
+ 鼠标拖动pane之间的分割线，可以调整分割线的位置。
+ Ctrl + d：关闭当前pane或window或ession。
+ 鼠标点击可以选pane。
+ ctrl + a，然后按方向键：选择相邻的pane。
+ ctrl + a o 顺序跳转panel
+ ctrl + a q num 选择编号num的panel
+ ctrl + a s：选择其它session。
    + 方向键 —— 上：选择上一项 session/window/pane
    + 方向键 —— 下：选择下一项 session/window/pane
    + 方向键 —— 右：展开当前项 session/window
    + 方向键 —— 左：闭合当前项 session/window
+ ctrl + a z：将当前pane全屏/取消全屏。
+ ctrl + a d：挂起当前session。
+ Ctrl + a c：在当前session中创建一个新的window。
+ Ctrl + a w：选择其他window，操作方法与(12)完全相同。
+ Ctrl + a &：关闭当前窗口。
+ Ctrl + a 1-9：切换到指定窗口
+ Ctrl + a p：切换的上一个窗口。
+ Ctrl + a n：切换到上一个窗口。
+ Ctrl + a l：在前后两个窗口之间切换。
+ Ctrl + a , 重命名当前窗口；这样便于识别
+ Ctrl + a f	在所有窗口中查找指定文本
+ Ctrl + a PageUp：翻阅当前pane内的内容。
+ 鼠标滚轮：翻阅当前pane内的内容。
+ 在tmux中选中文本时，需要按住shift键。（仅支持Windows和Linux，不支持Mac，不过该操作并不是必须的，因此影响不大）
+ tmux中复制/粘贴文本的通用方式：
    + 按下Ctrl + a后松开手指，然后按[
    + 用鼠标选中文本，被选中的文本会被自动复制到tmux的剪贴板
    + 按下Ctrl + a后松开手指，然后按]，会将剪贴板中的内容粘贴到光标处

# vim


