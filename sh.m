function r = sh(varargin)
% ��������ĵ���(�迹)
r = 0;
for i = varargin
    r = r + 1./i{1};
end
r = 1./r;