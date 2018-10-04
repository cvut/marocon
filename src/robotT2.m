function robot = robotT2( robot )
%ROBOTT2  Robot specification: single translation table Opten T2.
%
% For description of common parameters see BBROBOTDEF.

% (c) 2010-01-28, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% ------------------------------------------------------------------------------
% General parameters (required)

robot.description = 'Single translation table Opten T2';
robot.DOF = 1;
robot.activemotors = 'A';
robot.hhirc = [0]; 
robot.hhdeg = [0];
robot.degtoirc = [1]; 

% Robot bounds in IRC
robot.bound = [-106
               90.5];

% Speeds (IRC/256/msec)
robot.minspeed =     [   100 ];
robot.maxspeed =     [ 28000 ];
robot.defaultspeed = [ 10000 ];

% Accelerations
robot.minacceleration =     [   1 ];
robot.maxacceleration =     [  30 ];
robot.defaultacceleration = [  10 ];

robot.controller = 'MARS2';

% ------------------------------------------------------------------------------
% General parameters (optional)
robot.portname='COM1'; 

robot.BaudRate=9600; % Comport baud rate (default 19200 baud)
robot.StopBits=2;    % MARS2 has typically 2 stop bits

robot.REGCFG = bin2dec( { '111110010' } )';

% Set energies and PID
% TODO these are not tuned yet
robot.REGME = [ 32000 ];
robot.REGP  = [ 3 ];
robot.REGI  = [ 1 ];
robot.REGD  = [ 4 ];
