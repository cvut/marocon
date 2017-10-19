function bbcoordmvtdeg( robot, deg, t )
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
%    deg    ..  joint coordinates in degrees 
%    t      .. minimal time for movement
%
% (c) 2017-10-10, Petrova Olga

if length(deg) ~= robot.DOF
    error( 'Wrong number of parameters (%d, should be %d).', length(param), robot.DOF*order );
end

if nargin < 3
    t = 0;
end

bbcoordmvtirc(robot, bbdegtoirc( robot, deg ), t)
end

