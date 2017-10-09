function deg = bbgetdeg( robot )
%BBGETDEG  Query current joint positions in degrees/mm.
%
%   angles = bbgetirc( robot )
%
%   Input:
%     robot  .. robot control structure
%
%   Output:
%     angles .. joint coordinates in degrees/mm.
%
%   The joint positions are read using BBGETIRS, then converted to 
%   degrees or milimeters.

% (c) 2010-02-16, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

deg = bbirctodeg( robot, bbgetirc( robot ) );
