% artifacts remotion
artifact_remotion(epochs);
print(gcf,fullfile( outdir, 'std_ch_F5.png' ),'-dpng')

if( config.compute_results ); do_stats; end;
results_SL.(subj) = results;

%do_report;
