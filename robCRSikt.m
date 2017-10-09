function deg = robCRSikt( robot, pos )
%ROBCRSIKT  Inverse kinematic task - robot CRS.
%
%   deg = robCRSikt( robot, pos )
%
%   See BBIKT.

% (c) 2008-04-15, Pavel Krsek, based on Michal Havlena code
% (c) 2010-02-17, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $
    
pos(4:6) = pos(4:6)/180*pi;

myeps = 10000*eps; % equality tolerance
par1 = 0; % if infinite number of solutions, theta1=par1
par4 = 0; % if infinite number of solutions, theta4=par4

% DH notation
r.offset = [        0;      270;       90;        0;        0;                          0]/180*pi;
r.sign   = [        1;        1;        1;        1;        1;                          1];
r.d      = [ robot.L1;        0;        0; robot.L3;        0; robot.L4+robot.L5+robot.L6];
r.a      = [        0; robot.L2;        0;        0;        0;                          0];
r.alpha  = [       90;        0;      270;       90;      270;                          0]/180*pi;
r.base = eye(4);
r.tool = [cos(-pi/2) 0 sin(-pi/2) 0; 0 1 0 0; -sin(-pi/2) 0 cos(-pi/2) 0; 0 0 0 1];

% T = base*A01*A12*A23*A34*A45*A56*A76*tool
A76 = [1 0 0 0; 0 1 0 0; 0 0 1 r.d(6); 0 0 0 1];
T = [cos(pos(4))*cos(pos(5)) -sin(pos(4))*cos(pos(6))+cos(pos(4))*sin(pos(5))*sin(pos(6))  sin(pos(4))*sin(pos(6))+cos(pos(4))*sin(pos(5))*cos(pos(6)) pos(1);...
     sin(pos(4))*cos(pos(5))  cos(pos(4))*cos(pos(6))+sin(pos(4))*sin(pos(5))*sin(pos(6)) -cos(pos(4))*sin(pos(6))+sin(pos(4))*sin(pos(5))*cos(pos(6)) pos(2);...
     -sin(pos(5))                                      cos(pos(5))*sin(pos(6))                                      cos(pos(5))*cos(pos(6)) pos(3);...
     0                                                            0                                                            0      1];
W = inv(r.base)*T*inv(r.tool)*inv(A76);
% X = A01*A12*A23*[0 0 0 1]' because A34*A45*A57==R34*R45*R56 is pure rotation
X = W*[0 0 0 1]';

% solve joints 1, 2, 3
J = [];
b = X(3)-r.d(1);
if abs(X(1))<myeps && abs(X(2))<myeps % arm going straight up
  if abs(b-r.d(4)-r.a(2))<myeps % full length
    J = [J; par1 0 0];
  elseif b < r.d(4)+r.a(2) % can reach
    J = [J; par1 -acos((r.a(2)^2+b^2-r.d(4)^2)/(2*r.a(2)*b))  pi-acos((r.a(2)^2+r.d(4)^2-b^2)/(2*r.a(2)*r.d(4)));...
         par1  acos((r.a(2)^2+b^2-r.d(4)^2)/(2*r.a(2)*b)) -pi+acos((r.a(2)^2+r.d(4)^2-b^2)/(2*r.a(2)*r.d(4)))];
  else % cannot reach
    J = [J; NaN NaN NaN];
  end
else
  c = sqrt(b^2 + X(1)^2 + X(2)^2);
  if abs(c-r.d(4)-r.a(2))<myeps % full length
    J = [J;   atan2(X(2),X(1)) -pi/2+asin(b/c) 0;...
         atan2(-X(2),-X(1))  pi/2-asin(b/c) 0];
  elseif c < r.d(4)+r.a(2) % can reach
    theta2 = pi/2-asin(b/c)+acos((r.a(2)^2+c^2-r.d(4)^2)/(2*r.a(2)*c)); % can be bigger than pi!!!
    if theta2>pi; 
        theta2 = theta2-2*pi; 
    end
    J = [J;   atan2(X(2),X(1))                                                    -theta2  pi-acos((r.a(2)^2+r.d(4)^2-c^2)/(2*r.a(2)*r.d(4)));...
         atan2(X(2),X(1)) -pi/2+asin(b/c)+acos((r.a(2)^2+c^2-r.d(4)^2)/(2*r.a(2)*c)) -pi+acos((r.a(2)^2+r.d(4)^2-c^2)/(2*r.a(2)*r.d(4)));...
         atan2(-X(2),-X(1))                                                     theta2 -pi+acos((r.a(2)^2+r.d(4)^2-c^2)/(2*r.a(2)*r.d(4)));...
         atan2(-X(2),-X(1))  pi/2-asin(b/c)-acos((r.a(2)^2+c^2-r.d(4)^2)/(2*r.a(2)*c))  pi-acos((r.a(2)^2+r.d(4)^2-c^2)/(2*r.a(2)*r.d(4)))];
  else % cannot reach
    J = [J; NaN NaN NaN];
  end
end

deg = [];
toolJ = [1 0 0 0; 0 1 0 0; 0 0 1 r.d(4); 0 0 0 1];
for j=1:size(J,1)
  if ~isnan(sum(J(j,:)))
    % direct kinematics for first 3 joints; inversed
    r.theta = (J(j,:)'-r.offset(1:3)).*r.sign(1:3);
    P = W;
    for i=1:3
      M = [cos(r.theta(i)), -sin(r.theta(i))*cos(r.alpha(i)),  sin(r.theta(i))*sin(r.alpha(i)), r.a(i)*cos(r.theta(i));...
           sin(r.theta(i)),  cos(r.theta(i))*cos(r.alpha(i)), -cos(r.theta(i))*sin(r.alpha(i)), r.a(i)*sin(r.theta(i));...
           0,                  sin(r.alpha(i)),                  cos(r.alpha(i)),                 r.d(i);...
           0,                                0,                                0,                      1];
      P = inv(M)*P;
    end
    % P = R34*R45*R56
    P = inv(toolJ)*P;
    
    % Euler Z -Y Z for joints 4, 5, 6
    if abs(P(3,3)-1)<myeps % cos(theta5)==1
      deg = [deg; J(j,:) par4 0 atan2(P(2,1),P(1,1))-par4];
    elseif abs(P(3,3)+1)<myeps % cos(theta5)==-1
      deg = [deg; J(j,:) par4 pi atan2(P(2,1),-P(1,1))+par4];
    else % non-degenerate
      theta5 = acos(P(3,3));
      deg = [deg; J(j,:)   atan2(P(2,3)*sign(sin(theta5)),P(1,3)*sign(sin(theta5))) -theta5   atan2(P(3,2)*sign(sin(theta5)),-P(3,1)*sign(sin(theta5)));...
                J(j,:) atan2(P(2,3)*sign(sin(-theta5)),P(1,3)*sign(sin(-theta5)))  theta5 atan2(P(3,2)*sign(sin(-theta5)),-P(3,1)*sign(sin(-theta5)))];
    end
  else
    deg = [deg; J(j,:) NaN NaN NaN];
  end
end

deg = deg*180/pi;
