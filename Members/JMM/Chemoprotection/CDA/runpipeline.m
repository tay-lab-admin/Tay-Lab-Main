addpath('../../NikonUtilities');

if exist('file', 'var') == 0
    file = nd2file();
end

if exist('liveChannel', 'var') == 0
    liveChannel = 2
    deadChannel = 3;
end

positions = file.GetPositions();

[startPoint, endPoint] = PromptTimeRange(file);

liveCells = zeros(4, 6, endPoint-startPoint+1);
deadCells = zeros(4, 6, endPoint-startPoint+1);
for positionIndex = 1:length(positions)
    for timepointIndex = startPoint:endPoint
        fprintf('Processing position %s (time %d of %d). \n', positions(positionIndex), timepointIndex, double(file.data.timepointCount));
        liveImage = file.GetImage(positionIndex, timepointIndex, liveChannel, 0);
        deadImage = file.GetImage(positionIndex, timepointIndex, deadChannel, 0);
        
        positionName = char(positions(positionIndex));
        row = find('ABCD' == positionName(1));
        col = str2double(positionName(2));
        liveCells(row, col, timepointIndex-startPoint+1) = CountCells(liveImage, 6);
        deadCells(row, col, timepointIndex-startPoint+1) = CountCells(deadImage, 6);
    end
end