% Script for demonstration of spline movement. 
% The toolpoint of robot is moved along circle in YZ plane.
% The circle is described by parameters x0, y0, z0, r, step.
% close all
%% Initialization and homing

tty_dev = 'COM3';
rob = bbopen('CRS93', tty_dev);
rob = bbinit(rob);
% necessary step for spline movement
bbsetupcoord( rob );
bbwaitforready(rob);

%% 1st step: Creatimg a parametrized trajectory

% Unit circle in YZ plane
circ = @(angle) [0, cos(angle), sin(angle)];

% Rose / Rhodonea curve with 3 petals in YZ plane
rose = @(angle) cos(3*angle)*[0, cos(angle), sin(angle)];
                
%% 2nd step: Trajectory sampling
clc

% Chose a curve
curve = rose;

x0 = [500, 250, 500]; % coordinate of curve centre [mm]
r = 100; % radius of curve [mm]
step = 10; % step of sampling [deg]

pos = zeros(1, 6);
[~, prev_a] = bbmovex(rob, pos);

poss = zeros(1, 6);
sol = zeros(1, 6);

for i = 0:180 / step
    c = r .* curve((i * step) / 180 * pi);
    pos = [x0 + c, 0, 0, 0];
    [~, prev_a] = bbmovex(rob, pos, prev_a);
    poss(i+1,:) = pos;
    sol(i+1,:) = prev_a;
end

% figure();
% plot(poss(:,2), poss(:,3), '*-');
% title('Trajectory in Cartesian coordinates');
% grid on;
% xlabel('Y');
% ylabel('Z');
% daspect([1 1 1]);
%% 3rd step: Interpolation of joint coordinates
clc
order = 3;

params = bbcubic(sol);
% params = bbbspline(sol, order);
% params = bbpspline(sol, order);

%% Graph of interpolated points

xn = 0:0.002:0.998;

if order == 2
    xns = [ xn;xn.^2;];
else
    xns = [xn; xn.^2;xn.^3];
end

% interpolated trajectory
itrp_traj = sol(1,:)';
for m = 1:size(params,1)
    xc = reshape(params(m,:),[3,6])'*xns + itrp_traj(:,1+length(xns)*(m-1));
    itrp_traj = [itrp_traj,xc];
end

figure();
p1 = plot(step*(0:length(sol)-1),sol, 'black');
hold on;
p2 = plot(linspace(0,length(sol)-1, length(itrp_traj))*step, itrp_traj,'linewidth',1);
legend([p1(1); p2],{'Sampled trajectory',...
    'Axis 1','Axis 2',...
    'Axis 3','Axis 4',...
    'Axis 5','Axis 6'},...
    'Location','northeastoutside');
title('Joint coordinates');
xlim([0,(length(sol)-1)*step]);
axis normal;
grid on;

%% Original trajectory vs real
real_traj = [];
for i=1:size(itrp_traj, 2)
    deg = bbirctodeg(rob, itrp_traj(:,i)');
    real_traj = [real_traj; bbdkt(rob, deg)];
end
figure();
plot(poss(:,2), poss(:,3), '*-');
title('Trajectory in Cartesian coordinates');
grid on;
xlabel('Y');
ylabel('Z');
daspect([1 1 1]);
hold on
plot(real_traj(:,2),real_traj(:,3))
%% Move to the starting position
% pos = [500, y0 + r, z0, 0, 0, 0];
% [~, prev_a] = bbmovex(rob, pos);
% bbmoveirc(rob, prev_a);
% 
% %% Moving along trajectory
% bbcoordsplinets(rob, params, order);
% 




