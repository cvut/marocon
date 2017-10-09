function robot = robotboschmagnet( robot )
%ROBOTBOSCHMAGNET  Robot specification: bosch with magnetic gripper
%
% For description of common parameters se ROBOTDEF.

% (c) 2010-01-27, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot = robotbosch( robot );

robot.description = [ robot.description ' equipped with magnetic gripper' ];

% gripper specification

% Martin Matousek add 2005-10-05, updated 2010-01-27
% Magnetic gripper is controlled by direct PWM
robot.gripper = @(r,v) robPWMgripper(r,v);
robot.gripper_ax = 'H';
robot.gripper_max = 20000;
