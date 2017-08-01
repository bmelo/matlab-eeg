function [ accs ] = loocv( feats, net, acctxt )
%LOOCV - Summary of this function goes here
% LEAVE_ONE_OUT_CROSSVALIDATION

nBlocks = length( unique(feats.block) );
accs = zeros(1, nBlocks);
base_net = net;
for nB = 1:nBlocks
    s_idx = ( feats.block == nB );
    
    net = train(net, feats.features( :, ~s_idx), feats.classes(:, ~s_idx));
    out_test = net( feats.features(:, s_idx));
    er = confusion( feats.classes(:, s_idx), out_test);
    acc = 1-er;
    accs(nB) = acc;
    %utils.imgs.print_fig( fullfile( config.imgsexport_dir, sprintf('SUBJ%03d.png', nS) ) );
    acc_txt = sprintf('[%d] \t %.2f%% \t %d \t %d', nB, acc*100, sum(s_idx), sum(~s_idx));
    utils.file.txt_write(acctxt, acc_txt, 0, 1);
    clear net;
    net = base_net;
end

end

