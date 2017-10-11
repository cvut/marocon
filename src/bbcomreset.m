%BBCOMRESET  Try to close and free all COM ports in use.
%
%   bbcomreset
%
%   By use this function, all opened communication channels (i.e., obtained
%   from BBOPEN) become invalid and must not be used henceforth. This
%   function should be used only if standard BBCLOSE is not usable (e.g.. if 
%   the handle is lost).

% (c) 2010-01-29, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

% Low-level COM port IO
com = bbcomlib_serial;

com.reset;
