% 2020��6��20��
%   ȫ��֧�ֻ����������㣬�Ժ����Ӧ�������������������
%   ����pm������phasor matrix����������������
%   ȡ�����ⲿisphasor.m������������˿���ֲ��
%   ������platex�����������������latex���ʽ������༭�ĵ�
%   �����˳���platex����dispv��dispi������ʹ��
%   ����ʱ����ʽ��latex���ʽ����sine()������˿���ֲ��
%   �Ż��˷���sine()�������Ч��
%   ����sine()֧����������

% 2020��9��24��
%	Ϊ�˷��������Ӽ��㹦��ʱ�Ĺ�����ʾ
%	Ϊsine()����������Чֵ��ʾ
%	Ϊ����������������ȷ����λ��ʾ
%   ��ı����˶��ⲿisphasor.m������������˿���ֲ��
%   ������slatex()����������ʡȥ��sine()ʱ�����һ������

% 2020��12��8��
%   ����sin_fun()�������ɽ�����ת��Ϊʱ����
%   ����matrix tools����߾�������ԣ���Ȼûɶ�ã�
%   ��߶�������ľ��������
%   �Ż�ע��

% 2021��3��9��
%   \;�ļ���̫���ˣ�Ϊ�˼����ԣ���Ҫ����ո���Ҳ�޷�

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
					warning('��ע��ȷ��������������ʱ����λ�ͺ�����(cos/sin)')
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
    % ��Ա�����������m�ͳ�Ϊ����
    methods
        % ����
        function self_cm = cm(self)
            % matrice = phasor.cm
            % extract complex matrice from phasor matrice
            self_cm = reshape([self.c],size(self));
        end
        
        % ģֵ
        function self_mm = mm(self)
            self_mm = reshape([self.m],size(self));
        end
        
        % ���
        function self_am = am(self)
            self_am = reshape([self.a],size(self));
        end
        
        % ʵ��
        function self_xm = xm(self)
            self_xm = reshape([self.x],size(self));
        end
        
        % �鲿
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
			warning('������ڼ��㹦�ʣ���ȷ�������ѹ���')
            if phasor.isphasor(p1),p1 = p1.cm;end
            if phasor.isphasor(p2),p2 = p2.cm;end
            pr = phasor(p1.*p2);
        end
        
        function pr = mtimes(p1,p2)
            % *
			warning('������ڼ��㹦�ʣ���ȷ�������ѹ���')
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
            % ' ctranspose ������ת��
            % �ڼ��㹦��ʱ�����p.cm�Ǳ������������������Ե�����������
            pr = phasor(p.cm');
        end
        
        function pr = transpose(p)
            %.' ת��
            pr = phasor(p.cm.');
        end
        
        function pr = conj(p)
            pr = phasor(conj(p.cm));
        end
        
    end % of methods
    
    %% >> shunt
    methods
        % ��������(Static)
        % |���ȼ�̫�ͣ��ڲ�ʹ������ָ��������½��л�����㼫���׳���
        % ���黹������Ӹ��ļ��ȽϺá���
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
        % ���������latex���
        function latex_str = platex(self,u)
            % ���ǵ���λ�Ϳ��ܵļ�����ֵ���ƣ�������Ϊ������
            if nargin == 2
                % ��������ԣ�p����Ϊ���󣬵�uֻ��Ϊһ���ַ���
                %   ��֧��Ϊ������p�в�ͬԪ��ָ����ͬ��λ
%                 u = ['\;{\rm{',u,'}}'];
                u = ['\rm{',u,'}'];  % \;�ļ���̫����
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
        
        % Ϊ����ʹ��platex����������������ʽ
        % ����������v(:).dispv; �Ǹ����õı��
        function e = dispv(self)
            e = platex(self,'V');
            disp(platex(self,'V'));
        end
        function e = dispi(self)
            e = platex(self,'A');
            disp(platex(self,'A'));
        end
        
        % ����(��Чֵ)����������ұ��ʽ����ѡ�Ƿ�latex��ʽ
        % ע�⣡��Ҫ�ر�С��Ҫ����Ķ����Ƿ�����Чֵ������
        function e = sine(self,w,unit,islatex)
			warning('��ע��ȷ��Ҫ����Ķ����Ƿ�����Чֵ����')
            % p.sine(314,'V')
            % w double Ƶ�ʣ�ȱʡΪ1��,size(w)==size(self)
            % u char ��λ��ȱʡΪ�գ�
            % islatex ture/latex ʹ���latex���ʽ��ȱʡΪfalse��
            if nargin==4
                % ��������ԣ�islatex����Ϊ���󣬵�ֻҪ������ֵ������ȫΪ��
                %   ��֧��Ϊ������p�в�ͬԪ��ָ�������Ƿ����latex���ʽ
                % ��������ԣ�p����Ϊ���󣬵�uֻ��Ϊһ���ַ���
                %   ��֧��Ϊ������p�в�ͬԪ��ָ����ͬ��λ
                islatex = any(islatex) || strcmpi(islatex,'latex');
            elseif nargin==3
                if strcmpi(unit,'latex') % �жϺ���self��islatex
                    islatex = true;
                    if ischar(w) % �жϺ���unit��w��ʡ��
                        unit=w;
                        w=1;
                    else % �жϺ���w��unit��ʡ��
                        unit='';
                    end
                else % �жϺ���self��w��unit
                    islatex = false;
                end
            elseif nargin==2
                if strcmpi(w,'latex') % �ж�ֻ����self��islatex
                    islatex = true;
                    unit='';
                    w=1;
                elseif ischar(w) % �жϺ���unit��w��islatex��ʡ��
                    unit=w;
                    w=1;
                    islatex = false;
                else % �жϺ���w,unit��islatex��ʡ��
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
                unit = [') ',unit];%����
            else
                cos_parenthesis = '\cos\left(';
                if ~isempty(unit)
                    % MathType���Զ�Ϊ\circ����ϱ�Ǻ�
%                     unit = ['\circ \right)\; {\rm{',unit,'}}'];
                    unit = ['\circ \right)\rm{',unit,'}'];  % \;�ļ���̫����
                else
                    unit = ['\circ \right)'];%#ok
                end
            end
            if numel(self)==1
                A = num2str(round(self.m*sqrt(2),2));
                if w==1
                    w='';% Ƶ��Ϊ1������ʾ
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
                
            else % ��������Ϊ������������
                % ����ֵ����ת��Ϊ�ַ�ϸ������
                arrnum2str = @(x)arrayfun(@num2str,x,'UniformOutput',false);
                A = arrnum2str(round(self.mm*sqrt(2),2));%ϸ��
                if w==1
                    w={''};% Ƶ��Ϊ1������ʾ
                elseif numel(w)==1
                    w={num2str(w)};
                elseif numel(w)~=numel(self)
                    error('Ƶ����������Ŀ��ƥ�䣡')
                else
                    w = arrnum2str(w);
                end
                angle_char = arrnum2str(round(self.ad,2));%ϸ��
                
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
        
        % ���ִ��Ҫ��latex��ʽ������ֱ�����������
        function e = slatex(self,w,unit)
            if nargin==2
                if ischar(w) % �жϺ���unit��w��ʡ��
                    unit=w;
                    w=1;
                else % �жϺ���w,unit��ʡ��
                    unit='';
                end
            elseif nargin==1
                w=1;
                unit='';
            end
            
            e = sine(self,w,unit,'latex');
        end
        
        % ������ת��Ϊָ��Ƶ�ʵ�ʱ����
        % 2020��12��8�� ������
        function f = sin_func(self,w)
            if nargin == 1
                % Ĭ��Ƶ��Ϊw=1
                w = 1;
            end
            if numel(self) ~= numel(w) && numel(w)>1
                error('�����Ƶ����������ģ��ƥ�䣡')
            end
            warning('��ע��ȷ��Ҫ����Ķ����Ƿ�����Чֵ����')
            % A cos( w t + phi )
            A = self.mm*sqrt(2);
            phi = self.ar();
            if numel(self) == 1
                f = @(t)A.*cos(w.*t + phi);
            else
                % �������
                % һ���̶��������˿ɶ���
                f = @(t)cell2mat(arrayfun( @(t)A.*cos(w.*t + phi),...
                    reshape(t,[ones(1,ndims(self)),numel(t)]),...
                    'UniformOutput',false));
            end
        end
        
        % �������ڰ汾
        function e = sinu(self,w,u,islatex)
            e = sine(self,w,u,islatex);
        end
        
    end % of methods
    %% >> ����ͼ
    methods
        % ��������ͼ
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

