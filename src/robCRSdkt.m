function deg = robCRSdkt( rob, deg )
%ROBCRSDKT  Direct kinematic task - rob CRS.
%
%   deg = robCRSdkt( rob, pos )
%
%   See BBDKT.

% (c) 2017-12-08, Petrova Olga

T = eye(4);
deg = deg / 180 * pi;

for i=1:rob.DOF
    tz = eye(4);
    tz(3,4) = rob.d(i);
    rz = eye(4);
    o = -rob.offset(i);
    rz(1:2, 1:2) = [cos(o+deg(i)), -sin(o+deg(i));
                    sin(o+deg(i)), cos(o+deg(i))];
    tx = eye(4);
    tx(1,4) = rob.a(i);
    rx = eye(4);
    a = rob.alpha(i);
    rx(2:3, 2:3) = [cos(a), -sin(a);
                    sin(a), cos(a)];
    T = T*tz*rz*tx*rx;
end
T = T*rob.tool;
deg = T(1:3,4);
a3 = atan2(T(2,1), T(1, 1))/pi * 180;
a4 = asin(-T(3,1))/pi * 180;
a5 = atan2(T(3,2), T(3,3))/pi * 180;
deg = [deg', a3, a4, a5];


