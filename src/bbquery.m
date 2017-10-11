function responce = bbquery( com )
%BBQUERY Query the control unit
%
%   Function queries the control unit and returns
%   a responce
%
%   responce = bbquery( com )

com.writeline(['\n' query '?\n']);

while true
    buf = com.readline;
    i = strfind(buf, [query, '=']);
    if isempty(i)
        continue
    end
    responce = buf((i+1):end);
    break
end
end

