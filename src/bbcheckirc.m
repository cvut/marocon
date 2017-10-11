function r = bbcheckirc( robot, irc, required )
%BBCHECKIRC  Check bounds of joint coordinates given in IRC units.
%
%  r = bbcheckirc( robot, irc [, required] )
%
%  Checks if joint coordinates are in bounds of physical robot joints.
%
%  Input:
%    robot    .. robot control structure
%    irc      .. joint coordinates in IRC units
%                (Multiple lines corresponds to multiple positions)
%    required .. if true, the function throws an error if positions are not in
%                bound (false default).
%  Output:
%    r        .. true if corresponding position is in bounds (same size as irc)

% (c) 2001-01, Ondrej Certik
% (c) 2008-04, Pavel Krsek (multiline improvement)
% (c) 2010-01-27, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( size( irc, 2 ) ~= robot.DOF )
  error( 'Wrong number of joints (%i, should be %i).', size(irc,2), robot.DOF );
end

n = size(irc,1);
r = ( ( irc >= repmat( robot.bound(1,:), n, 1 ) ) & ...
      (irc  <= repmat( robot.bound(2,:), n, 1 ) ) ) | ...
    repmat( robot.activemotors == ' ', n, 1 );

if( nargin > 2 && required && ~all(r(:)) )
  error( 'Joint coordinates out of bounds' );
end
