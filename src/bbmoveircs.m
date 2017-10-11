function bbmoveircs(robot,ircs,t,disc)
%BBMOVEIRCS  Coordinated robot motion through positions given in IRC units.
%
%  bbmoveircs( robot, ircs, t, disc )
%
%  Moves robot through all positions in ircs by coordinated movement. 
%  The positions are defined by joint coordinates in IRC units.
%
%  Input:
%    robot  .. robot control structure
%
%    ircs   .. set of joint coordinates in IRC units
%              ([n x DOF], each row corresponds to one position)
%
%    time  ... minimal time interval between 2 succeedings 
%              positions (maximal speed) [ms]
%
%    disc  ... rate of discontinuity in speeds. For details see manual of 
%              robot control unit. Value can be any nonnegative integer. Best
%              performance is achieved with disc set to about 5.
%
%  Example:    bbmoveircs(robot, ircs, 50, 5);
%

% (c) 2008-04-18, Jan Pospisil & Radek Beno
%     (rewritten based on modifications by V. Smutny)
% (c) 2008-04-30, Pavel Krsek, (improvement of some "matlab" code)
% (c) 2008-07-10, Pavel Krsek, (implementation of controler type)
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% Test of controler type
if( ~isfield(robot,'controller') || ~isequal( robot.controller, 'MARS8' ) )
  error('Coordinated motion is implemented only for MARS8'),
end;

% Length of coordinate movement queue
maxLenOfQueue = 200;
% Minimum of free positions in the queue
% if ST bit7 of MARS8 is set to 0.
minEmptyQueue = 50;

% Check axis bounds
bbcheckirc(robot,ircs,true);

% Wait for finish of previous command
bbwaitforready(robot);

% Set rate of discontinuity
robot.com.flush;

robot.com.writeline( ['COORDDISCONT:',int2str(disc)] );

cgrp = [ sprintf( '%c,', robot.activemotors(1:end-1) ) robot.activemotors(end)];

robot.com.writeline( [ 'COORDGRP:' cgrp ] );

% Write all requested positions
bbwaitforready(robot);

% First queue is fullfilled
EmptyQueue = maxLenOfQueue;
% Number of already sent points
sent = 1;
% Number of desired points
count = size(ircs, 1); % number of position
while sent <= count
    waitForEmptyQueue(robot);
    % send minEmptyQueue coordinates
    for i = 1:EmptyQueue
        str = [int2str(t),sprintf(',%0d',round(ircs(sent,1:robot.DOF)))];
        robot.com.writeline( ['COORDMVT:',str]);
        sent = sent + 1;
        if sent > count, break; end;
    end;
    % Only free part of queue will be filled
    EmptyQueue = minEmptyQueue;
end;

% Wait formovement finish
bbwaitforready(robot);
robot.com.writeline('COORDGRP:');

return;

% Waiting for queue to have free positions
% The flag is set to 0 when MARS8 control unit
% have more than 50 free positions in the queue.
function [robot] = waitForEmptyQueue(robot)

full = 1;
t = robot.com.timeout;
robot.com.settimeout( 10 );
while (full ~= 0)
    robot.com.flush;
    value = robot.com.query('ST');
    % take 7th bit corresponding buffer status
    p = dec2bin(eval(value),8);
    full = eval(p(length(p)-8+1)) > 0;
end
robot.com.settimeout( t );

return;



