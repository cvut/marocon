function robT2demo( robot )
%ROBT2DEMO  Simple demo for robot T2.
%
%   robT2demo( robot )

% (c) 2010-01-28, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

bbsetspeed( robot, 0.5i );
bbmoveirc( robot, 0 );
bbwaitforready( robot );

bbsetspeed( robot, 0.1i );
bbmoveirc( robot, 10 );
bbwaitforready( robot );

bbsetspeed( robot, 0.3i );
bbmoveirc( robot, 30 );
bbwaitforready( robot );

bbsetspeed( robot, 0.5i );
bbmoveirc( robot, 50 );
bbwaitforready( robot );

bbsetspeed( robot, 1i );
bbmoveirc( robot, -50 );
bbwaitforready( robot );

% full speed, full range

bbsetspeed( robot, 1i );
bbsetacceleration( robot, 1i );

bbmoveirc( robot, robot.bound( 1, : ) );
bbwaitforready( robot );

bbmoveirc( robot,  robot.bound( 2, : ) );
bbwaitforready( robot );

bbsetspeed( robot, 0.5i );
bbmoveirc( robot, 10 );
bbwaitforready( robot );
