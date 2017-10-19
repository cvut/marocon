function bbcoordsplinet( robot, param, order, t )
%BBCOORDSPLINET  Coordinated robot motion along spline with given
%parameters.
%
%   bbcoordsplinet( param, order, t )
%
%   Robot moves along a spline in joint cordinates. For every axis (A) its  
%   position is given by an equation:
%   
%   xA(t) = x(0) + a1*t + a2*t^2  ..  for 2nd order 
%   xA(t) = x(0) + a1*t + a2*t^2 + a3*t^3  ..  for 3rd order 
%
%   Parameters are 
%
%  Input:
%    robot  .. robot control structure
%
%    param   .. list of coefficients in format [a1, a2, a3, b1, b2, b3...]
%               for 3rd order spline and coordinated axes A,B...
%               The list has length [order * DOF]
%
%    order   .. order of polynomial
%
%    t       .. see BBMOVEIRCS.
%
% (c) 2017-10-10, Petrova Olga

if nargin < 4
    t = 0;
end
if nargin < 3
	error('Too few parameters for coordsplinet.'),
end
if length(param) ~= robot.DOF*order
    error( 'Wrong number of parameters (%d, should be %d).', length(param), robot.DOF*order );
end

bbthcoordm(robot);
str = [num2str(t), sprintf(',%0d',[order, round(param)])];
robot.com.writeline( ['COORDSPLINET:',str]);
end

