function bbmovedegs( robot, degs, t, disc )
%BBMOVEDEGS  Coordinated robot motion through positions given in degrees/mm.
%
%   bbmovedegs( robot, degs, t, disc )
%
%   Moves robot through all positions in ircs by coordinated movement. 
%   The positions are defined by joint coordinates in degrees/mm. 
%
%   The degrees/milimeters are converted to IRC units, the actual motion 
%   is done using BBMOVEIRCS.
%
%  Input:
%    robot  .. robot control structure
%
%    degs   .. set of joint coordinates in degrees/mm
%              ([n x DOF], each row corresponds to one position)
%
%    time, disc .. see BBMOVEIRCS.

% (c) 2010-02-10, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

bbmoveircs( robot, bbdegtoirc( robot, degs ), t, disc );
