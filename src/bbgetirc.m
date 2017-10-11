function angles = bbgetirc( robot )
%BBGETIRC  Query current joint positions in IRC units.
%
%   angles = bbgetirc( robot )
%
%   Input:
%     robot  .. robot control structure
%
%   Output:
%     angles .. joint coordinates in IRC units for all axes.

% (c) 2001-01, Ondrej Certik
% (c) 2008-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot.com.flush;

for i = 1:robot.DOF
  if( robot.activemotors(i) ~= ' ' )
    robot.com.writeline( [ 'AP' robot.activemotors(i) '?:' ] );
  end
end

angles = NaN( 1, robot.DOF );

for i = 1:robot.DOF
  if( robot.activemotors(i) ~= ' ' )
    string = robot.com.readline;
    if( length(string) < 7 || ...
        ~isequal( string(1:4), [ 'AP' robot.activemotors(i) '=' ] ) )
      error( 'Unexpected response from ''AP'' command: ''%s''.', string );
    end
    angles(i) = str2double( string(5:end-2) );
  end
end
