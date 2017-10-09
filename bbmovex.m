function [r]=bbmovex(robot,pos,angles)
%[r]=bbmovex(robot,pos,angles) Presune robota do pozice 'pos' (=[Point,Alpha,A,T]).
%   Dle robot.Pose: 
%       0 ..... vybere reseni, ktere je "nejblize" pozici angles (bere se absolutni rozdil mezi 
%               pozicemi u motoru C,D,E a F). Pokud bbmovex ma jen prvni dva parametry, bere se
%               v angles aktualni poloha robota.
%       1-4 ... vybere prislusne reseni, viz IKTMAT (pokud reseni nelze dosahnout, bere se nejblizsi reseni)
%
%   pokud pozice lze dosahnout, r = 1, jinak 0
if robot.pose == 0
   if nargin == 2
      angles=bbirctodeg(robot,bbgetirc(robot));
   end
   [a,InfinitelyMany]=bbiktred(robot,pos);
   if isempty(a)
      r = 0;
      return
   else
      r = 1;
   end
   if InfinitelyMany
      a(1,6) = angles(6);
      bbmoveirc(robot,bbdegtoirc(robot,a(1,:)));
   else
      for i = 1:size(a,1),
         b(i)=abs(a(i,3)-angles(3))+abs(a(i,4)-angles(4))+abs(a(i,5)-angles(5))+abs(a(i,6)-angles(6));
      end
      [x,i]=min(b);
      bbmoveirc(robot,bbdegtoirc(robot,a(i,:)));
   end
else
   [a,InfinitelyMany]=bbikt(robot,pos);
   if isempty(a)
      r = 0;
      return
   else
      r = 1;
   end
   if InfinitelyMany
      bbmoveirc(robot,bbdegtoirc(robot,a(1,:)));
   elseif bbcheckirc(robot,bbdegtoirc(robot,a(robot.pose,:)))
      bbmoveirc(robot,bbdegtoirc(robot,a(robot.pose,:)));
   else
      r=0;
   end
end
