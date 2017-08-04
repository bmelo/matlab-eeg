function outname = gen_filename( suffix, band )
%GEN_FILENAME
%   Generates filename to be used in this tool

if ~isempty(suffix), suffix = ['_' suffix]; end

outname = [sprintf('%d_%d', band) suffix];

end