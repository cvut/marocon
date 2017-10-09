function bbdemo( robotname, portname )
%BBDEMO  Demonstration of robot control by BlueBot toolbox.
%
%  Initializes controller, runs specific demo for particular robot
%  if defined and closes the communication.
%
%  bbdemo( robotname [ ,portname ] )
%
%  Note: used COM port (default or specified here) must not be in use. The
%  port is released after the demo ends.
%

% (c) 2010-01-28, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( nargin < 1 )
  error( 'Robot name must be specified.' );
end

fprintf( 'Please turn on controller and\n' );
fprintf( 'IDENTIFY THE LOCATION OF AN EMERGENCY STOP BUTTON.\n\n' );
input( 'Press ENTER when ready ....', 's' );

fprintf( 'Opening communication ...\n' );
if( nargin < 2 )
  robot = bbopen( robotname );
else
  robot = bbopen( robotname, portname );
end

robot.verbose = 0;

fprintf( 'Init and hardhome ...\n' );
robot = bbinit( robot );

if( isfield( robot, 'demoname' ) )
  demoname = robot.demoname;
else
  demoname = [ 'rob' robotname 'demo' ];
end

if( exist( demoname, 'file' ) == 2 )
  fprintf( 'Running %s. You can try to examine it ...\n', demoname )
  feval( demoname, robot );
else
  fprintf( 'Sorry, this robot has no demo implemented.\n' );
  fprintf( '(%s not found.)\n', demoname );
end

fprintf( 'Softhome and closing communication ...\n' );
bbclose( robot );
fprintf( 'Done.\n\n' );
