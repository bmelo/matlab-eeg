function outname = gen_filename( patt, band, srate )
%GEN_FILENAME
%   Generates filename to be used in this tool

suffix = '';
if nargin >= 3
   suffix = sprintf('_%d', srate);
end
if ~isempty(patt), patt = ['_' patt]; end

outname = [sprintf('%d_%d', band) patt suffix];

end