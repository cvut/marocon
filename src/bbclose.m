function bbclose( robot )
%BBCLOSE  Close the robot communication.
%
%   bbclose( robot )
%
%   Moves robot to softhome, resets motors and releases the communication port.
%
%   Input:
%     robot .. robot control structure.

% (c) 2001-01, Ondrej Certik
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

try
  if( robot.hhflag )
    bbsofthome( robot );
  end
catch
end

bbresetmotors( robot );
robot.com.writeline( 'ECHO:1' );
robot.com.close;
