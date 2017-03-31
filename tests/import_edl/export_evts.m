function [ evts ] = export_evts( txtfile )
%EXPORT_EVTS - exports evts to an txt file that can be used in EEGLAB
%   Detailed explanation goes here

[indir, filename] = fileparts(txtfile);
outfile = fullfile(indir, [filename '_evts.txt']);
content = fileread(txtfile);
fout = fopen(outfile, 'w');

srate = regexp(content, '(?<=; Sampling rate: )\d+(?= Hz)', 'match', 'once');
srate = str2double(srate);

evts = regexp(content, '(?<=;\s)\d+\.[^\n]+\d{2,}\s','match');
evts = regexp(evts, '\d+. (?<label>.*) (?<time>[\d:\.]+)[\r\n]$', 'tokens', 'once');

fprintf(fout, 'number\tlatency\ttype\n');
for n=1:length(evts)
    label = evts{n}{1};
    time_parts = regexp(evts{n}{2}, ':', 'split');
    time_s = ...
        str2double(time_parts{1})*3600+...
        str2double(time_parts{2})*60+...
        str2double(time_parts{3});
    
    fprintf(fout, '%d\t%f\t%s\n', n, (time_s*srate), label);
end
fclose(fout);

end

