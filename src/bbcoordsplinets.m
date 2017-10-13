function bbcoordsplinets( robot, params, order, times )
%COORDSPLINETS Performs movement along slpine trajectory.
%   
%   bbcoordsplinets( robot, params )
%   
%   Function sequentually sends spline parameters. 
%
%   Input:
%     robot    .. robot control structure.
%     params   .. appropriate polynomial coefficients in format 
%                 [a1, a2, a3, b1, b2, b3...] for 3rd order spline and coordinated 
%                 axes A,B...
%                 The list has length [order * DOF] 
%     order   .. order of polynomial

%   (c) Petrova Olga, 2017

if nargin < 4
    times = zeros(size(params,1));
end
    
for i=1:size(params,1)
    bbcoordsplinet(robot, params(i,:), order, times(i));
end

end

