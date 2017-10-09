function bbrelease( robot )
%BBRELEASE  Stop all motors and release its control.
%
%   bbrelease( robot )
%
%   Releases controllers of all motors. The motors without power stop
%   controled motion. The state enables a manual manipulation.
%
%   Warning: although electric force is released, gravity is not.
%
%   Input:
%     robot .. robot control structure

% (c) 2008-05-12, Pavel Krsek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot.com.writeline( 'RELEASE:' );
