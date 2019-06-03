function image_filenames = extract_nd2_directory(nd2_directory_name, fov, z_slice)
    fprintf('Importing .nd2 files in "%s"...\n', nd2_directory_name);
    
    % Get full paths to all .nd2 files in the folder.
    nd2_directory_contents = dir(nd2_directory_name);
    nd2_directory_all_filenames = lower({nd2_directory_contents([nd2_directory_contents.isdir] == 0).name})';
    nd2_filename_regex = '.*.nd2)';
    nd2_filenames = nd2_directory_all_filenames(~cellfun('isempty', regexp(nd2_directory_all_filenames, nd2_filename_regex)));
    nd2_filenames_with_path = strcat(nd2_directory_name, '/', nd2_filenames);
    
    % Extract .tif files of all .nd2 files in the folder at the given z-slice
    % and field of view.
    fprintf('Extracting .tif files (FOV: %d, Z: %d)...\n', fov, z_slice);
    num_images = 0;
    for nd2_filename_index = 1:length(nd2_filenames_with_path)
        % Extract .tif files.
        tif_output_directory = strrep(strcat(pwd, '/', num2str(nd2_filename_index)), ' ', '\ ');
        nd2_filename_with_path = strrep(nd2_filenames_with_path{nd2_filename_index}, ' ', '\ ');
        command = sprintf('python extract_images.py -i %s -o %s -z %d -f %d', nd2_filename_with_path, tif_output_directory, z_slice, fov);
        system(command);

        % Count how many .tif files were extracted.
        tif_output_directory = strcat(pwd, '/', num2str(nd2_filename_index));
        tif_output_directory_contents = dir(tif_output_directory);
        tif_filenames = {tif_output_directory_contents([tif_output_directory_contents.isdir] == 0).name}';
        num_images = num_images + length(tif_filenames);
    end
    
    image_filenames = cell(num_images, 1);

    % Sequentially load the .tif files that were extracted.
    next_image_index = 1;
    fprintf('Importing extracted .tif files...\n');
    for nd2_filename_index = 1:length(nd2_filenames_with_path)
        tif_directory = strcat(pwd, '/', num2str(nd2_filename_index));

        tif_directory_contents = dir(tif_directory);
        nd2_image_filenames = strcat(tif_directory, '/', {tif_directory_contents([tif_directory_contents.isdir] == 0).name}');
        for image_filename_index = 1:length(nd2_image_filenames)
            image_filenames{next_image_index} = nd2_image_filenames{image_filename_index};
            next_image_index = next_image_index + 1;
        end
    end
end