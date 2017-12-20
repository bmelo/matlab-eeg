function plot_con_matrix( signal, config, name )
%PLOT_CON_MATRIX Summary of this function goes here
%   Detailed explanation goes here

nBands = size(config.bands, 1);
subp = 1;
%figure('Name',name,'NumberTitle','off','units','normalized','outerposition',[0 0 10 10]);
figure('Name',name,'NumberTitle','off','units','normalized','Position',[0 0 3840 2160]);
for nB = 1:nBands
    pos = config.bands(nB,1) : config.bands(nB,2);
    N = max( signal.N(:,:,pos), [], 3 );
    T = max( signal.T(:,:,pos), [], 3 );
    A = max( signal.A(:,:,pos), [], 3 );
    
    sBand = sprintf('[%d - %d]', pos(1), pos(end));
    subplot(nBands,3,subp);
    imagesc(N); colorbar; caxis([0 1]);
    title(['Neutral ' sBand]);
    subplot(nBands,3,subp+1);
    imagesc(T); colorbar; caxis([0 1]);
    title(['Tenderness ' sBand]);
    subplot(nBands,3,subp+2);
    imagesc(A); colorbar; caxis([0 1]);
    title(['Anguish ' sBand]);
    
    % Control of subplot
    subp = subp+3;
end

end

