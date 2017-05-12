function plot_matrix( signal, srate, channels )
%PLOT_MATRIX Summary of this function goes here
%   Detailed explanation goes here
positions = {
    'Fp1' 5
    'Fpz' 6
    'Fp2' 7
    'F9' 14
    'AF7' 15
    'AF3' 16
    'AFz' 17
    'AF4' 18
    'AF8' 19
    'F10' 20
    'F7' 24
    'F5' 25
    'F3' 26
    'F1' 27
    'Fz' 28
    'F2' 29
    'F4' 30
    'F6' 31
    'F8' 32
    'FT9' 34
    'FT7' 35
    'FC5' 36
    'FC3' 37
    'FC1' 38
    'FCz' 39
    'FC2' 40
    'FC4' 41
    'FC6' 42
    'FT8' 43
    'FT10' 44
    'T9' 45
    'T7' 46
    'C5' 47
    'C3' 48
    'C1' 49
    'Cz' 50
    'C2' 51
    'C4' 52
    'C6' 53
    'T8' 54
    'T10' 55
    'TP9' 56
    'TP7' 57
    'CP5' 58
    'CP3' 59
    'CP1' 60
    'CPz' 61
    'CP2' 62
    'CP4' 63
    'CP6' 64
    'TP8' 65
    'TP10' 66
    'P7' 68
    'P5' 69
    'P3' 70
    'P1' 71
    'Pz' 72
    'P2' 73
    'P4' 74
    'P6' 75
    'P8' 76
    'P9' 80
    'PO7' 81
    'PO3' 82
    'POz' 83
    'PO4' 84
    'PO8' 85
    'P10' 86
    'O1' 93
    'Oz' 94
    'O2' 95
    };

%%%%%%%%%%%
figure;
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
for chan_num = 1:length(channels)
    chan_name = channels{chan_num};
    chan_pos = strcmp({positions{:,1}}, chan_name);
    
    pC = positions{ chan_pos, 2 };
    axes(chan_num) = subplot( 9, 11, pC );
    
    title( sprintf('%s', chan_name) );
    plot_task( signal(chan_num, :), [10 56] * srate );
end

ylim_equal( axes, [-80 180] );
adjust_x_time( axes, 66 );

set(axes(:), 'XTick',[], 'YTick',[]);

end

