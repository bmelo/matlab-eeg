function outname = gen_filename( prefix, band )
%GEN_FILENAME
%   GEnerates filename to be used in this tool
outname = sprintf('%sEEG_%d_%d', prefix, band);

end

