function robot = robotCRS97( robot )
%ROBOTBOSCH  Robot specification: CRS97
%
% For description of common parameters see ROBOTDEF.

% (c) 2009-05, V. Smutny ???
% (c) 2010-01-27, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% ------------------------------------------------------------------------------
% Specific parameters for the 1997 instance of CRS

robot.description = 'CRS 1997 with gripper';

% Base position in IRC - calibrated !!
% (corresponds to position robot.hhdeg in degrees)
robot.hhirc = [ -182500, 252, -63625, 99200, 14300, -98150];

% Robot bounds in IRC
robot.bound = [-370000, -100000, -190000,  -5000, -44000, -199500;...
                 10000,  100000,   65000, 202000,  72000,  4000];

% Speed reduced due to power suply problem
robot.defaultspeed = [30, 8, 20, 30, 30, 55].*256;
robot.defaultacceleration = ...
    round([(30/400),(8/400),(20/400),(30/400), 1/2, 3/5].*256); 

% Gripper range
robot.gripper_bounds = [1001 48];
robot.gripper_bounds_force = [1001+100 48-1000]; % TODO must be verified

% Axis (motor) of gripper
robot.gripper_ax = 'H';

% ------------------------------------------------------------------------------
% Common parameters for CRS robots
robot = robCRScommon( robot );
