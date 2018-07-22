# 某计算机原理实验夏季小学期综合实验一的代码

有用代码都是DOS上8088汇编代码。

## 实验一 D/A转换

汇编源代码文件为`11da.asm`，简单说下思路：就是将三种波形的一个周期内的数据都存在数据段，调整成周期一致，这样数组的长度就都一样，然后一个`offset`指针（对应程序中`BX`寄存器）和一个`base`指针（对应程序中`SI`寄存器），定时输出数据就行了。

使用的D/A转换器为DAC0832

正弦波、三角波、锯齿波的波形就可以通过`SinValue.jshell`脚本来生成。该脚本为jshell脚本，要运行需10及之后Java SE版本，使用其中的jshell工具执行。

## 实验二 D/A与A/D转换

源文件为`12ad.asm`，一次输出20组数据，产生的数据是混沌的，办法是在黑盒子函数调用后，执行一条`AAD`指令，原因自查代码自己想。文件中定义了两个函数：`prtnum`，`prthex`，分别用于将一个字节的无符号数以十进制输出和以十六进制输出。因为代码是实验前写的，开始以为要用十进制输出，所以写了`prtnum`函数，结果去做实验时助教要求按照十六进制输出，所以在实验室现写的`prthex`函数。总之就是这样。
