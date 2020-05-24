% 2019-11-4
classdef phasor
    properties
        m % magnitude
        a % angle degree
        x % real part
        y % image part
        c % complex
    end
    
    %% constructor & disp
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
                if isphasor(m)
                    c = m;
                elseif isnumeric(m) % most convenient way
                    c = m;
                elseif iscell(m) % who would use this strange initial value?
                    idx = findp(m);
                    self(idx) = m{idx};
                    self(~idx).c = complex(m{~idx});
                    self = self.c2p();
                    c=[];
                end
            else
                % compatible with matrix
                if imag(a) == 0
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
    end
    
    %% basic series
    methods
        function self = c2p(self,c)
            % f(c) -> m,a,x,y
            if nargin==1 || isempty(c)
                % use p = p.c2p() to update phasor from c.
                % self.c should be indevidul values, but this expression is
                % compatible with matrix self.c (though it's wrong format)
                c = reshape([self.c],size(self));
            end
            if isphasor(c)
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
        
        function idx = findp(vars)
            % Logical index of phasors in array
            if isnumeric(vars)
                idx = false(size(vars));
            elseif isphasor(vars)
                idx = true(size(vars));
            elseif iscell(vars)
                idx = false(size(vars));
                for ii=1:numel(vars)
                    if isphasor(vars{ii})
                        idx(ii)=1;
                    end
                end
            end
        end
        
        % basic calculation
        
        % TODO pahsor matrix compatibility
        function pr = plus(p1,p2)
            % +
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor(p1.c+p2.c);
        end
        
        function pr = minus(p1,p2)
            % -
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor(p1.c-p2.c);
        end
        
        function pr = times(p1,p2)
            % .*
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor(p1.c.*p2.c);
        end
        
        function pr = mtimes(p1,p2) % TODO pahsor matrix compatibility
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor(p1.c.*p2.c);
        end
        
        function pr = rdivide(p1,p2)
            % ./
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor(p1.c./p2.c);
        end
        
        function pr = mrdivide(p1,p2) % TODO pahsor matrix compatibility (?
            % /
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor(p1.c/p2.c);
        end
        
        function pr = ctranspose(p)
            % ' conjuction
            pr = phasor(reshape([p.c]',size(p)));
        end
        
        
        
        
        
        
        
    end
    
    methods
        % special calculation
        % 优先级太低，在不使用括号指定的情况下进行混合运算会出错。暂时没有好的解决办法
%         function pr = or(p1,p2)
%             % parallel: p1|p2
%             p1 = phasor(p1);
%             p2 = phasor(p2);
%             pr = phasor( 1./(1./p1.c+1./p2.c) );
%         end
        function pr = sh(p1,p2)
            % parallel: sh(p1,p2)
            p1 = phasor(p1);
            p2 = phasor(p2);
            pr = phasor( 1./(1./p1.c+1./p2.c) );
        end
        
    end
    
    %% angle stuff
    methods
        function a_rad = ar(self)
        % return angle in rad
            a_rad = self.a/180*pi;
        end
        
        function a_deg = ad(self)
        % return angle in deg (=p.a)
            a_deg = self.a;
        end
    end % of methods
    
end % of class



