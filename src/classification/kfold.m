function [ accs ] = kfold( k, repetitions, feats, net, acctxt )
%KFOLD_CV - k-fold cross-validation
% Detailed explanation goes here

blocks = unique(feats.block);
nBlocks = length(blocks);
size_parts = ceil(nBlocks / k);

acc_idx = 0;
accs = zeros(1, k*repetitions);
base_net = net;
for nR = 1:repetitions
    for nB = 1:size_parts:nBlocks
        acc_idx = acc_idx + 1; % ACC number
        
        lastPos = min([nB+size_parts-1 nBlocks]);
        b_test = blocks( nB:lastPos ); % Blocks to be included in tests (first k)
        s_idx = ( ismember(feats.block,  b_test) ); % Indexes of blocks that will be used in tests
        
        net = train(net, feats.features( :, ~s_idx), feats.classes(:, ~s_idx)); % Train with block not used for tests (length of blocks - k)
        out_test = net( feats.features(:, s_idx));
        er = confusion( feats.classes(:, s_idx), out_test);
        acc = 1-er;
        accs(acc_idx) = acc;
        %utils.imgs.print_fig( fullfile( config.imgsexport_dir, sprintf('SUBJ%03d.png', nS) ) );
        acc_txt = sprintf('[%d] \t %.2f%% \t %d \t %d', acc_idx, acc*100, sum(s_idx), sum(~s_idx));
        %utils.file.txt_write(acctxt, acc_txt, 0, 0);
        clear net;
        net = base_net;
    end
end

end

