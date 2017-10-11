function bbsofthome( robot )
%BBSOFTHOME  Soft homing.
%
%   bbsofthome( robot )
%
%   Moves the (allready hard-homed) robot to defined home position and resets
%   motors
%
%   Input:
%     robot .. robot control structure.

% (c) 2001-01, Ondrej Certik
% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( robot.verbose )
  fprintf( 'Softhome.\n' )
end

pos = robot.hhdeg;
if isfield(robot,'shdeg'),
    pos = robot.shdeg;
end;

bbmoveirc( robot, bbdegtoirc( robot, pos) );
bbgrip( robot, 0 );
bbwaitforready( robot );
bbresetmotors( robot );
