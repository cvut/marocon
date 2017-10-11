function robot = bbinit( robot, force_hh )
%BBINIT  Robot initialization and homing.
%
%   robot = bbinit( robot [, force_hh ] )
%
%   Performs robot and controller initialization, hardhome and softhome.
%   Can be called everytime the hardhome is needed.
%
%   Input/output:
%     robot .. robot control structure.
%     force_hh .. if true, force homing even if robot is allready homed
%                 (marked by a flag in robot control structure)

% (c) 2001-01, Ondrej Certik
% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( nargout ~= 1 )
    error( [ 'Output argument required.\n(This function modifies internal ' ...
        'state of the robot control structure.)' ], '' )
end

if( nargin < 2 ), force_hh = false; end

if( robot.hhflag && ~force_hh )
    do_hh = false;
else
    do_hh = true;
end

% this is a patch which will recover the serial communication
% from the read error after MARS 8 is switched on
% TODO rewrite
% if ~strcmp(robot.comlib, 'serial')
%     h=robot.handle;
%     if mod(get(h,'ReadStatus'),2)==1
%         fclose(robot.handle);
%         [result, msg] = fopen(h);  % open serial port
%         if result     % check if the port is open
%             error(msg);                  % display error message
%         end
%     end
% end

robot.com.settimeout( 5 ); % set timeout in seconds
robot.com.writeline( 'ECHO:0' );
pause(0.1); % wait until controller answers.
robot.com.flush;

if( isfield( robot, 'REGPWRON' ) )
    robot.com.writeline( 'REGPWRON:%i', robot.REGPWRON );
    fprintf( 'Press ARM POWER button,\n' );
    input( 'press enter to continue...', 's' );
    robot.com.writeline( 'REGPWRFLG:%i', robot.REGPWRFLG );
end

% Set specific robot constants.

% Stop any actions of the robot and purge any errors
bbresetmotors( robot );
bbisready( robot ); %this function raise err if for example arm power is off
bbwaitforready( robot );

% Initial hardware setting
bbsetspeed( robot, robot.defaultspeed );
bbsetacceleration( robot, robot.defaultacceleration );

for fld = { 'REGME' 'REGCFG' 'REGP' 'REGI' 'REGD' }
    f = fld{1};
    if( isfield( robot, f ) )
        for i = 1:robot.DOF
            if( robot.activemotors(i) ~= ' ' )
                robot.com.writeline( '%s%s:%i', f, robot.activemotors(i), ...
                    robot.(f)(i) );
            end
        end
    end
end

if( isfield(robot, 'IDLEREL' ) )
    robot.com.writeline( 'IDLEREL:%i', robot.IDLEREL );
end

% Setup gripper controller
if( isfield( robot, 'gripper_init' ) )
    if( robot.verbose )
        fprintf( 'Gripper init.\n' );
    end
    
    robot = robot.gripper_init( robot );
end

% Smutny added 16.6.2012
% Smutny 2.5.2013 the problem occurred again, manual help (pulling robot
% arm) was needed
% the robot CRS93 has problems to get on when arm is horizontal
% the following command should help to start control loop.
if strcmp(robot.description(1:3),'CRS')
    robot.com.writeline('SPDTB:0,300');
end
%


% Do the hardhome. If the robot specification defines its own hardhome
% sequence (as a function handle), use it, otherwise run the default one.
if( do_hh )
    if( robot.verbose )
        fprintf( 'Running hardhome sequence.\n' );
    end
    
    if( isfield( robot, 'hardhome' ) )
        robot.hardhome( robot );
    else
        for i = 1:robot.DOF
            if robot.activemotors(i) ~= ' '
                robot.com.writeline( [ 'HH' robot.activemotors(i) ':' ] );
            end
        end
    end
    bbwaitforready(robot);
    
    if( robot.verbose )
        fprintf( 'Running bbsofthome.\n' );
    end
    
    %do the softhome
    bbsofthome( robot );
    
    % this flag indicate that bbinit has executed homing
    robot.hhflag = 1;
else
    if( robot.verbose )
        fprintf( 'Allready homed, skipping homing sequence.' );
    end
end

if( robot.verbose )
    fprintf( 'Init finished.\n' )
end


return
