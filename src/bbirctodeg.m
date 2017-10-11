function b = bbirctodeg( robot, a )
%BBIRCTODEG  Conversion of angles in IRC units to degrees/mm.
%
%   b = bbirctodeg( robot, a )
%
%   Converts joint coordinates in IRC hardware units to degrees.
%
%   Input:
%     robot .. robot control structure
%     a     .. joint coordinates in IRC units
%              (Multiple lines corresponds to multiple positions)
%   Output:
%     b     .. computed joint coordinates in degrees (same size as a) 

% (c) 2001-01, Ondrej Certik
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( size( a, 2 ) ~= robot.DOF )
  error( 'Wrong number of joints (%i, should be %i).', size(a,2), robot.DOF );
end

n = size( a, 1 );
b = ( a - repmat( robot.hhirc, n, 1 ) ) ./ repmat( robot.degtoirc, n, 1 ) + ...
    repmat( robot.hhdeg, n, 1 );
