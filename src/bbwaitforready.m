function bbwaitforready( robot, sync )
%BBWAITFORREADY  Wait until the robot is ready.
%
%   bbwaitforready( robot )
%
%   Input:
%     robot  .. robot control structure.
%     sync   .. syncronization flag

% (c) 2001-01, Ondrej Certik
% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek

if nargin < 2
    sync = false;
end

if sync
    if( robot.verbose )
        fprintf( 'Syncrinizing ...\n' );
    end
    robot.com.synccmdfifo;
end
     
if( robot.verbose )
  fprintf( '  Waiting for ready ...\n' );
end
%pause(0.1);
robot.com.flush;
robot.com.writeline( 'R:' );

t = robot.com.timeout;
robot.com.settimeout( 200 ); % seconds
s = robot.com.readline;
if( ~isempty( t ) )
  robot.com.settimeout( t );
end

switch( s )
  case [ 'R!' 13 10 ] % OK, ready
    
  case [ 'FAIL!' 13 10 ]
    bbisready( robot );
    error( 'Command ''R:'' returned ''FAIL!''' );
  otherwise
    error( 'Unknown answer from command ''R:'': ''%s''.', s );
end

if( robot.verbose )
  fprintf( '    ... OK\n' )
end
