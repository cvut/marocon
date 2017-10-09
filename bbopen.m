function robot = bbopen( robotname, comport )
%BBOPEN  Open the robot communication.
%
%   robot = bbopen( robotname [, comport] )
%
%   Input:
%     robotname .. name of a robot (string). 
%     comport   .. serial port the robot is conected to (string, e.g. 'COM1'),
%                  default is taken from robot specification.
%   Output:
%     robot .. robot control structure.
%
%   Opens the communication channel. For a particular robotname, there must 
%   be robot specification available in a function ['robot',robotname]. Some
%   specifications are available within this toolbox, others can reside
%   somewhere in the Matlab's path.
%
%   By default, verbose messages are turned on. To turn them off set
%     robot.verbose = 0;

% (c) 2001-01, Ondrej Certik
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( nargin < 1 )
  bbrobots
  error('Robot name required. ')
end

% Read the robot specification
robot = [];
eval(['robot=robot',robotname,'(robot);']);

if( nargin > 1 && ~isempty( comport ) )
  robot.portname = comport;
else
  if( ~isfield( robot, 'portname' ) )
    error( [ 'COM port is not specified neither in robot specification ' ...
             'nor as an argument' ] );
  end
end

% Low-level COM port IO
robot.com = bbcomlib_serial;
robot.com.open( robot );

% Set timeout in seconds
robot.com.settimeout( 5 );

% This flag indicate if bbinit has executed
robot.hhflag = 0;

robot.verbose = 1;
