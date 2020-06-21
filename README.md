# PhasorTool
基于MATLAB的轻量化相量计算和显示工具。方便电路学习者和研究者进行快速计算和纸面作业。想到即可写，写出即可得。

# 简介
## 1. 下载与安装
下载phasor.m并将其添加到MATLAB路径即可。

同时下载和添加p.m将便于使用，但对功能没有影响。
p.m可以让你避免大量输入“phasor”，例如在创建一个相量时，原始语句为：
` myphasor = phasor(1+1j); `，
p.m允许你简化命令为：
` myphasor = p(1+1j); `。
这在很多情况下可以简化编程。



## 2.  _phasor_ 是什么？
相量是电路分析中一种表示正弦量的方式，使用相量可以简化对正弦稳态电路的计算。

 _phasor_ 构造了一种MATLAB类，称为phasor类。它封装了相量的一些基本属性，重载了以相量为对象的MATLAB基本运算，实现了一些常用的相量特有计算和表示方式。
使用 _phasor_ 对象，正弦稳态电路的计算和展示将变得非常容易。
自然地创建和运算方式使得相量计算可以简洁的表出，而大多数相量计算都可以在写成表达式后立即计算和展示结果。
所谓 _想到即可写_ ，_写出即可得_。

除了常见的四则运算和并联计算，特别介绍 _phasor_ 类的` platex `方法和` sine `方法，
前者可以输出相量的LaTeX表达式，后者可以输出相量在时域表达式的LaTeX表达式。
使用这些方法可以方便地将相量插入文字处理软件中，轻松撰写涉及相量的格式化文档。

本项目在电路分析的学习、教学和研究方面都有一定帮助。



## 3. 一些约定
+ 相角默认使用 __角度制__ 。如果需要使用弧度制相角，则应该额外进行换算或使用p.ar方法。
+ 相量默认为 __有效值相量__ 。当涉及到时域表达式时，要特别小心有效值和最大值的区别。
+ 复数指double型和complex型。由于数学上的复数是实数的超集，因此不再特别区分数值数组的double型和complex型。


# 开始使用
## 0.  _phasor_ 的成员变量
目前 _phasor_ 有5个成员变量

- m：相量幅值
- a：相量相角
- x：相量对应复数的实部
- y：相量对应复数的虚部
- c：相量对应的复数



## 1. 创建相量
  _phasor_ 提供了多种初始化方式

1.使用幅值和相角	` p1 = p(2,30) `

2.使用复数		` p1 = p(sqrt(3)+1j) `

3.使用实部和虚部	` p1 = p(sqrt(3)+1j) `

以上三种方法都将在命令行显示同一个相量` p1 = 2.00<30.00deg `。

可以使用复数矩阵初始化相量矩阵，语句 ` p1 = p([1,2;3,4]) `将创建一个2x2 _phasor_ 矩阵



## 2. 相量的加减乘除
_phasor_ 重载了复数型的加减乘除法，同时包括点乘/矩阵乘法和点除/矩阵除法（求逆），其中除法包括左除和右除。

_phasor_ 可以与另一个 _phasor_ 对象进行四则运算，也可以与复数（或规模匹配的矩阵）进行运算。



## 3. 复阻抗的并联
虽然阻抗在严格意义上并不是相量，但是由于其在计算时与电压电流相量关系密切，并且本质上也是一个复数，因此 _phasor_ 设计了阻抗并联计算方法。

使用sh()方法计算两个 _phasor_ 阻抗的并联(shunt)  ` ps = sh(p1,p2) `

p1和p2中至少有一个是 _phasor_ 即可使用sh方法。

sh方法兼容 _phasor_ 矩阵



## 4. 相量的LaTex表达式
使用platex方法计算 _phasor_ 的LaTex表达式

` latex_p1 = p1.platex('A') `

将得到类似于这样的LaTex表达式

` latex_p1 = '2\angle30\circ\;{\rm{A}}' `

输入Mathtype的显示效果

![](http://latex.codecogs.com/gif.latex?2\angle30^\circ{\rm{A}})

> 由于Mathtype对LaTex解析的一些小“特性”，platex方法生成的LaTex表达式虽然适用于Mathtype，但却可能在其他编译器下显示异常。

为方便使用platex， _phasor_ 集成了两个常用形式

+ ` p1.dispv `将使用单位"V"显示相量p1，返回值与` p1.platex('V') `相同，但是dispv同时将结果输出到命令行。
+ ` p1.dispi `将使用单位"A"显示相量p1，返回值与` p1.platex('A') `相同，但是dispi同时将结果输出到命令行。

platex方法兼容 _phasor_ 矩阵

## 5. 相量对应的时域表达式
使用sine方法计算 _phasor_ 的时域表达式

` sine_p1 = p1.sine(314,'A') `

将得到类似于这样的时域表达式字符数组

` sine_p1 = '2.83cos(314t+30) A' `

 __注意__ ：时域表达式中，cos的系数为相量幅值的√2倍。

在sine方法中，频率w和单位unit各自都可以省略。频率w的默认值为1，单位unit的默认值为空字符。

sine方法兼容 _phasor_ 矩阵（大概



## 6. 相量对应的时域表达式的LaTex表达式
使用sine方法计算 _phasor_ 的时域表达式的LaTex表达式

` sine_latex_p1 = p1.sine(314,'A','latex') `

将得到类似于这样的时域表达式字符数组

` sine_latex_p1 = '2.83\cos\left(314t+30\circ \right) \;{\rm{A}}' `

输入Mathtype的显示效果

![](http://latex.codecogs.com/gif.latex?2.83\cos\left(314t+30^\circ\right){\rm{A}})

> 由于Mathtype对LaTex解析的一些小“特性”，sine方法生成的LaTex表达式虽然适用于Mathtype，但却可能在其他编译器下显示异常。

在有‘latex’参数的sine方法中，频率w和单位unit各自都可以省略。频率w的默认值为1，单位unit的默认值为空字符。

sine方法兼容 _phasor_ 矩阵（大概



# 实例
//TODO