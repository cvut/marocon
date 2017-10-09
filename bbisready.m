function stat = bbisready(robot)
%BBISREADY  Determine if the robot is ready.
%
%   stat = bbisready( robot )
%
%   Determines if the robot is not moving at the time and is ready for a new
%   command.
%
%   Input:
%     robot  .. robot control structure.
%
%   Output:
%     stat   .. flag, 1 = robot is ready, 0 = last command is in progress

% (c) 2001-01, Ondrej Certik
% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot.com.flush;
robot.com.writeline( 'ST?' );
status = robot.com.readline;
[first, last] = strtok(status,'=');
if isempty(last)
   error(['bbisready: unexpected response: "',status,'"']);
end
bin = dec2bin(eval(last(2:size(last,2))),18);
s='';
if bin(15)=='1'
   s = 'error, ';
end
if bin(2)=='1'
   s=[s,'arm power is off, '];
end
if bin(1)=='1'
   s=[s,'motion stop, '];      
end;
if ~isempty(s)
   error(['bbisready: ',s(1:length(s)-2),'.']);
end
stat = ~eval(bin(14));
