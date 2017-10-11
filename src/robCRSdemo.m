function robCRSdemo( robot )
%ROBCRSDEMO  Simple demo for robot T2.
%
%   robT2demo( robot )

% (c) 2010-01-28, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

bbmovedeg( robot, [ 0 0 0 0 0 0 ] );
bbwaitforready( robot );

fprintf( 'Moving each axis separately...\n' )
bbsetspeed( robot, robot.defaultspeed );

deg = [-160 -80 -100 180 100 170];
d = zeros( 1, 6 );
for ax = 1:6
  d(ax) = deg(ax);
  bbmovedeg( robot, d );
  bbwaitforready( robot );
  d(ax) = 0;
  bbmovedeg( robot, d );
  bbwaitforready( robot );
end
fprintf( '  ... done\n' );

% ------------------------------------------------------------------------------
fprintf( 'Moving all axes, non-coordinated...\n' );

pos = [-10  10 -10 -10  10 -10
        30 -70  40  50 -60  40
        30 -70   0  50  30  40
        30 -70  40  50 -60  40 ];

pos = [ pos; pos(1,:) ];

for inx = 1:size( pos, 1 )
  bbmovedeg( robot, pos( inx, : ) );
  bbwaitforready( robot );
end
fprintf( '  ... done\n' );

% ------------------------------------------------------------------------------

fprintf( 'Moving all axes, same trajectory, coordinated...\n' );
bbmovedegs( robot, pos, 50, 5 );
fprintf( '  ... done\n' );

% ------------------------------------------------------------------------------

if( isfield( robot, 'gripper' ) )
  fprintf( 'Gripper control...\n' );
  bbmovedeg( robot, [ 40 -30 -30 0 -30 0 ] )
  bbgrip( robot, 0 );
  bbwaitforready( robot )
  bbwaitforgrip( robot )

  bbgrip( robot, 0.2 );
  bbwaitforgrip( robot )

  bbgrip( robot, -0.2 );
  bbwaitforgrip( robot )
  bbgrip( robot, 0.2 );
  bbwaitforgrip( robot )
  bbgrip( robot, -0.2 );
  bbwaitforgrip( robot )
  bbgrip( robot, 0 );
end

% ------------------------------------------------------------------------------
bbsetspeed( robot, robot.defaultspeed );

fprintf( 'Soft home...\n' );
bbsofthome( robot );
