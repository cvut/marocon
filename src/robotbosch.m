function robot = robotbosch( robot )
%ROBOTBOSCH  Robot specification: bosch
%
% For description of common parameters se ROBOTDEF.

% (c) 2008-07, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% ------------------------------------------------------------------------------
% Specific parameters for this robot

% Robot link dimensions (these constants are read from documentation)
robot.L1 = 250;   
robot.L2 = 200; 

% Pavel Krsek measured 27th of September 2003
% robot.degtoirc = [947.4865 611.9475 ? 395.9611]
robot.irc = [-1080 -1080 1080 1080];

% Joint motors' gearing
%  robot.gearing = [80 50 1 (3*11)]; % original numbers
%robot.gearing = [78.9572 50.9956 1 32.9967];
robot.gearing = [78.9572 50.9956 37 32.9967];
% TODO joint 3 must be precisely calibrated

%11200 (134428) = 300mm

% ------------------------------------------------------------------------------
% General parameters (required)
robot.description = 'Bosch SR450s';

robot.DOF = 4;
robot.activemotors = 'ABCD';

% Softhome position in IRC and degrees/mm.
robot.hhirc = [0 0 0 0]; 
robot.hhdeg = [0 0 0 0];

% 1 degree/mm in IRC units
robot.degtoirc = robot.irc .* robot.gearing .* 4 ./ 360;

% Robot bounds in deg/mm converted to IRC
robot.bound = bbdegtoirc( robot, [  85  120 -330 -20
                                   -85 -120  5 1080 ] );
% 2010-01-29, Martin Matousek
% this are the realy hard bounds. Its no possible to 
% to reach them with full speed.
% robot.bound should be chosen with some reserve

truebound = [ -86200 -79000 -147000 -9000
               86900  75400    2500 428000  ];

if( any( robot.bound( 1, : ) < truebound( 1, : ) ) || ...
    any( robot.bound( 2, : ) > truebound( 2, : ) ) )
  error( 'Internal err. in robot parameters.' );
end


% Speeds (IRC/256/msec)
robot.minspeed =     [  1000  1000 1000 1000 ];
robot.maxspeed =     [ 10000 10000 5000 5000 ];
robot.defaultspeed = [ 10000 10000 5000 5000 ];

% Accelerations
robot.minacceleration =     [   0   0   1   1 ];
robot.maxacceleration =     [ 100 100 100 100 ];
robot.defaultacceleration = [  30  30  20  30 ];

robot.controller = 'MARS8';

% ------------------------------------------------------------------------------
% General parameters (optional)

robot.ikt = @(r,p) robboschikt(r,p);

robot.portname='/dev/ttyUSB0'; % corrected from COM4  26.3.2013 by Smutny
robot.BaudRate=19200; % Comport baud rate (default 19200 baud)


robot.REGPWRON=1; % user must press arm power button

robot.REGPWRFLG=5;
robot.REGCFG=[1498 1498 1370 1498];

% Set energies and PID
robot.REGME = [30000 16000 16000 16000];
robot.REGP=[50,50,50,50];
robot.REGI=[5,5,5,5];
robot.REGD=[50,50,50,50];

% Bosch robot shall not release after some time
robot.IDLEREL = 0;

%This variable use bbmovex, for help see this fucntion.
robot.pose = 0; % TODO
