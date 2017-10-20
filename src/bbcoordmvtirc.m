function bbcoordmvtirc( robot, irc, t )
%BBCOORDMV  Coordinated robot motion.
%
%   bbcoordmvdegs( param, deg )
%
%   Robot moves to specified trajectory diven in degrees. 
%
%   Parameters are 
%
%  Input:
%    robot  .. robot control structure
%    irc    .. joint coordinates in irc 
%    t      .. minimal time for movement
%
% (c) 2017-10-10, Petrova Olga

if length(irc) ~= robot.DOF
    error( 'Wrong number of parameters (%d, should be %d).', length(irc), robot.DOF*order );
end

if nargin < 3
    t = 0;
end

bbthcoordm(robot);
str = [num2str(t), sprintf(',%0d',round(irc))];
robot.com.writeline( ['COORDMVT:',str]);
end

