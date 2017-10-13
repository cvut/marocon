function bbsetupcoord( rob, axes_list )
%BBSETUPCOORD Sets up coordinated axes.
%
%   bbsetupcoord( rob )
%
%   Performs coordinated axes initialization.
%
%   Input:
%     robot .. robot control structure
%     axes_list .. coordinated axes

%   (c) Petrova Olga, 2017

if nargin < 2
    axes_list = rob.activemotors;
end

bbwaitforready(rob);
axes_coma_list = join(cellstr(axes_list'), ',');
rob.com.writeline(['COORDGRP:', char(axes_coma_list), '\n']);
bbwaitforready(rob);
rob.coord_axes = axes_list;
% rob.last_trgt_irc = [];
end

