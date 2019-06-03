function annotated_video_frame = export_annotated_video(output_file, organoids, masks, image_filenames, frame_rate)
    fprintf('Saving output video (%s)... (no images)', output_file);
    
    outputVideo = VideoWriter(output_file);
    outputVideo.FrameRate = frame_rate;
    open(outputVideo);

    [height, width] = size(imread(image_filenames{1}));
    
    last_print = 10;
    for image_index = 1:length(image_filenames)
        fprintf(repmat('\b', 1, last_print));
        last_print = fprintf('%d of %d frames completed).', image_index, length(image_filenames));
        
        plain_image = repmat(imadjust(imread(image_filenames{image_index})), 1, 1, 3);

        overlay = repmat(im2uint8(masks{image_index}), 1, 1, 3);
        overlay(:, :, 1) = 0;
        overlay(:, :, 3) = 0;
        overlay = overlay * (200/255);

        new_image = imfuse(plain_image, overlay, 'blend');
        frame_organoids = organoids((organoids(:, end-1) == image_index), :);
        for organoid_index = 1:size(frame_organoids, 1)
            organoid = frame_organoids(organoid_index, :);
            centroid = organoid(1:2);
            organoid_size = organoid(3);
            organoid_orientation = deg2rad(organoid(4));
            id = organoid(end);
            line_offset = [cos(organoid_orientation) -sin(organoid_orientation)] * (organoid_size/2);
            new_image = insertShape(new_image, 'circle', [centroid 10], 'LineWidth', 10, 'Color', 'red');
            new_image = insertShape(new_image, 'line', [centroid-line_offset centroid+line_offset], 'LineWidth', 10, 'Color', 'red');
            textPos = centroid + [60 0];
            if textPos(1) > width
                textPos = centroid - [60 0];
            end
            new_image = insertText(new_image, textPos, num2str(id), 'TextColor', 'red', 'FontSize', 30, 'BoxOpacity', 0.7, 'AnchorPoint', 'RightCenter', 'BoxColor', 'black');
        end

        plot_image = get_organoid_plot_image(organoids, image_index);
        frame_dim = size(plot_image);
        
        annotated_video_frame = zeros(height, width + frame_dim(2), 3, 'uint8');
        
        annotated_video_frame(:, 1:width, :) = new_image;
        annotated_video_frame(1:frame_dim(1), width+1:end, :) = plot_image;
        
        writeVideo(outputVideo, im2double(annotated_video_frame));
    end
    
    close(outputVideo);
    fprintf('\n');
end