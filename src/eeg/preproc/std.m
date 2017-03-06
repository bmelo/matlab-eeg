function std( epochs )

canais = [1 2 46 47];
win_size = 500;

stds = struct('NEUTRAL', [], 'TASK_T', [], 'TASK_A', []);
flds = fields(epochs);

figure;
for nF=1:length(flds)
    field = flds{nF};
    stds.(field).data = [];
    
    for nE = 1:length(epochs.(field))
        data = epochs.(field)(nE).data;
        window = 1:win_size;
        while 1
            stds.(field).data = [stds.(field).data std(data(:,window)')'];
            window = window + floor((win_size/2));
            if( max(window) > length(data) )
                break;
            end
        end     
    end
    
    subplot( length(flds), 1, nF );
    plot(stds.(field).data(46, :));
    title( [field ' F_5'] );
    hold on;
    
end
print(gcf,fullfile( outdir, 'std_ch_F5.png' ),'-dpng')

end