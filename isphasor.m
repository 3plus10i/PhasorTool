function a = isphasor(p)
% Return true when input is phasor.
a = strcmpi(class(p),'phasor');
end