function [new_signal, new_channels] = group_channels(signal, channels, groups)
% GROUP channels
% This functions generates new channels meaning some choosen channels.

new_signal = zeros(size(groups,1), size(signal, 2));
new_channels = groups(:, 1);
for nG = 1:size(groups,1)
    [~, chs_merge] = intersect(channels, groups{nG, 2});
    
    % Checking if channels weren't exclude (bad channels)
    if( ~isempty(chs_merge) )
        new_signal(nG,:) = mean(signal(chs_merge,:), 1);
    else
        new_signal(nG,:) = NaN;
    end
end

end