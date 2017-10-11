function bbsetacceleration( robot, accels )
%BBSETACCELERATION  Set acceleration for each axis.
%
%   bbsetacceleration( robot, accels )
%
%   Input:
%     robot   .. robot control structure
%     accels  .. vector containing for each axis the desired acceleration or
%                NaN if the particular acceleration should not be set.
%                Acceleration relatively to min/max range can be specified as
%                imaginary number, e.g. 0.2i is 20%.
%
%   CAUTION: controller parameters are tuned for robot working with default
%   speed and acceleration. Setting other speed/acceleration can lead to
%   instabilities in regulation, etc, and should be used with care.
%
%   See also BBSETACCELERATION.

% (c) 2008-05-12, Pavel Krsek
% (c) 2010-01-27, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

if( size( accels, 2 ) ~= robot.DOF )
  error( 'Wrong number of joints (%i, should be %i).', ...
         size(accels,2), robot.DOF );
end

for i = 1:robot.DOF
  if( robot.activemotors(i) ~= ' ' )
    if( isnan( accels(i) ) ) % no value in accels
      
    elseif( imag( accels(i) ) || accels(i) == 0 ) % relative speed
      r = imag( accels(i) );

      if( r < 0 || r > 1 )
        error( 'Relative acceleration %i out of <0;1>', i );
      end
      
      accels(i) = round( robot.minacceleration(i) * ( 1 - r ) + ...
          robot.maxacceleration(i) * r );
      robot.com.writeline( 'REGACC%s:%i', robot.activemotors(i), accels(i) );

    elseif( accels(i) < robot.minacceleration(i) || ...
            accels(i) > robot.maxacceleration(i) )      
      % acceleration is not inside lower and upper bound
      error( 'Acceleration %i out of bound', i );
    else % set the acceleration
      robot.com.writeline( 'REGACC%s:%i', robot.activemotors(i), accels(i) );
    end
  end
end
