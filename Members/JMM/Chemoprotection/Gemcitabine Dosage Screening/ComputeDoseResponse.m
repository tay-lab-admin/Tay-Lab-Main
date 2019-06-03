addpath('../../NikonUtilities');

if exist('file', 'var') == 0
    file = nd2file();
end

if exist('liveChannel', 'var') == 0
    liveChannel = PromptChannel(file, 'live cells');
    deadChannel = PromptChannel(file, 'dead cells');
end

positions = file.GetPositions();

if exist('dosages', 'var') == 0
    dosages = zeros(1,length(positions));
    for positionIndex = 1:length(positions)
        dosages(positionIndex) = input(char(strcat({'Dosage for position '}, positions(positionIndex), {': '})));
    end
end

[startPoint, endPoint] = PromptTimeRange(file);

responses = zeros(endPoint-startPoint+1, length(positions));
for positionIndex = 1:length(positions)
    for timepointIndex = startPoint:endPoint
        fprintf('Processing position %s (time %d of %d). \n', positions(positionIndex), timepointIndex, file.data.timepointCount);
        liveImage = file.GetImage(positionIndex, timepointIndex, liveChannel, 0);
        deadImage = file.GetImage(positionIndex, timepointIndex, deadChannel, 0);
        liveAmount = sum(sum(liveImage));
        deadAmount = sum(sum(deadImage));
        responses(timepointIndex, positionIndex) = deadAmount/liveAmount;
    end
end