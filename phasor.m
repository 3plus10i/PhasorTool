% 2020年6月20日
%   全面支持基本矩阵运算，以后可以应用相量矩阵进行运算了
%   增加pm方法（phasor matrix），矩阵处理更灵活了
%   取消对外部isphasor.m的依赖，提高了可移植性
%   增加了platex方法，可输出相量的latex表达式，方便编辑文档
%   增加了常用platex方法dispv和dispi，方便使用
%   集成时域形式的latex表达式方法sine()，提高了可移植性
%   优化了方法sine()，提高了效率
%   方法sine()支持相量矩阵

% 2020年9月24日
%	为乘法计算增加计算功率时的共轭提示
%	为sine()方法增加有效值提示
%	为创建相量方法增加确认相位提示
%   真的避免了对外部isphasor.m的依赖，提高了可移植性
%   增加了slatex()方法，可以省去用sine()时的最后一个参数

% 2020年12月8日
%   增加sin_fun()方法，可将相量转化为时域函数
%   增加matrix tools，提高矩阵兼容性（虽然没啥用）
%   提高多个方法的矩阵兼容性
%   优化注释

% 2021年3月9日
%   \;的兼容太差了，为了兼容性，不要这个空格了也无妨

classdef phasor
    properties
        m % magnitude
        a % angle (degree)
        x % real part
        y % image part
        c % complex
    end
    
    %% >> constructor & disp
    methods
        function self = phasor(m,a)
            % Create a phasor.
            % Input can be
            %     1.(viod);
            %     2.number, phasor, or matrice of them;
            %     3.(m,a), (x,y(y=a+bi)), or matrices of them.
            if nargin == 0
                c = 0+1j*0;
            elseif nargin == 1
                if phasor.isphasor(m)
                    self = m;
                    return
                elseif isnumeric(m) % most convenient way
                    c = m;
                elseif iscell(m) % who would use this strange initial value?
                    idx = findp(m);
                    self(idx) = m{idx};
                    self(~idx).c = complex(m{~idx});
                    self = self.c2p();
                    return
                end
            else
                % compatible with matrix
                if imag(a) == 0
					warning('请注意确认所创建相量的时域相位和函数名(cos/sin)')
                    c = m.*exp(1j*a*pi/180);
                else  % x+y
                    c = m+a;
                end
            end
            self = self.c2p(c);
        end
        
        function disp(self)
            % display phasor in Magnitude<Angle
            for ii=1:size(self,1)
                for jj=1:size(self,2)
                    fprintf('% 4.2f<%4.2fdeg  ',self(ii,jj).m,self(ii,jj).a);
                end
                fprintf('\n');
            end
        end
        
    end % of methods
    
    %% >> basic tools
    methods(Static)
        function flag = isphasor(p1)
            flag = isa(p1,'phasor');
        end
    end
    
    methods
        
        % update or synchronise phasor
        function self = c2p(self,c)
            % f(c) -> m,a,x,y
            if nargin==1 || isempty(c)
                % use p = p.c2p() to UPDATE phasor from p.c.
                % so that m/a/x/y could be cooresponding value.
                c = self.cm;
            end
            if phasor.isphasor(c)
                % use p = p.c2p(c) to BUILD a new phasor p from phasor c.
                % size(p) == size(c)
                c = reshape([c.c],size(c));
            end
            for ii = 1:size(c,1)
                for jj = 1:size(c,2)
                    self(ii,jj).c = c(ii,jj);
                    self(ii,jj).x = real(c(ii,jj));
                    self(ii,jj).y = imag(c(ii,jj));
                    self(ii,jj).m = abs(c(ii,jj));
                    self(ii,jj).a = angle(c(ii,jj))/pi*180;
                end
            end
        end
        
        % Find logical index of phasors in array
        function idx = findp(vars)
            if isnumeric(vars)
                idx = false(size(vars));
            elseif phasor.isphasor(vars)
                idx = true(size(vars));
            elseif iscell(vars)
                idx = false(size(vars));
                for ii=1:numel(vars)
                    if phasor.isphasor(vars{ii})
                        idx(ii) = true;
                    end
                end
            end
        end    
    end
    
    %% >> matrix tools
    % 成员变量后面加上m就成为矩阵
    methods
        % 复数
        function self_cm = cm(self)
            % matrice = phasor.cm
            % extract complex matrice from phasor matrice
            self_cm = reshape([self.c],size(self));
        end
        
        % 模值
        function self_mm = mm(self)
            self_mm = reshape([self.m],size(self));
        end
        
        % 相角
        function self_am = am(self)
            self_am = reshape([self.a],size(self));
        end
        
        % 实部
        function self_xm = xm(self)
            self_xm = reshape([self.x],size(self));
        end
        
        % 虚部
        function self_ym = ym(self)
            self_ym = reshape([self.y],size(self));
        end
        
    end
        
    %% >> basic calculation
    methods
        
        function pr = plus(p1,p2)
            % +
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1+p2);
        end
 
        function pr = minus(p1,p2)
            % -
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1-p2);
        end
        
        function pr = uminus(p)
            % - 
            pr = phasor(-p.cm);
        end
        
        function pr = times(p1,p2)
            % .*
			warning('如果您在计算功率，请确保电流已共轭')
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1.*p2);
        end
        
        function pr = mtimes(p1,p2)
            % *
			warning('如果您在计算功率，请确保电流已共轭')
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1*p2);
        end
        
        function pr = rdivide(p1,p2)
            % ./
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1./p2);
        end
        
        function pr = mrdivide(p1,p2)
            % /
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1/p2);
        end
        
        function pr = mldivide(p1,p2)
            % \
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1\p2);
        end
        
        function pr = ldivide(p1,p2)
            % .\
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1.\p2);
        end
        
        function pr = ctranspose(p)
            % ' ctranspose 复共轭转置
            % 在计算功率时，如果p.cm是标量，可以用这个运算对电流相量共轭
            pr = phasor(p.cm');
        end
        
        function pr = transpose(p)
            %.' 转置
            pr = phasor(p.cm.');
        end
        
        function pr = conj(p)
            pr = phasor(conj(p.cm));
        end
        
    end % of methods
    
    %% >> shunt
    methods
        % 并联运算(Static)
        % |优先级太低，在不使用括号指定的情况下进行混合运算极容易出错。
        % 建议还是另外加个文件比较好。。
        function pr = sh(varargin)
            % shunt: pr = p1.sh(p2,p3)
            sum = 0;
            for p1 = varargin
                sum = sum + 1./p1{1};
            end
            pr = phasor( 1./sum );
        end
        
    end
    
    %% >> special series
    methods
        % 输出相量的latex表达
        function latex_str = platex(self,u)
            % 考虑到单位和可能的及早求值机制，还是作为方法。
            if nargin == 2
                % 矩阵兼容性：p可以为矩阵，但u只能为一个字符。
                %   不支持为矩阵形p中不同元素指定不同单位
%                 u = ['\;{\rm{',u,'}}'];
                u = ['\rm{',u,'}'];  % \;的兼容太差了
            else
                u = '';
            end
            if numel(self) == 1
                latex_str = [num2str(round(self.m,2)),...
                    '\angle',num2str(round(self.a,2)),'\circ',u ];
            else
                latex_str = cell(size(self));
                for idx = 1:numel(self)
                    latex_str{idx} = [num2str(round(self(idx).m,2)),...
                        '\angle',num2str(round(self(idx).a,2)),'\circ',u ];
                end
            end
        end
        
        % 为方便使用platex，集成两个常用形式
        % 对相量矩阵，v(:).dispv; 是个有用的表达
        function e = dispv(self)
            e = platex(self,'V');
            disp(platex(self,'V'));
        end
        function e = dispi(self)
            e = platex(self,'A');
            disp(platex(self,'A'));
        end
        
        % 根据(有效值)相量输出正弦表达式，可选是否latex格式
        % 注意！需要特别小心要处理的对象是否是有效值相量！
        function e = sine(self,w,unit,islatex)
			warning('请注意确认要处理的对象是否是有效值相量')
            % p.sine(314,'V')
            % w double 频率（缺省为1）,size(w)==size(self)
            % u char 单位（缺省为空）
            % islatex ture/latex 使输出latex表达式（缺省为false）
            if nargin==4
                % 矩阵兼容性：islatex可以为矩阵，但只要触发真值条件即全为真
                %   不支持为矩阵形p中不同元素指定各自是否输出latex表达式
                % 矩阵兼容性：p可以为矩阵，但u只能为一个字符。
                %   不支持为矩阵形p中不同元素指定不同单位
                islatex = any(islatex) || strcmpi(islatex,'latex');
            elseif nargin==3
                if strcmpi(unit,'latex') % 判断含有self和islatex
                    islatex = true;
                    if ischar(w) % 判断含有unit，w被省略
                        unit=w;
                        w=1;
                    else % 判断含有w，unit被省略
                        unit='';
                    end
                else % 判断含有self和w和unit
                    islatex = false;
                end
            elseif nargin==2
                if strcmpi(w,'latex') % 判断只含有self和islatex
                    islatex = true;
                    unit='';
                    w=1;
                elseif ischar(w) % 判断含有unit，w和islatex被省略
                    unit=w;
                    w=1;
                    islatex = false;
                else % 判断含有w,unit和islatex被省略
                    unit='';
                    islatex = false;
                end
            elseif nargin==1
                w=1;
                unit='';
                islatex = false;
            end
            
            % A cos( w t + phi ) u
            % - ---- - - - --- ---
            if ~islatex
                cos_parenthesis = 'cos(';
                unit = [') ',unit];%标量
            else
                cos_parenthesis = '\cos\left(';
                if ~isempty(unit)
                    % MathType会自动为\circ添加上标记号
%                     unit = ['\circ \right)\; {\rm{',unit,'}}'];
                    unit = ['\circ \right)\rm{',unit,'}'];  % \;的兼容太差了
                else
                    unit = ['\circ \right)'];%#ok
                end
            end
            if numel(self)==1
                A = num2str(round(self.m*sqrt(2),2));
                if w==1
                    w='';% 频率为1不用显示
                else
                    w = num2str(w);
                end
                angle_char = num2str(round(self.ad,2));
                if self.a>=0
                    t_and_sign = 't+';
                else
                    t_and_sign = 't';
                end
                e = [A,cos_parenthesis,w,t_and_sign,angle_char,unit];
                
            else % 对于输入为相量矩阵的情况
                % 将数值矩阵转化为字符细胞数组
                arrnum2str = @(x)arrayfun(@num2str,x,'UniformOutput',false);
                A = arrnum2str(round(self.mm*sqrt(2),2));%细胞
                if w==1
                    w={''};% 频率为1不用显示
                elseif numel(w)==1
                    w={num2str(w)};
                elseif numel(w)~=numel(self)
                    error('频率与相量数目不匹配！')
                else
                    w = arrnum2str(w);
                end
                angle_char = arrnum2str(round(self.ad,2));%细胞
                
                e = cell(size(self));
                for idx = 1:numel(self)
                    if self(idx).a>=0
                        t_and_sign = 't+';
                    else
                        t_and_sign = 't';
                    end
                    e{idx} = [A{idx},cos_parenthesis,...
                        w{min(idx,length(w))},...
                        t_and_sign,angle_char{idx},unit];
                end
            end
        end
        
        % 如果执意要用latex格式，可以直接用这个函数
        function e = slatex(self,w,unit)
            if nargin==2
                if ischar(w) % 判断含有unit，w被省略
                    unit=w;
                    w=1;
                else % 判断含有w,unit被省略
                    unit='';
                end
            elseif nargin==1
                w=1;
                unit='';
            end
            
            e = sine(self,w,unit,'latex');
        end
        
        % 将相量转化为指定频率的时域函数
        % 2020年12月8日 开发中
        function f = sin_func(self,w)
            if nargin == 1
                % 默认频率为w=1
                w = 1;
            end
            if numel(self) ~= numel(w) && numel(w)>1
                error('输入的频率与相量规模不匹配！')
            end
            warning('请注意确认要处理的对象是否是有效值相量')
            % A cos( w t + phi )
            A = self.mm*sqrt(2);
            phi = self.ar();
            if numel(self) == 1
                f = @(t)A.*cos(w.*t + phi);
            else
                % 矩阵兼容
                % 一定程度上牺牲了可读性
                f = @(t)cell2mat(arrayfun( @(t)A.*cos(w.*t + phi),...
                    reshape(t,[ones(1,ndims(self)),numel(t)]),...
                    'UniformOutput',false));
            end
        end
        
        % 兼容早期版本
        function e = sinu(self,w,u,islatex)
            e = sine(self,w,u,islatex);
        end
        
    end % of methods
    %% >> 向量图
    methods
        % 绘制向量图
        function fh = pplot(self)
            fh = compass([self.xm].',[self.ym].');
            for i=1:numel(self)
                text(self(i).x, self(i).y, ['p',num2str(i)]);
            end
        end
    end % of methods
    
    %% >> angle stuff
    methods
        function a_rad = ar(self)
        % return angle in rad
            a_rad = self.am/180*pi;
        end
        
        function a_deg = ad(self)
        % return angle in deg (=p.a)
            a_deg = self.am;
        end
    end % of methods
    
end % of class

