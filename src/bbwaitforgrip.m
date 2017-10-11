function bbwaitforgrip( robot )
%BBWAITFORGRIP  Wait until the gripper finish move.
%
%   bbwaitforgrip( robot )
%
%   Input:
%     robot  .. robot control structure.

% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $


% TODO - pro PWM nesmysl - neco rozdelit a do definice

if( ~isfield( robot, 'gripper_ax' ) )
  error( 'This robot has no gripper_ax defined.' );
end

robot.com.flush;
robot.com.writeline( [ 'R' robot.gripper_ax ':' ] );
t = robot.com.timeout;
robot.com.settimeout( 200 ); % original value is 60, units???
s = robot.com.readline;
if( ~isempty( t ) )
  robot.com.settimeout( t );
end

switch( s )
  case [ 'R' robot.gripper_ax '!' 13 10 ] % OK, regulator ready
    % now wait for true motion stop
    % Martin Matousek, 2010-02-15
    last = inf;
    while( 1 )
      robot.com.writeline( [ 'AP' robot.gripper_ax '?' ] );
      s = robot.com.readline;

      if( isequal( s, [ 'FAIL!' 13 10 ] ) )
        error( 'Command ''AP'' returned ''FAIL!''' );
      end
      
      if( isequal(s(1:4), [ 'AP' robot.gripper_ax '=' ] ) )
        p = str2double( s(5:end-2) );
        if( abs( last - p ) < robot.gripper_poll_diff )
          break;
        end
        last = p;
      end
      pause( robot.gripper_poll_time );
    end
    return
  case [ 'FAIL!' 13 10 ]
    bbisready( robot );
    error( 'Command ''R:'' returned ''FAIL!''' );
  otherwise
    error( 'Unknown answer from command ''R:'': ''%s''.', s );
end
