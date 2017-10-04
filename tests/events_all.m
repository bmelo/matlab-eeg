srate = 250;
outfile = fullfile('extra', 'events.txt');


fout = fopen(outfile, 'w');

fprintf(fout, 'number\tlatency\ttype\tduration\n');

conds = {'T' 'A'};
n = 1;
last = 0;
for run=1:4
    for cond = 1:2
        for trials = 1:4
            label = conds{cond};
            
            fprintf(fout, '%d\t%f\t%s\t%d\n', n  , last + 1, 'N', 10*srate);
            fprintf(fout, '%d\t%f\t%s\t%d\n', n+1, last + 10*srate + 1, label, 46*srate);
            fprintf(fout, '%d\t%f\t%s\t%d\n', n+2, last + 56*srate + 1, 'N', 5*srate );
            
            n = n+3;
            last = last + 61 * srate;
        end
    end
end

fclose(fout);