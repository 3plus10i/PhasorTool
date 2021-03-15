# PhasorTool
基于MATLAB的轻量化相量计算和显示工具。方便电路学习者和研究者进行快速计算和纸面作业。想到即可写，写出即可得。

# 简介
## 1. 下载与安装
下载phasor.m并将其添加到MATLAB路径即可。

同时下载和添加p.m将便于使用，但对功能没有影响。
p.m可以让你避免大量输入“phasor”，例如在创建一个相量时，原始语句为：
` myphasor = phasor(1+1j); `，
p.m允许你简化语句为：
` myphasor = p(1+1j); `。

同时下载和添加sh.m将便于使用，但对功能没有影响。
sh.m可以让你避免在并联计算时把第一个参数写在外面。例如在计算多个变量的并联时，原始语句为：
` shunt_phasor = p1.sh(p2, 1+1j, 3); `，
sh.m允许你将表达式写为为：
` shunt_phasor = sh(p1, p2, 1+1j, 3); `。


这在很多情况下可以简化编程。



## 2.  _phasor_ 是什么？
相量是电路分析中一种表示正弦量的方式，使用相量可以简化对正弦稳态电路的计算。

 _phasor_ 构造了一种MATLAB类，称为 _phasor_ 类。它封装了相量的一些基本属性，重载了以相量为对象的MATLAB基本运算，实现了一些常用的相量特有计算和表示方式。
使用 _phasor_ 对象，正弦稳态电路的计算和展示将变得非常容易。
自然地创建和运算方式使得相量计算可以简洁的表出，而大多数相量计算都可以在写成表达式后立即计算和展示结果。
所谓 _想到即可写_ ，_写出即可得_。

除了常见的四则运算和并联计算，特别介绍 _phasor_ 类的` platex `方法和` sine `方法，
前者可以输出相量的LaTeX表达式，后者可以输出相量在时域表达式的LaTeX表达式。
使用这些方法可以方便地将相量插入文字处理软件中，轻松撰写涉及相量的格式化文档。

本项目在电路分析的学习、教学和研究方面都有一定帮助。



## 3.  _phasor_ 的成员变量
目前 _phasor_ 有5个成员变量

- m：相量幅值
- a：相量相角
- x：相量对应复数的实部
- y：相量对应复数的虚部
- c：相量对应的复数



## 4. 一些约定
+ 相角默认使用 __角度制__ 。如果需要使用弧度制相角，则应该额外进行换算或使用p.ar方法。
+ 相量默认为 __有效值相量__ 。当涉及到时域表达式时，要特别小心有效值和最大值的区别。
+ 复数指double型和complex型。由于数学上的复数是实数的超集，因此不再特别区分数值数组的double型和complex型。



# 开始使用
## 1. 创建相量
  _phasor_ 提供了多种初始化方式

1.使用幅值和相角	` p1 = p( 2,30 ) `

2.使用复数		` p1 = p( sqrt(3)+1j ) `

3.使用实部和虚部	` p1 = p( sqrt(3), 1j ) `

以上三种方法都将在命令行显示同一个相量` p1 = 2.00<30.00deg `。

可以使用复数矩阵初始化相量矩阵，语句 ` p1 = p([1+1j,-1;-1,2+1j]) `将创建一个2x2 _phasor_ 矩阵。



## 2. 相量的基本运算
_phasor_ 重载了复数型的加减乘除法，同时包括点乘/矩阵乘法和点除/矩阵除法（求逆），其中除法包括左除和右除。

_phasor_ 可以与另一个 _phasor_ 对象进行四则运算，也可以与复数（或规模匹配的矩阵）进行运算。

关于 _phasor_ 矩阵：在相量矩阵的成员变量名后加'm'将得到矩阵形式的成员，否则得到的是所有单个相量的成员列表。例如：

` pm = p( [1+2j, 3; 0.5-1j, 4j] );  `

` pm.mm == [2.2361    3.0000 `

&emsp;&emsp;&emsp;&emsp;&emsp;` 1.1180    4.0000] `



## 3. 复阻抗的并联
虽然阻抗在严格意义上并不是相量，但是由于其在计算时与电压电流相量关系密切，并且本质上也是一个复数，因此 _phasor_ 设计了阻抗并联计算方法。

使用sh方法计算若干个 _phasor_ 阻抗或复数的并联(shunt)  ` ps = p1.sh(p2, 3+4j, 5) `

