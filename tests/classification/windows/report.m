function report()

sizes = [.5 1 1.5 2 3 4] * 1000;
for size = sizes
    load( sprintf('%s/accs_chs_WIN_%04d', 'WINDOWS', size) );
    
    medians = median(accs, 2);
    for m = medians'
        fprintf('%04d\t%.4f\n', size, m);
    end
end

end