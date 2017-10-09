function robot = robCRSgripperinit( robot )
%CRSGRIPPERINIT  CRS gripper initialization sequence.
%
%   robot = CRSgripperinit( robot )

% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

m = robot.gripper_ax;
% Set analog mode of controller
robot.com.writeline( 'ANAXSETUP%s:%i,%i', m, ...
                     robot.gripper_ADC, robot.gripper_current );

% Maximal curent limit (0-255)
robot.com.writeline( 'REGS1%s:%i', m, robot.gripper_current );

% Limitation constant (feedback from overcurrent)
robot.com.writeline( 'REGS2%s:%i', m, robot.gripper_feedback);

% Maximal energy limits voltage on motor
robot.com.writeline( 'REGME%s:%i', m, robot.gripper_REGME );

% Maximal speed
robot.com.writeline( 'REGMS%s:%i', m, robot.gripper_REGMS );

% Axis configuration word
robot.com.writeline( 'REGCFG%s:%i', m, robot.gripper_REGCFG );

% PID parameters of controller
robot.com.writeline( 'REGP%s:%i', m, robot.gripper_REGP );
robot.com.writeline( 'REGI%s:%i', m, robot.gripper_REGI );
robot.com.writeline( 'REGD%s:%i', m, robot.gripper_REGD );
