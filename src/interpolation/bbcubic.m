function params = bbcubic( x )
%BBCUBIC Cubic interpolation of points in x
%   
%   Function interpolates points given in x with cubic Hermit splines.
%
%   params = bbcubic( x )
%
%   Input:
%     x  .. points to interpolate. Each column represents a point.
%
%   Output:
%     params .. matrix with coefficients of piese-wise polynomials.
%               Each row contains parameters of polynomial for given
%               order and number of axes.

% (c) 2017, Petrova Olga

[n, dim] = size(x);

v0 = (4 * x(2,:) - 3 * x(1,:) - x(3,:)) / 2;
vn = (-4 * x(end-1,:) + x(end-2,:) +3* x(end,:)) / 2;

b = -3 * x(2:end-3,:) + 3 * x(4:end-1,:);
b0 = -3 * x(1,:) + 3 * x(3,:) - v0;
bn = -3 * x(end-2,:) + 3 * x(end,:) - vn;
b = [b0; b; bn];

n = n-2;
A = full(gallery('tridiag',n,1,4,1));
% A = spdiags(A,-1:1,n,n);

v1ton = A\b;
v = [v0; v1ton; vn];

k0 = [zeros(1,dim); x(2,:) - x(1,:) - v0; v0; x(1,:)];
kn = [zeros(1,dim); x(end,:) - x(end-1,:) - v(end-1,:); v(end-1,:); x(end-1,:)];

A = 2 * x(2:end-1,:) - 2 * x(3:end,:) + v(3:end,:) + v(2:end-1,:);
B = - 3 * x(2:end-1,:) + 3 * x(3:end,:) - v(3:end,:) - 2 * v(2:end-1,:);
C = v(2:end-1,:);
D = x(2:end-1,:);

A = [k0(1,:); A; kn(1,:)];
B = [k0(2,:); B; kn(2,:)];
C = [k0(3,:); C; kn(3,:)];
D = [k0(4,:); D; kn(4,:)];

params = [];
for i=1:n+1
    param = [C(i,:);B(i,:);A(i,:)];
    param = reshape(param, [1, dim*3]);
    params = [params;param];
end
params = bbparamcorr(x(1,:),params,3);
end

