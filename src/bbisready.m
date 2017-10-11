function stat = bbisready(robot, for_coordmv_queue)
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

% (c) 2017, Petrova Olga
% (c) 2001-01, Ondrej Certik
% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if nargin == 1
    for_coordmv_queue = false;
end

robot.com.flush;
resp = robot.com.query('ST');
% [first, last] = strtok(status,'=');
if isempty(resp)
   error(['bbisready: unexpected response: "',status,'"']);
end
bin = dec2bin(eval(resp),18);
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

if for_coordmv_queue
    stat = ~eval(bin(11));
else
    stat = ~eval(bin(14));
end