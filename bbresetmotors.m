function bbresetmotors( robot )
%BBRESETMOTORS  Clear err state of all motors.
%
%   bbresetmotors( robot )
%
%   Input:
%     robot .. robot control structure

% (c) 2008-05-12, Pavel Krsek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( robot.verbose )
  fprintf( 'Resetting motors.\n' );
end

%portwriteline(robot,'CLEAR:');
robot.com.writeline( 'PURGE:' );
