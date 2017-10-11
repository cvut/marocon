function robboschdemo( r )
%ROBBOSCHDEMO  Simple demo for robot bosch.
%
%   robboschdemo( robot )

% (c) 2008-05, Pavel Krsek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

a=circle(r,70,200,[0 300 0]);
bbmoveirc(r,a(1,:));%presune se na zacatek kruznice
bbwaitforready(r);
bbmoveircs(r,a,40,10);%projede kruznici
bbclose(r);%udela softhome a zavre com port

function [Angles]=circle(robot,radius,n,point);
%CIRCLE Vygeneruje body na kruznici, vrati IRC (vyhodi moznosti, jichz nelze dosahnout).
%   [Angles]=circle(robot,radius,n,point); kde robot je promena vracena INIT, radius je 
%   polomer kruznice,n je pocet bodu, point jsou souradnice stredu kruznice.
for t=1:(n+1),
   x(t)=radius*cos((t-1)*2*pi/n);
   y(t)=radius*sin((t-1)*2*pi/n);
   z(t)=100;
end
x = x + point(1);
y = y + point(2);
z = z + point(3);
i=0;
Angles=[];
for t=1:n,
   a=bbikt(robot,[x(t),y(t),z(t),0,0,0]);
   if ~isempty(a)
      i = i + 1;
      Angles(i,:) = bbdegtoirc(robot,a(1,:));
   else
      disp('nejsou vsechny body');
   end   
end
return;
