function r = sh(varargin)
% 并联输入的电阻(阻抗)
r = 0;
for i = varargin
    r = r + 1./i{1};
end
r = 1./r;