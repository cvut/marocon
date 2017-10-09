function deg = robboschikt( robot, pos )
%ROBBOSCHIKT  Inverse kinematic task - robot Bosch.
%
%   deg = robboschikt( robot, pos )
%
%   See BBIKT.

% (c) 2005-10, Pavel Krsek
% (c) 2010-02-17, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

c=sqrt(pos(1)^2+pos(2)^2);
b=acos((c^2-robot.L1^2-robot.L2^2)/(2*robot.L1*robot.L2))*180/pi;
if imag(b) ~= 0 
  deg=[];
  return
end
g=acos((c^2+robot.L1^2-robot.L2^2)/(2*robot.L1*c))*180/pi;
if pos(1)==0
  d=90*sign(pos(2));
else
  d=atan(pos(2)/pos(1))*sign(pos(1))*180/pi;
end

deg(1,4)=pos(4);
deg(1,3)=-pos(3);
deg(1,2)=b;
deg(1,1)=90-d-g;
deg(2,4)=pos(4);
deg(2,3)=-pos(3);
deg(2,2)=-b;
deg(2,1)=90-d+g;

if pos(1)~=0
  deg(:,1:2)=deg(:,1:2)*sign(pos(1));   
end

if pos(1) < 0
  p=deg(1,:);
  deg(1,:)=deg(2,:);
  deg(2,:)=p;
end
