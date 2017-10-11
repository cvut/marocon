function bbmovedeg( robot, deg )
%BBMOVEDEG  Move the joints to position given in degrees/mm.
%
%   bbmovedeg( robot, irc )
%
%   Moves all joints to given positions by non-coordinated movement.
%
%   The degrees/milimeters are converted to IRC units, the actual motion 
%   is done using BBMOVEIRC.
%
%   Input:
%     robot .. robot control structure
%     irc   .. joint coordinates in degrees/milimeters

% (c) 2010-01-29, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

bbmoveirc( robot, bbdegtoirc( robot, deg ) );
