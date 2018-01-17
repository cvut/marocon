function robot = robCRScommon( robot )
%ROBCRSCOMMON Common specification for CRS robots.
%
%  Used by ROBOTCRS93 and ROBOTCRS97.
%
%  For description of common parameters see ROBOTDEF.

% (c) 2009-05, V. Smutny ???
% (c) 2010-01-27, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot.portname='COM4';
robot.controller = 'MARS8';
robot.demoname = 'robCRSdemo';

robot.DOF = 6;

% Robot link dimensions (these constants are read from documentation)
inch2mm = 25.4;       % conversion constant
robot.L1 = 13*inch2mm-25;  % J2 above working desk
robot.L2 = 12*inch2mm;     % J2-J3
robot.L3 = 13*inch2mm;     % J3-J5
robot.L4 = 3*inch2mm;      % J5-flange
robot.L5 =inch2mm*(3.78+0.5); % gripper length
robot.L6 =inch2mm*1;  % gripper finger length

% Posible change of coordinate direction
robot.direction = [1, 1, -1, -1, -1, -1];

%IRC per rotation of motor.
robot.irc = [1000 1000 1000 500 500 500]; % from manual, it should work
% motors' gearing
robot.gearing = [100, 100, 100, 101, 100, 101]; % from manual
%degtoirc=1 degree in IRC
robot.degtoirc = robot.irc .* robot.direction .* robot.gearing * 4 / 360;

robot.activemotors = 'ABCDEF';

% Base position in degrees
% (corresponds to position robot.hhirc in IRC)
robot.hhdeg = [0 0 0 0 0 0];

% Softhome position in degrees
%  - Robot is moved to this position during startup and closing.
%  - The position is set by calling bbsofthome
robot.shdeg = [0 0 -45 0 -45 0];

robot.REGME = [32000 32000 32000 32000 32000 32000];

% Constants of PID regulators
robot.REGP = [ 10,  12,  70,  35,  45, 100];
robot.REGI = [ 80,  63,  50,  80,  65, 300];
robot.REGD = [300, 200, 200, 130, 230, 350];

% min and max speeds (IRC/256/msec)
robot.minspeed = round(robot.defaultspeed./5);
robot.maxspeed = round(robot.defaultspeed.*2);

% min a max acceleration
robot.minacceleration = round(robot.defaultacceleration./5);
robot.maxacceleration = round(robot.defaultacceleration.*2);

% smutneho hodnoty robot.REGCFG = [1370 1369 1369 1361 1369 1369];
% D ma HW problem, protoze indexova znacka se casto nachazi o
% (mnoho)otacek jinde
% E nema indexy nikdy,
% problem D a E identifikovan: V rozporu s dokumentaci ma HEDS na D a E
% signal znacky v podmnozine kombinace kanalu AB=00, ackoliv by mel jit az
% do hrany A mezi 0 a 1 (ci naopak), pricemz B ma byt nula. Cip, ktery
% zpracovava signaly to jinak neumi.
% Potencialne to lze resit nejakym RC clankem mezi HEDS a budicem v robotu,
% daji se ocekavat problemy s ruznymi rychlostmi. Od tohoto reseni je
% upusteno.
% V teto verzi tedy D a E najizdi jen na MARK, nikoliv na indexovou znacku.
% robot.REGCFG = [1494 1494 1494 1484 1476 1492];% D melo 1498, 
% robot.REGCFG = [1492 1494 1494 1484 1476 1492];% D melo 1498, 

% Uprava rychlosti HOME
% robot.REGCFG = [1490 1491 1491 1482 1474 1490];% D melo 1498, 

% Speed reduced due to power suply problem
robot.REGCFG = [1489 1490 1490 1481 1474 1490];% D melo 1498, 

% CRS robot shall not release after some time
robot.IDLEREL = 1200;

% homing sequence
robot.hardhome = @(r) robCRShardhome(r);


robot.timeout = 200;


% Gripper parameters

robot.gripper = @(r, v) robCRSgripper(r, v);
robot.gripper_init = @(r) robCRSgripperinit(r);


% Kind of gripper (CRSGripper, Magnetic)
robot.gripper_type = 'CRSGripper';

% Analog input of position sensor
robot.gripper_ADC = 10;
% Maximal curent limit (0-255)
% Value 16 corresponds to 250mA when feedback is 500
robot.gripper_current = 16;
% Limitation constant (feeadback from overcurrent)
robot.gripper_feedback = 500;
% Maximal energy limits voltage on motor
% (0 - 32000 corresponds to 0-24V)
% 2010-02-17 Martin Matousek note:
% Manual says that gripper can survive up to 15 Volts, but
% force more than 75% must not be used longer then 15 second. Thus
% safe power seems to be 11.25 V. We are using more conservative value here
% 10/32 * 24 = 7.5 V

robot.gripper_REGME = 10000;
% Maximal speed
robot.gripper_REGMS = 500;
% Axis configuration word
robot.gripper_REGCFG = 256;
% PID parameter of controller
robot.gripper_REGP = 200;
robot.gripper_REGI = 0;
robot.gripper_REGD = 100;

robot.gripper_poll_time = 0.2;
robot.gripper_poll_diff = 50;

% DH notation
robot.offset = [        0;      270;       90;        0;        0;                          0]/180*pi;
robot.sign   = [        1;        1;        1;        1;        1;                          1];
robot.d      = [ robot.L1;        0;        0; robot.L3;        0; robot.L4+robot.L5+robot.L6];
robot.a      = [        0; robot.L2;        0;        0;        0;                          0];
robot.alpha  = [       90;        0;      270;       90;      270;                          0]/180*pi;
robot.base = eye(4);
robot.tool = [cos(-pi/2) 0 sin(-pi/2) 0; 0 1 0 0; -sin(-pi/2) 0 cos(-pi/2) 0; 0 0 0 1];

robot.ikt =  @(r, v) robCRSikt(r, v);
robot.dkt =  @(r, v) robCRSdkt(r, v);