classdef bbcomlib_serial < handle
%BBCOMLIB_SERIAL  Interface to low-level COM port IO via Matlab's serial object.
%
%   Properties:
%     timeout         .. (ro) Last used timeout.
%     verbose         .. (rw) Verbosity, nozero is used to debug communication.
%
%   Methods:
%     open            .. Open COM port.
%     close           .. Close COM port.
%     readline        .. Read a line from COM port.
%     writeline       .. Write a line to COM port.
%     settimeout      .. Set COM port read timeout.
%     flush           .. Flush reading and writing on COM port.
%     query           .. Queries unit with given parameter
%
%   Static methods:
%     reset           .. Try to close and free all COM ports in use.

% (c) 2017, Petrova Olga
% (c) 2008-04, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

properties 
  verbose % verbosity used to debug comunication
end

properties (SetAccess = private )
  timeout % last used timeout
end

properties (SetAccess = private, GetAccess = private )
  handle  % COM port handle (Matlab's serial port object)
end

properties
  coordmv_commands_to_next_check  % property needed for coordmv 
  % throttle fnc due to limited capacity of command queue
end

properties
  stamp  % time stamp used for synchronization
end

methods( Static )

% ------------------------------------------------------------------------------
function reset()
%BBCOMLIB_SERIAL.RESET  Try to close and free all COM ports in use.
%  
%   bbcomlib_serial.reset

slist = instrfind( 'type', 'serial' );
for i = 1:length(slist)
  s = slist(i);
  if( isobject( s ) )
    if( isequal( s.status, 'open' ) )
      fprintf( 'Closing ''%s''\n', s.Port );
      fclose( s );
    end
    fprintf( 'Deleting serial object for ''%s''.\n', s.Port );
    delete( s );
  end
end

end % fcn


end % meths

methods

% ------------------------------------------------------------------------------
function s = bbcomlib_serial()
%BBCOMLIB_SERIAL/BBCOMLIB_SERIAL  Constructor.
%  
%   s = comlib_serial

s.verbose = 1;

end % fcn

% ------------------------------------------------------------------------------
function delete(s)
%BBCOMLIB_SERIAL/DELETE  Destructor.

if( ~isempty( s.handle ) )
  fprintf( 'Closing %s port in destructor.\n', s.handle.Port );
  s.close;
end

end % fcn

% ------------------------------------------------------------------------------
function open( s, robot )
%BBCOMLIB_SERIAL.OPEN  Open COM port.
%
%   s.open( robot )
%
%   Input:
%     robot .. control structure, fields used:
%       .portname
%       .BaudRate (optional)
%       .StopBits (optional)

if( ~isempty( s.handle ) )
  error( 'COM port is allready open.' );
end

s.handle = serial( robot.portname );
s.timeout = [];

set( s.handle, 'FlowControl', 'hardware' );

s.coordmv_commands_to_next_check = 0;
s.stamp = round(mod((now*1e7),hex2dec('7FFF')));

% Added by Pavel Krsek - Apr 2008
% Robot Bosch works with 9600 baud
if( isfield( robot, 'BaudRate' ) )
  set( s.handle, 'BaudRate', robot.BaudRate );
else
  % added 6th September 2007
  set( s.handle, 'BaudRate', 19200 ); 
end;    

% Added by Pavel Krsek - Apr 2008
% MARS2 has typically 2 stop bits
if( isfield( robot, 'StopBits' ) )
  set( s.handle, 'StopBits', robot.StopBits );
end;    
   
fopen( s.handle );  % open serial port
if( strcmp( s.handle.Status, 'closed' ) ) % TODO udelat positivni test
  error( 'The specified port cannot be open' ); 
end

s.synccmdfifo;

end % fcn

% ------------------------------------------------------------------------------
function close( s )
%BBCOMLIB_SERIAL/CLOSE  Close COM port.
%
%   s.close

if( isempty( s.handle ) )
  error( 'COM port is not open.' );
end

fclose( s.handle );
delete( s.handle );
s.handle = [];

end % fcn

% ------------------------------------------------------------------------------
function tx = readline( s )
%BBCOMLIB_SERIAL/READLINE  Read a line from COM port.
%
%   tx = s.readline
%
%   Reads a line from COM port controller. Line must be terminated with CRLF
%   (which is also included in tx).

if( isempty( s.handle ) )
  error( 'COM port is not open.' );
end

[tx, count, msg] = fscanf( s.handle ); %#ok

if( s.verbose )
  fprintf( '>>%s<<\n', tx );
end

if( msg )
  error( 'fscanf err: %s', msg );
end

end % fcn

% ------------------------------------------------------------------------------
function writeline( s, tx, varargin )
%BBCOMLIB_SERIAL/WRITELINE  Write a line to COM port.
%
%   s.writeline( tx )
%   s.writeline( format, ... )
%
%   The line mustn't be terminated with CRLF.

if( s.verbose )
  fprintf( '%s\n', sprintf( tx, varargin{:} ) );
end

fprintf( s.handle, '%s\n', sprintf( tx, varargin{:} ) );

end % fcn

% ------------------------------------------------------------------------------
function settimeout( s, timeout )
%BBCOMLIB_SERIAL/SETTIMEOUT  Set COM port read timeout (in seconds).
%
%   s.settimeout( timeout )

set( s.handle, 'Timeout', timeout ); 
s.timeout = timeout;

end % fcn

% ------------------------------------------------------------------------------
function flush( s )
%BBCOMLIB_SERIAL/FLUSH  Flush reading and writing on COM port.
%
%   s.flush
%
%   Flush any pending write operation on COM port and discard any characters 
%   from a receive buffer.

% no write flush code


if( s.verbose )
  fprintf( 'Flushing ...\n' );
end

while( s.handle.BytesAvailable )
  tx = fscanf( s.handle );
  if( s.verbose )
    fprintf( '[[%s]]\n', tx );
  end
end

if( s.verbose )
  fprintf( 'Flushed.\n' );
end

end % fcn

% -------------------------------------------------------------------------
function responce = query( s, q )
%BBQUERY Query the control unit
%
%   Function queries the control unit and returns
%   a responce
%
%   responce = bbquery( com )

s.writeline([10, q, '?']);

while true
    buf = s.readline;
    i = strfind(buf, [q, '=']);
    if isempty(i)
        continue
    end
    j = strfind(buf, [13, 10]);
    responce = buf((i)+length(q)+1:j-1);
    break
end
end % fcn
% -------------------------------------------------------------------------
function synccmdfifo( s )
%BBSYNCCMDFIFO  Syncronization of unit with program.
%
%   bbsynccmdfifo( robot )
%
%   Sends a time stamp to unit and waits until it returns.  
%
%   Parameters are 
%
%  Input:
%    robot  .. robot control structure
%
% (c) 2017-10-10, Petrova Olga


s.stamp = mod((s.stamp + 1),hex2dec('7FFF'));
s.writeline(['STAMP:',num2str(s.stamp)]);

while true
    buf = s.readline;
    i = strfind(buf, 'STAMP=');
    if isempty(i)
        continue
    end
    j = strfind(buf, [13, 10]);
    resp = buf((i)+6:j-1);
    if str2num(resp) == s.stamp
        break;
    end
end
end % fcn

end % meths

end % cls