在上例中，由于p1也是被并联的阻抗之一，将p1作为显式函数的形式其实更符合习惯：

` ps = sh(p1, p2, 3+4j, 5) `

这也是我强烈推荐在当前工作目录加入` sh.m `的原因。

sh方法/函数兼容 _phasor_ 矩阵输入。

## 4. 相量的LaTeX表达式
使用platex（phasor latex）方法计算 _phasor_ 的LaTeX表达式

方法原型：` latex_str = platex(self,u) `
> u:str 单位; 返回latex_str:str latex表达式字符串

例如：表达式` p1.platex('A') `将返回类似于这样的LaTeX表达式：

` '2\angle30\circ\rm{A}' `

输入Mathtype的显示效果

![](http://latex.codecogs.com/gif.latex?2\angle30^\circ\rm{A})


为方便使用platex， _phasor_ 集成了两个常用形式:

+ ` p1.dispv `将使用单位"V"显示相量p1，返回值与` p1.platex('V') `相同，但是dispv同时将结果输出到命令行。
+ ` p1.dispi `将使用单位"A"显示相量p1，返回值与` p1.platex('A') `相同，但是dispi同时将结果输出到命令行。

在希望将结果输出到命令行的场合，` p1.dispv; `将是一个有用的表达。


platex方法兼容 _phasor_ 矩阵输入，输出将为元胞数组。

## 5. 相量对应的时域表达式/时域函数
1. 使用sine方法计算 _phasor_ 的时域表达式字符串

	方法原型：` e = sine(self,w,unit,islatex) `
	> w:double 频率; unit:str 单位; islatex:bool latex模式开关; 返回e:str时域表达式字符串

	例如：表达式` p1.sine(314,'A') `将返回类似于这样的时域表达式：

	` '2.83cos(314t+30) A' `

	 __注意__ ：时域表达式中一律使用`cos`函数，且cos的系数为相量幅值的√2倍。

	在sine方法中，频率w和单位unit各自都可以省略。频率w的默认值为1，单位unit的默认值为空字符。

	sine方法兼容 _phasor_ 矩阵

2. 使用sin_func方法计算 _phasor_ 的时域函数

	方法原型：f = sin_func(self,w)
	> w:double 频率; 返回f:function_handle 时域函数句柄

	例如，表达式` p1.sin_func(314) `将返回类似于这样的时域函数句柄

	` 包含以下值的 function_handle: @(t)A.*cos(w.*t+phi)`
	
	 __注意__ ：时域表达式中一律使用`cos`函数，且cos的系数为相量幅值的√2倍。

	在sin_func方法中，频率w可以省略。频率w的默认值为1。

	sin_func方法兼容 _phasor_ 矩阵

## 6. 相量对应的时域表达式的LaTeX表达式
	
之前提到，sine方法的最后一个参数`islatex`可以控制sine方法输出的是字面表达式还是latex表达式。你可以利用sine方法计算 _phasor_ 的时域表达式的LaTeX表达式：

` sine_latex_p1 = p1.sine(314,'A','latex') `

得到的sine_latex_p1为类似于这样的时域表达式字符数组

` sine_latex_p1 = '2.83\cos\left(314t+30\circ \right)\rm{A}' `

输入Mathtype的显示效果

![](http://latex.codecogs.com/gif.latex?2.83\cos\left(314t+30^\circ\right)\rm{A})


在有`islatex`参数的sine方法中，频率w和单位unit各自都可以省略。频率w的默认值为1，单位unit的默认值为空字符。

>这里的`islatex`参数实际上是布尔值，任何使得`any(x)==true`的`x`都等效于`'latex'`。但是如果省略了频率w或单位unit，则只有`'latex'`可以被正确解析。因此建议总是使用`'latex'`作为参数。

显然，`'latex'`五个字母太长了。为了方便使用，增设了slatex方法。例如，上述命令可以等价地写为

` sine_latex_p1 = p1.slatex(314,'A') `

> 由于Mathtype对LaTex解析的一些小“特性”，sine/slatex方法生成的LaTex表达式虽然适用于Mathtype，但却可能在其他编译器(例如MATLAB自带的interpreter)下显示异常。

slatex方法兼容 _phasor_ 矩阵。

## 7. 相量图

提供了绘制相量图的功能。

方法原型：fh = pplot(self)
> 返回fh:Line对象

绘制一个以原点为中心的相量图。

pplot方法兼容 _phasor_ 矩阵。

# 实例
见 [demo.m](./demo.m)
