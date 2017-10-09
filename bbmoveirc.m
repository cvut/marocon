function bbmoveirc( robot, irc )
%BBMOVEIRC  Move joints to position given in IRC units.
%
%   bbmoveirc( robot, irc )
%
%   Move all joints to given positions by non-coordinated movement.
%
%   Input:
%     robot .. robot control structure
%     irc   .. joint coordinates in IRC units

% (c) 2001-01, Ondrej Certik
% (c) 2008-07, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

bbcheckirc( robot, irc, true ); 

for i = 1:robot.DOF,
  if( robot.activemotors(i) ~= ' ' )
    % Usually IRC position are integer numbers. When MARS2 is used then IRCs 
    % are floats.

    if( isfield( robot, 'controler' ) && isequal( robot.controller, 'MARS2' ) )
      s = sprintf( '%0.3f', irc(i) );
    else 
      s = int2str( irc(i) );
    end
    % Send result string into controler
    robot.com.writeline( [ 'G' robot.activemotors(i) ':' s ] );
  end
end
