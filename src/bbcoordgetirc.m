function [msec, seg_sqn, seg_par,angles] = bbcoordgetirc( robot )
%BBGETIRC  Query current joint positions in IRC units for coordinate joints.
%
%   angles = bbgetirc( robot )
%
%   Input:
%     robot  .. robot control structure
%
%   Output:
%     angles .. joint coordinates in IRC units for all axes.
%     msec  ..  current time in unit masked with 0xffff
%     seg_sqn .. number of spline segment
%     seg_par .. value of parameter t

% (c) 2017, Petrova Olga
% (c) 2001-01, Ondrej Certik
% (c) 2008-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

robot.com.flush;

angles = NaN( 1, robot.DOF );

if ~ isempty(robot.activemotors)
  string = robot.com.query('COORDAP');
  string = char(split(string,','));
  msec = str2double(string(1,:));
  seg_sqn = str2double(string(2,:));
  seg_par = str2double(string(3,:));
  if seg_par > 0
    angles = str2double(string(4:end,:));
  end
end