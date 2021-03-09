%% PhasorTool��ʾ
clear;
clc;
warning off
%% 1. phasor����/��·���/�������ʽչʾ
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
disp('�����ѹ����Ϊ ');vo %#ok
disp(['�����ѹ��ʱ����ʽΪ ' , vo.sine(1)]);
disp(['�����ѹ������latex���ʽΪ ' , vo.platex('V')]);

%% 2. phasor����/ʱ����/ʱ����ʽ/����latex���ʽ
pc = p([1+1j,1;-1,2+1j]);
pc_sin_func = pc.sin_func;
x = 0:.1:10;
y = pc_sin_func(x);
y = reshape(y,4,[]).';
figure()
plot(x,y)
pc_sin_plain_text = pc.sine(1,'V'); % ʱ������
pc_latex = pc.platex('A'); % ����latex
temp(1:2,1) = pc_sin_plain_text(1:2);
temp(3:4,1) = pc_latex(3:4);
legend(temp)
title('phasor is powerful!')

%% 3. ����ͼ
p1 = p(4,147.5);
p2 = p(9,60);
pc = [p1,p2];
figure()
pc.pplot
title('It''s time to win!')