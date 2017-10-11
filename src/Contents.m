% BlueBot Robot Control Toolbox
% Version 0.9 Build r2 01-Jan-2010
%
% Functions
% ---------
%
% Startup/shutdown
%  bbopen      - Open the robot communication.
%  bbinit      - Robot initialization and homing.
%  bbclose     - Close the robot communication.
%  bbcomreset  - Try to close and free all COM ports in use.
%
% Low level robot motion
%  bbsofthome  - Soft homing.
%  bbcheckirc  - Check bounds of joint coordinates given in IRC units.
%  bbcheckdeg  - Check bounds of joint coordinates given in degrees/milimeters.
%  bbgetirc    - Query current joint positions in IRC units.
%  bbgetdeg    - Query current joint positions in degrees/mm.
%  bbmoveirc   - Move joints to position given in IRC units.
%  bbmoveircs  - Coordinated robot motion through positions given in IRC units.
%  bbmovedeg   - Move the joints to position given in degrees/mm.
%  bbmovedegs  - Coordinated robot motion through positions given in degrees/mm.
%  bbgrip      - Gripper control.
%  bbsetacceleration  - Set acceleration for each axis.
%  bbsetspeed         - Set speed for each axis.
%
%  bbisready       - Determine if the robot is ready.
%  bbwaitforready  - Wait until the robot is ready.
%  bbwaitforgrip   - Wait until the gripper finish move.
%  bbresetmotors   - Clear err state of all motors.
%  bbrelease        - Stop all motors and release its control.
%
% Conversions
%  bbdegtoirc  - Conversion of angles in degrees/mm to IRC units.
%  bbirctodeg  - Conversion of angles in IRC units to degrees/mm.
%
% Kinematics
%  bbdkt       - Direct kinematic task.
%  bbikt       - Inverse kinematic task.
%
% Other
%  bbdemo      - Demonstration of robot control by BlueBot toolbox.
%  bbrobots    - List available robots implemented in the toolbox.
%
%
% Note: The basic world units used in the functions are milimeters and degrees.
%
% For basic information of how to use the toolbox see/run bbdemo.
%
% About
% -----
%
% (c) 2001-2010 Center for Machine Perception (http://cmp.felk.cvut.cz)
% Department of Cybernetics
% Faculty of Electrical Engineering, Czech Technical University in Prague
