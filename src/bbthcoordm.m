function throttled = bbthcoordm( robot )
%BBTHCOORDM Throttles coordmv queue
%   
%  Parameters are 
%
%  Input:
%    robot  .. robot control structure
%

% (c) 2017, Petrova Olga

s = robot.com;
throttled = false;
if s.coordmv_commands_to_next_check <= 0
    s.coordmv_commands_to_next_check = 20;
else
    s.coordmv_commands_to_next_check = ...
    s.coordmv_commands_to_next_check - 1;
    return
end
while ~bbisready(robot, true)
    if ~throttled
        fprintf('coordmv queue full - waiting\n');
    end
    throttled = true;
end
end

