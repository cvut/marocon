function pos = bbdkt( robot, deg )
%BBDKT  Direct kinematic task.
%
%   pos = bbdkt( robot, deg )
%
%   Computes position and orientation of robot end-point given joint
%   coordinates in degrees/mm.
%
%   Input:
%     robot .. robot control structure
%     deg   .. joint coordinates in degrees/milimeters. Matrix n x DOF,
%              each row corresponds to a single configuration.
%
%   Output:
%     pos  .. position (milimeters) and orientation (degrees). Matrix n x 6,
%             one row for corresponding configuration. Each row is composed as
%                       [ x y z alpha beta gamma ]
%             where alpha, beta, gamma are TODO
%
%   Actually, this function is only a wrapper for a robot-specific DKT.
%
%   See also BBIKT.

% (c) 2010-01-29, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( isfield( robot, 'dkt' ) )
  pos = robot.dkt( robot, deg );
else
  error( 'This robot has no DKT implemented.' );
end
