function export_img( save_dir, filename )
%EXPORT_IMG Summary of this function goes here
%   Detailed explanation goes here

fprintf('Saving "%s" ...\n', fullfile(save_dir, filename));
utils.imgs.print_fig( fullfile(save_dir, filename) );

end

