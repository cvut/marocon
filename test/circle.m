% Script for demonstration of spline movement. 
% The toolpoint of robot is moved along circle in YZ plane.
% The circle is described by parameters x0, y0, z0, r, step.

%% Initialization and 

% addpath ../src
% addpath ../src/interpolation
% 
% tty_dev = 'COM3';
% rob = bbopen('CRS93', tty_dev);
% rob = bbinit(rob);
bbsetupcoord( rob );
% bbwaitforready(rob);

%% Trajectory sampling
clc
x0 = 500;  % x coordinate of centre
y0 = 250;  % y coordinate of centre
z0 = 500;  % z coordinate of centre
r = 100;    % radius of circle
step = 10; % step of sampling in degs

pos = [x0, y0 + r, z0, 0, 0, 0];
[~, prev_a] = bbmovex(rob, pos);
sol = [];
rng = (360+step) / step;
poss = [];
for i = 1:rng
    y = y0 + r * cos((i * step) / 180 * pi);
    z = z0 + r * sin((i * step) / 180 * pi);
    pos = [x0, y, z, 0, 0, 0];
    poss = [poss; pos];
    [~,prev_a] = bbmovex(rob,pos, prev_a);
    sol = [sol;prev_a];
end
% plot(poss(:,2), poss(:,3));

%% Interpolation of joint coordinates
clc
order = 3;

% params = bbcubic(sol);
% params = bbbspline(sol, order);
params = bbpspline(sol, order);

%% Graph of interpolated points

plot(sol);
hold on;

xn = 0:0.01:1;

if order == 2
    xns = [ xn;xn.^2;];
else
    xns = [xn; xn.^2;xn.^3];
end

x0 = sol(1,:);
for m = 1:size(params,1)
    for i=0:rob.DOF-1
        x = params(m,(i*order+1):(i*order+order))*xns + x0(i+1) ;
        x0(i+1) = x(end);
        plot(xn+m, x,'linewidth',1.5);
    end
end


%% Move to the starting position
pos = [500, y0 + r, z0, 0, 0, 0];
[~, prev_a] = bbmovex(rob, pos);
bbmoveirc(rob, prev_a);

%% Moving along trajectory
bbcoordsplinets(rob, params, order);





