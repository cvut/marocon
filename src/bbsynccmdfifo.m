function bbsynccmdfifo( robot )
%BBSYNCCMDFIFO  Syncronization of unit with the running program.
%
%   bbsynccmdfifo( robot )
%
%   Sends a time stamp to unit and waits untill it returns.  
%
%   Parameters are 
%
%  Input:
%    robot  .. robot control structure
%
% (c) 2017-10-10, Petrova Olga


robot.stamp = mod((robot.stamp + 1),hex2dec('7FFF'));
robot.com.writeline(['STAMP:',robot.stamp]);

while true
    buf = robot.com.readline;
    i = strfind(buf, 'STAMP=');
    if isempty(i)
        continue
    end
    j = strfind(buf, [13, 10]);
    resp = buf((i)+length(q)+1:j-1);
    if str2num(resp) == robot.stamp
        break;
    end
end

end

