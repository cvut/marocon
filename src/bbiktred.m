function deg = bbiktred( robot, pos )
%BBIKTRED  Inverse kinematic task reduced to reachable positions.
%
%   deg = bbiktred( robot, pos )
%
%   Computes joint coordinates given robot end-point position and
%   orientation. Anly the coordinates reachable by the robot are returned.
%
%   See BBIKT.

% (c) 2010-02-17, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( isfield( robot, 'ikt' ) )
  deg = robot.ikt( robot, pos );
  if( ~isempty( deg ) )
    r = bbcheckdeg( robot, deg );
    r = all( r, 2 );
    deg = deg( r, : );
  end
else
  error( 'This robot has no IKT implemented.' );
end
