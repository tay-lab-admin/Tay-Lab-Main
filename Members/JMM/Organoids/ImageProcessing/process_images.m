function [organoids, segmentations] = process_images(image_filenames)
    fprintf('Processing organoid images... (none loaded)');

    segmentations = cell(length(image_filenames), 1);
    positionList = [];
    lastCentroids = [];

    last_print = 12;
    for frame_number = 1:length(image_filenames)
        fprintf(repmat('\b', 1, last_print));
        last_print = fprintf('%d of %d completed).', frame_number, length(image_filenames));
        
        image = imread(image_filenames{frame_number});
        segmentations{frame_number} = segmentImage(image, lastCentroids);

        organoids = regionprops(segmentations{frame_number}, {'Area', 'Centroid', 'MajorAxisLength', 'Orientation'});

        properties = cell2mat([{organoids.Centroid}' {organoids.MajorAxisLength}', {organoids.Orientation}'])';
        if length(properties) == 0
            frame_number
        end
        lastCentroids = properties(1:2, :)';

        newColumns = [properties;repmat(frame_number, 1, size(properties, 2))];

        positionList = [positionList newColumns];
    end

    param = struct();
    param.mem = 20;
    param.dim = 2;
    param.good = 40;
    param.quiet = 1;

    maxdisp = 20;

    fprintf('\nTracking organoids...\n');
    organoids = track(positionList', maxdisp, param);
end