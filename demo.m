%% PhasorTool演示
clear;
clc;
warning off
%% 1. phasor运算/电路求解/相量表达式展示
vs = p(12,0);
p1 = sh(2,3j);
p2 = p(2+4j)+p(-1j);
A = [
    % is, io
    p1-1j, 1j;
    1j, p2;
];
b = [
    vs.c
    0
];
i = p(A\b);
vo = i(2)*2;
disp('输出电压相量为 ');vo %#ok
disp(['输出电压的时域表达式为 ' , vo.sine(1)]);
disp(['输出电压相量的latex表达式为 ' , vo.platex('V')]);

%% 2. phasor矩阵/时域函数/时域表达式/相量latex表达式
pc = p([1+1j,1;-1,2+1j]);
pc_sin_func = pc.sin_func;
x = 0:.1:10;
y = pc_sin_func(x);
y = reshape(y,4,[]).';
figure()
plot(x,y)
pc_sin_plain_text = pc.sine(1,'V'); % 时域字面
pc_latex = pc.platex('A'); % 相量latex
temp(1:2,1) = pc_sin_plain_text(1:2);
temp(3:4,1) = pc_latex(3:4);
legend(temp)
title('phasor is powerful!')

%% 3. 相量图
p1 = p(4,147.5);
p2 = p(9,60);
pc = [p1,p2];
figure()
pc.pplot
title('It''s time to win!')