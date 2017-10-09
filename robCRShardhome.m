function robot = robCRShardhome( robot )
%CRSHARDHOME  Hardhome sequence suitable for CRS robots.
%
%   robot = CRShardhome( robot )
%
%   Hardhome sequence for CRS robot chosen such that the robot should not to
%   harm itself.

% (c) 2009-05, Pavel Krsek
% (c) 2010-01, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% First home the second joint. This should move the arm upwards. We must do
% this before rotating the first joint to eliminate contact between the
% gripper and the base pad (resulting to permanent circular arcs). 
robot.com.writeline( [ 'HH', robot.activemotors(2), ':' ] );
bbwaitforready( robot );

% Home the joints 1 and 3, resulting to upright position of the arm.
robot.com.writeline( [ 'HH', robot.activemotors(1), ':' ] );
robot.com.writeline( [ 'HH', robot.activemotors(3), ':' ] );
bbwaitforready( robot );

% Home the rest
robot.com.writeline( [ 'HH', robot.activemotors(4), ':' ] );
robot.com.writeline( [ 'HH', robot.activemotors(5), ':' ] );
robot.com.writeline( [ 'HH', robot.activemotors(6), ':' ] );
bbwaitforready( robot );
