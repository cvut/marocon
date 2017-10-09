function [value] = bbreaddigi( robot, index )
% BBREADDIGI Read digital input. 
%   [value] = bbreaddigi( robot [, index] )
%   reads binary value at given position, 
%   default position is 1
%
%   Input/output:
%     robot .. robot control structure.
%     index .. (optional) which bit should be read (1-based) - if not present, whole
%              array is returned
%     
%     value .. value at index-th bit (1 is 0th bit of robot inputs, 2 is 1st bit, etc.)

% (c) 2012-03, Jan Macak
% Last change: $Date:: 2012-03-22 10:39:32 +0100 #$
%              $Revision: 1 $
input_group = 1;
COMMAND = sprintf('DIGI%d', input_group);
INPUT_BITS_CNT = 16;

robot.com.writeline( [COMMAND '?'] ); % COMMAND for reading values for group 1
pause(0.1);% wait until controller answers.
s = robot.com.readline; % get answer
if s(1:length(COMMAND)) == COMMAND 
    d =  sscanf(s((length(COMMAND)+2):end),'%d'); % scan number
else
    error('Reading from digital input %d failed!', input_group);
end
values = mod(floor(d./2.^(0:INPUT_BITS_CNT-1)),2); % convert to binary-valued vector, lsb 0
if nargin > 1 
    if isempty(index)
        error('The second argument must not be empty!')
    end
    
    if index < 1 || index > length(values)
        error('Index must be in interval <1, %d>! Current value is %d.',length(values), index)
    end
    
    value = values(index);
else
    value = values; % return all bits
end