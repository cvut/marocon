function r = bbcheckdeg( robot, deg, required )
%BBCHECKDEG  Check bounds of joint coordinates given in degrees/milimeters.
%
%  r = bbcheckdeg( robot, deg [, required] )
%
%  Checks if joint coordinates are in bounds of physical robot joints.
%
%  Input:
%    robot    .. robot control structure
%    deg      .. joint coordinates in degrees/mm
%                (Multiple lines corresponds to multiple positions)
%    required .. if true, the function throws an error if positions are not in
%                bound (false default).
%  Output:
%    r        .. true if corresponding position is in bounds (same size as irc)
%
%   The degrees/milimeters are converted to IRC units, the actual check
%   is done using BBCHECKIRC.

% (c) 2010-02-17, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $
%

if( nargin < 3 ), required = 0; end

r = bbcheckirc( robot, bbdegtoirc( robot, deg ), required );
