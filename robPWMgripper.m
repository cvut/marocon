function robPWMgripper( robot, power )
%ROBPWMGRIPPER  Direct PWM gripper control.
%
%   robPWMgripper( robot, power )
%
%   Gripper controlled by direct PWM. Suitable for e.g. magnetic gripper.
%
%   Input:
%     robot .. robot control structure.
%     power .. PWM power, real number from 0 (off) to 1 (max)

% (c) 2005-10-05, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

power = max( power, 0 );

pwm = round( robot.gripper_max * power );
if( pwm < 0 || pwm > robot.gripper_max )
  error( 'Gripper power out of bounds.' );
end

robot.com.writeline( [ 'PWM' robot.gripper_ax ':' num2str( pwm )] );
