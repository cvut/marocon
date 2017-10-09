function bbgrip( robot, power )
%BBGRIP  Gripper control.
%
%   bbgrip( robot, power )
%
%   Input:
%     robot .. robot control structure.
%     power .. gripper value (hardware dependent), real value in <-1;1>
%              interval. 0 mean no force, open and released gripper or
%              similar. For some grippers only positive values can make sense.
%
%   Actually, this function is only a wrapper for a specific gripper function.
%   If a robot has no gripper, only value allowed is power = 0.

% (c) 2005-10, Martin Matousek
% (c) 2009-05, Pavel Krsek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% Check limits of power
if( power < -1 || power > 1 )
  error( 'Power out of bounds' );     
end 

if( isfield( robot, 'gripper' ) )
  robot.gripper( robot, power );
else
  if( power ~= 0 )
    error( 'This robot has no gripper.' );
  end
end
