function [r, irc]=bbbestpos(rob, pos, prev_pos)
%BBBESTPOS Finds position with closest configuration to current position.
%   
%   [r, irc]=bbbestpos(robot, pos, prev_pos)
%   
%   Finds position with closest configuration to current position based 
%   on distance in joint space.
%
%   Input:
%     robot    .. robot control structure.
%     pos      .. desired position
%     prev_pos .. previous position
%
%   Output:
%     r        .. indicates whether position is reacheble or not
%     irc      .. ircs of desired position in best configuration

%   (c) Petrova Olga, 2017

if nargin < 3
    prev_pos = bbdegtoirc(rob,rob.shdeg);
end

angles = bbiktred(rob, pos);
ircs = bbdegtoirc(rob,angles);

if isempty(angles)
    r = 0;
    return;
else
    r = 1;
end

min_dist = Inf;
a = [];

for i=1:size(ircs,1)
    dist = norm(prev_pos - ircs(i,:));
    if dist < min_dist
        min_dist = dist;
        a = ircs(i,:);
    end
end
irc = a;
end
