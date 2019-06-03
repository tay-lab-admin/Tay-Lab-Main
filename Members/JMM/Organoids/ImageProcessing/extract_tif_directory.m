function image_filenames = extract_tif_directory(tif_directory_name)
    fprintf('Importing .tif files in "%s"...\n', tif_directory_name);
    
    % Get full paths to all .tif files in the folder.
    tif_directory_contents = dir(tif_directory_name);
    tif_directory_all_filenames = lower({tif_directory_contents([tif_directory_contents.isdir] == 0).name})';
    tif_filename_regex = '.*.(tiff|tif)';
    tif_filenames = tif_directory_all_filenames(~cellfun('isempty', regexp(tif_directory_all_filenames, tif_filename_regex)));
    tif_filenames_with_path = strcat(tif_directory_name, '/', tif_filenames);
    
    image_filenames = tif_filenames_with_path;
end