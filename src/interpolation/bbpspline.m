function params = bbpspline( x, order, num_seg, p_ord, lambda )
%BBPSPLINES P-spline interpolation of points in x
%   
%   Function interpolates points given in x using P-splines.
%
%   params = bbpspline( x, order, num_seg, p_ord, lambda )
%
%   Input:
%     x  .. points to interpolate. Each column represents a point.
%     order    .. order of polynomial to use. If not specified, 
%                 default order is 3.
%     num_seg  .. number of segments to use. If not specified, 
%                 default number is n_points/3.
%     p_ord    .. order of penalty to use (should be less or equal to
%                 order of polynomial). If not specified, default 
%                 penalty order is 2.
%     lambda   .. penalization constant. If not specified, default lambda 
%                 is 0.1.
%
%   Output:
%     params .. matrix with coefficients of piese-wise polynomials.
%               Each row contains parameters of polynomial for given
%               order and number of axes.

% (c) 2017, Petrova Olga

%   Based on Eilers and Marx, Flexible Smoothing with B-splines 
%   and Penalties, 1996

[n, dim] = size(x);

if nargin < 2
	order = 3;
end
if nargin < 3
    num_seg = round(n);
end
if nargin < 4 
	p_ord = 2;
end
if nargin < 5
    lambda = 0.1;
end

if order ~= 2 && order ~= 3
    error('Function supports only 2nd and 3rd order polynomials');
end

if order < p_ord
    error('Order of penalty should be less or equal to degree of polynomial');
end

if order == 2
    M = [0.5, -1.0, 0.5; -1.0, 1.0, 0.0; 0.5, 0.5, 0.0];
end
if order == 3
    M = [-1.0/6.0, 0.5, -0.5, 1.0/6.0; 0.5, -1.0, 0.5, 0.0;
         -0.5, 0.0, 0.5, 0.0; 1.0/6.0, 2.0/3.0, 1.0/6.0, 0.0];
end

t = 0:n-1;
[a, step] = pspline(t, 0, n-1, num_seg, order, p_ord, lambda, x);
params = [];
for i=1:num_seg
   c = flipud(M*a(i:i+order,:))';
   c = reshape(c(:,2:end)',[1,order*dim]);
   params = [params;c];
end
end

function [a, step] = pspline(t, tl, tr, ndx, bdeg, pord, lam, x)
    [B, step] = bspline(t, tl, tr, ndx, bdeg);
    n = size(B, 2);
    D = diff(eye(n), pord);
    a = ((B'*B) + lam*(D'*D))\(B'*x); 
end

function [Bs, dx] = bspline(x, xl, xr, ndx, bdeg)
    dx = (xr - xl) / ndx;
    t = xl + dx * (-bdeg:ndx);
    T = (0 * x(1) + 1) * t;
    r = [2:length(t) 1];
    
    Bs = [];
    for i=1:length(x)
        X = x(i) * (0 * t + 1);
        P = (X - T) / dx;
        B = double((T <= X) & (X < (T + dx)));
        if nnz(B) > 1
            B = B / sum(B);
        end
        for k = 1:bdeg
            B = ( P .* B + (k + 1 - P) .* B(r)) / k;
        end
        Bs = [Bs; B];
    end
end

