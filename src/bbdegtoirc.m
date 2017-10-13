function b = bbdegtoirc( robot, a )
%BBDEGTOIRC  Conversion of angles in degrees/mm to IRC units.
%
%   b = bbdegtoirc( robot, a )
%
%   Converts joint coordinates in degrees to IRC hardware units.
%
%   Input:
%     robot .. robot control structure
%     a     .. joint coordinates in degrees
%              (Multiple lines corresponds to multiple positions)
%   Output:
%     b     .. computed joint coordinates in IRC units (same size as a) 

% (c) 2001-01, Ondrej Certik
% (c) 2008-04-30, Pavel Krsek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( size( a, 2 ) ~= robot.DOF )
  error( 'Wrong number of joints (%i, should be %i).', size(a,2), robot.DOF );
end

n = size( a, 1 );
b = ( a - repmat( robot.hhdeg, n, 1 ) ) .* repmat( robot.degtoirc, n, 1 ) + ...
    repmat( robot.hhirc, n, 1 );
