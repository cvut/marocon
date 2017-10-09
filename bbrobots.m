function names = bbrobots()
%BBROBOTS  List available robots implemented in the toolbox.
%
%   bbrobots 
%   names = bbrobots

% (c) 2010-01-28, Martin Matousek
% Last change: $Date:: 2010-02-17 17:51:32 +0100 #$
%              $Revision: 2 $

a = dbstack( '-completenames' );
pth = fileparts( a(1).file );
n = dir( [ pth filesep 'robot*.m' ] );
nms = cell( length( n ), 1 );

maxlen = 0;
for i = 1:length(nms)
  nms{i} = n(i).name( 6:end-2 );
  maxlen = max( maxlen, length( nms{i} ) );
end

if( nargout < 1 )
  fprintf( 'Available robot definitions:\n' );
  for i = 1:length( nms )
    fprintf( '  %-*s', maxlen, nms{i} )
    robot = feval( [ 'robot' nms{i} ], [] );
    if( isfield( robot, 'description' ) )
      fprintf( ' .. %s', robot.description );
    end
    fprintf( '\n' );
  end
else
  names = nms;
end
