function numberOfCells = CountCells(X, minCellRadius)
    BW = imbinarize(X, 'adaptive', 'Sensitivity', 0.500000, 'ForegroundPolarity', 'bright');

    % Clear borders
    BW = imclearborder(BW);

    % Open mask with disk
    radius = minCellRadius;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imopen(BW, se);

    % Close mask with disk
    radius = minCellRadius;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imclose(BW, se);

    numberOfCells = length(regionprops(BW, 'Area'));
end

