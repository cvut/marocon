function bbsetspeed( robot, speeds )
%BBSETSPEED  Set speed for each axis.
%
%   bbsetspeed( robot, speeds )
%
%   Input:
%     robot   .. robot control structure
%     speeds  .. vector containing for each axis the desired speed or
%                NaN if the particular speed should not be set. Speed
%                relatively to min/max range can be specified as
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

if( size( speeds, 2 ) ~= robot.DOF )
  error( 'Wrong number of joints (%i, should be %i).', ...
         size(speeds,2), robot.DOF );
end

for i = 1:robot.DOF
  if( robot.activemotors(i) ~= ' ' )
    if( isnan( speeds(i) ) ) % no value in accels
      
    elseif( imag( speeds(i) ) || speeds(i) == 0 ) % relative speed
      r = imag( speeds(i) );
      if( r < 0 || r > 1 )
        error( 'Relative speed %i out of <0;1>', i );
      end
      
      speeds(i) = round( robot.minspeed(i) * ( 1 - r ) + ...
          robot.maxspeed(i) * r );
      robot.com.writeline( 'REGMS%s:%i', robot.activemotors(i), speeds(i) );
    elseif( speeds(i) < robot.minspeed(i) || ...
            speeds(i) > robot.maxspeed(i) )      
      % speed is not inside lower and upper bound
      error( 'Speed %i out of bound', i );
    else % set the speed
      robot.com.writeline( 'REGMS%s:%i', robot.activemotors(i), speeds(i) );
    end
  end
end
