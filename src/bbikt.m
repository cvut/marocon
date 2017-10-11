function deg = bbikt( robot, pos )
%BBIKT  Inverse kinematic task.
%
%   deg = bbikt( robot, pos )
%
%   Computes joint coordinates given robot end-point position and orientation.
%
%   Input:
%     pos  .. position (milimeters) and orientation (degrees). Matrix 1 x 6,
%             The row is composed as
%                       [ x y z alpha beta gamma ]
%             where alpha, beta, gamma are TODO
%
%     robot .. robot control structure
%
%   Output:
%     deg   .. joint coordinates in degrees/milimeters. Matrix m x DOF,
%              each row corresponds to a particular solution (there can be
%              more than one solution of IKT for a particular robot).
%
%   Actually, this function is only a wrapper for a robot-specific IKT.

% (c) 2010-01-29, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( isfield( robot, 'ikt' ) )
  deg = robot.ikt( robot, pos );
else
  error( 'This robot has no IKT implemented.' );
end
