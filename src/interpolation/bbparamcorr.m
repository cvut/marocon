function params = bbparamcorr( start, params, order )
%BBPARAMCORR Corrects parameters of spline to prevent error cumulation
%   bbparamcorr( params, order )
%
%   Corrects parameters of spline to prevent error cumulation along path. 
%   Function is called after trajectory interpolation.
%
%   Parameters are 
%
%  Input:
%    start  .. coordinates of startt position in ircs
%    params .. parameters of spline, matrix of size 
%              [robot.DOF*order x n_segments]. Each row contain 
%              coefficients of spline. For format see bbcoordsplinet.
%    order  .. order of polynomial
%
%  Output:
%    params .. corrected parameters of spline
%
% (c) 2017-10-10, Petrova Olga

[pos, oldpos, posnr] = deal(start);

for i=1:size(params,1)
    par = reshape(params(i,:), [order,length(start)]);
    pos = pos + round(sum(par));
    posnr = posnr + sum(par);
    dif = pos - posnr;
    
    par(end,:) = round(par(end,:)) - dif;
    pos = oldpos + sum(par);
    oldpos = pos;
    params(i,:) = reshape(round(par), [1,order*length(start)]);
end

end

