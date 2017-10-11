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

% (c) 2017, Petrova Olga
% (c) 2001-01, Ondrej Certik
% (c) 2008-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot.com.flush;

angles = NaN( 1, robot.DOF );

for i = 1:robot.DOF
  if( robot.activemotors(i) ~= ' ' )
    string = robot.com.query(['AP' robot.activemotors(i)]);
    angles(i) = str2double( string );
  end
end
