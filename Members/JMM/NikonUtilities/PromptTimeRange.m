function [startPoint, endPoint] = PromptTimeRange(file)
    maxTimepoint = double(file.data.timepointCount);
    
    text = strcat('Start timepoint (1-', num2str(maxTimepoint), '): ');
    startPoint = input(char(text));
    if startPoint < 1 || startPoint > maxTimepoint
        disp('Out of range. Defaulting to 1.')
        startPoint = 1;
    end
    
    text = strcat('End timepoint (1-', num2str(maxTimepoint), '): ');
    endPoint = input(char(text));
    if endPoint < startPoint || endPoint > maxTimepoint
        disp(strcat('Out of range. Defaulting to ', maxTimepoint, '.'));
        endPoint = maxTimepoint;
    end
end

