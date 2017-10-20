function params = bbbsplines( x, order )
%BBBSPLINE B-spline interpolation of points in x
%   
%   Function interpolates points given in x using B-splines.
%
%   params = bbbsplines( x )
%
%   Input:
%     x  .. points to interpolate. Each column represents a point.
%     order .. order of polynomial to use
%
%   Output:
%     params .. matrix with coefficients of piese-wise polynomials.
%               Each row contains parameters of polynomial for given
%               order and number of axes.

% (c) 2017, Petrova Olga

if order ~= 2 && order ~= 3
    error('Function supports only 2nd and 3rd order polynomials');
end
x = x';
lst = [];
[dim, n] = size(x);

if order == 2

    if n < 5
		error('Not enough points for interpolation of 2nd order. Minimal number for spline of 2nd order is 5.');
	end
	
    M0 = [2, -4, 2; 0, 4, -3; 0, 0, 1];
    M1 = [1, -2, 1; 1, 2, -2; 0, 0, 1];
    M2 = [1, -2, 1; 1, 2, -3; 0, 0, 2];

    lst = 0.5*x(:,1:3)*M0;
    for i=2:n-3
        lst = [lst; 0.5 * x(:,i:i+2)*M1];
    end
    lst = [lst; 0.5 * x(:,end-2:end)*M2];
    
end

if order == 3
   
    if n < 7
        error('Not enough points for interpolation. Minimal number for spline of 3rd order is 7.');
	end

    M0 = [12, -36, 36, -12; 0, 36, -54, 21; 0, 0, 18, -11; 0, 0, 0, 2];
    M1 = [3, -9, 9, -3; 7, 3, -15, 7; 2, 6, 6, -6; 0, 0, 0, 2];
    M2 = [2, -6, 6, -2; 8, 0, -12, 6; 2, 6, 6, -6; 0, 0, 0, 2];
    M3 = [2, -6, 6, -2; 8, 0, -12, 6; 2, 6, 6, -7; 0, 0, 0, 3];
    M4 = [2, -6, 6, -2; 7, -3, -15, 11; 3, 9, 9, -21; 0, 0, 0, 12];

    lst = 1.0/12.0 * x(:, 1:4)*M0;
    lst = [lst; 1.0/12.0 * x(:, 2:5)*M1];

    for i=3:n - 5
        lst = [lst; 1.0/12.0 * x(:, i:i + 3)*M2];
    end
    lst = [lst; 1.0/12.0 * x(:, end-4:end-1)*M3];
    lst = [lst; 1.0/12.0 * x(:, end-3:end)*M4];
end

lst = lst(:,2:end);
lst = reshape(lst', [order, dim, n-order]);
params = reshape(lst,[order*dim, n-order])';
params = bbparamcorr(x(:,1)',params,order);
end

