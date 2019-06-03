function [times, lanes, valves, actions] = load_schedule(filename)
    [num, text, raw] = xlsread(filename, 'A1:D1000');
    
    times = num(:,1);
    
    if(size(num, 2) > 1)
        lanes = num(:,2);
    else
        lanes = zeros(size(num, 1), 1);
    end
    lane_text = text(2:end, 2);
    lanes(find(strcmp(lane_text, 'All Lanes'))) = 0;
    
    valves = text(2:end, 3);
    
    actions = text(2:end, 4);
end