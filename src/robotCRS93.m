function robot = robotCRS93( robot )
%ROBOTBOSCH  Robot specification: CRS93.
%
% For description of common parameters see ROBOTDEF.

% (c) 2009-05, V. Smutny ???
% (c) 2010-01-27, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% ------------------------------------------------------------------------------
% Specific parameters for the 1993 instance of CRS

robot.description = 'CRS 1993 with gripper';

% Base position in IRC - calibrated !!
% (corresponds to position robot.hhdeg in degrees)
robot.hhirc = [ -181650, -349, -62200, 99200, 8300, -96500];

% Robot bounds in IRC
robot.bound = [-370000, -100000, -190000,  -5000, -50000, -199500;...
                 10000,  100000,   63000, 203500,  67000,  4600];

% Speed reduced due to power suply problem
robot.defaultspeed = [30, 8, 20, 30, 30, 75].*256;
robot.defaultacceleration = round([0.2,(8/200),(20/250),(30/200), 1/2, 3].*256); 

% Axis (motor) of gripper
robot.gripper_ax = 'G';

% Gripper range
robot.gripper_bounds = [840 103];
robot.gripper_bounds_force = [840+1000 103-1000];% TODO must be verified

% ------------------------------------------------------------------------------
% Common parameters for CRS robots
robot = robCRScommon( robot );
