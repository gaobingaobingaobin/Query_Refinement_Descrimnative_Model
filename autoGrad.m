function [f,g] = autoGrad(x,useComplex,funObj,varargin)
% [f,g] = autoGrad(x,useComplex,funObj,varargin)
%
% Numerically compute gradient of objective function from function values

p = length(x);
mu = 1e-150;

if useComplex % Use Complex Differentials
    diff = zeros(p,1);
    for j = 1:p
        e_j = zeros(p,1);
        e_j(j) = 1;
        diff(j,1) = funObj(x' + (mu*1i*e_j),varargin{:});
    end

    f = mean(real(diff));
    g = imag(diff)/mu;
else % Use Finite Differencing
    f = funObj(x,varargin{:});
    mu = 2*sqrt(1e-12)*(1+norm(x))/norm(p);
    for j = 1:p
        e_j = zeros(p,1);
        e_j(j) = 1;
        diff(j,1) = funObj(x' + (mu*e_j),varargin{:});
    end
    g = (diff-f)/mu;
end

if 0 % DEBUG CODE
    [fReal gReal] = funObj(x,varargin{:});
    [fReal f]
    [gReal g]
    pause;
end