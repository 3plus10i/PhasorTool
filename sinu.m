% 根据(有效值)相量输出正弦表达式
function e = sinu(p1,w,u)
% p1: phasor
% w: double, frequency(rad/s)
% u: char array, unit
% e: char array
if nargin<3
    u='';
end
k=sqrt(2);
A = num2str(round(p1.m*k,2));
t1 = 'cos(';
if w==1
    w='';
else
    w = num2str(w);
end
t2 = 't';
if p1.a>=0, t2 = [t2,'+']; end
a = num2str(round(p1.a,2));
u = [') ',u];
e = [A,t1,w,t2,a,u];
end