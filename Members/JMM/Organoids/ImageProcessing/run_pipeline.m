mode = questdlg('What type of data do you want to process?', 'Processing Mode', '.nd2 directory', '.tiff directory', 'Batch .tiff', '.nd2 directory');

switch mode
    case '.nd2 directory'
        % Pick a folder where the .nd2 files are.
        nd2_directory_name = uigetdir(pwd, 'Select a directory that contains .nd2 files.');
        fov = input('Enter a field of view (XY coordinate): ');
        z_slice = input('Enter a z-slice: ');
        [out_file, path] = uiputfile('*.avi', 'Output video filename');
        out_file = strcat(path, out_file);
    case '.tiff directory'
        % Pick a folder where the .nd2 files are.
        tif_directory_name = uigetdir(pwd, 'Select a directory that contains .tiff files.');
        [out_file, path] = uiputfile('*.avi', 'Output video filename');
        out_file = strcat(path, out_file);
    case 'Batch .tiff'
        % Pick a folder of .tiff folders.
        master_directory_name = uigetdir(pwd, 'Select a directory that contains directories of .tiff files.');
        video_out_directory = uigetdir(pwd, 'Select a video output directory');
end

frame_rate = input('Enter a frame rate: ');

switch mode
    case '.nd2 directory'
        image_filenames = extract_nd2_directory(nd2_directory_name, fov, z_slice, true);
    case '.tiff directory'
        image_filenames = extract_tif_directory(tif_directory_name);
end

if isequal(mode, '.nd2 directory') || isequal(mode, '.tiff directory')
    [organoids, segmentations] = process_images(image_filenames);
    export_annotated_video(out_file, organoids, segmentations, image_filenames, frame_rate);
    fprintf('Done.\n');
elseif isequal(mode, 'Batch .tiff')
    % Get full paths to all subfolders.
    master_directory_contents = dir(master_directory_name);
    master_directory_folder_names = {master_directory_contents(...
        [master_directory_contents.isdir] == 1 & ...
        cell2mat(cellfun(@(x) ~isequal(x, '.'), {master_directory_contents.name}, 'UniformOutput', false)) & ...
        cell2mat(cellfun(@(x) ~isequal(x, '..'), {master_directory_contents.name}, 'UniformOutput', false))).name}';
    folder_names_with_path = strcat(master_directory_name, '/', master_directory_folder_names);
    
    for folder_index = 1:length(folder_names_with_path)
        image_filenames = extract_tif_directory(folder_names_with_path{folder_index});
        [organoids, segmentations] = process_images(image_filenames);
        
        out_file = strcat(video_out_directory, '/', master_directory_folder_names{folder_index}, '.avi');
        export_annotated_video(out_file, organoids, segmentations, image_filenames, frame_rate);
    end
end


