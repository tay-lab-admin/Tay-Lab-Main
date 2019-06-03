function plot_schedule(times, lanes, valves, actions)
    max_time = max(times)*1.1;
    min_time = 0;

    valves_data = ones(30,1)*max_time;

    for step = 1:length(times)
        time = times(step);
        lane = lanes(step);
        valve = valves(step);
        action = actions(step);

        valves_to_change = [];
        if strcmp(valve, 'Both') || strcmp(valve, 'Inlet')
            if lane == 0
                valves_to_change = [valves_to_change 2:2:30];
            else
                valves_to_change = [valves_to_change (2*lane-1)];
            end
        end
        if strcmp(valve, 'Both') || strcmp(valve, 'Outlet')
            if lane == 0
                valves_to_change = [valves_to_change 1:2:30];
            else
                valves_to_change = [valves_to_change (2*lane)];
            end
        end

        for valve_to_change = valves_to_change
            valve_entry = valves_data(valve_to_change, :);
            last_spot = max(find(valve_entry > 0));
            if strcmp(action, 'Open')
                if mod(size(valves_data, 2), 2) == 1
                    valves_data = [valves_data zeros(30, 1)];
                end
                valves_data(valve_to_change, last_spot) = valves_data(valve_to_change, last_spot) - (max_time - time);
                valves_data(valve_to_change, size(valves_data, 2)) = valves_data(valve_to_change, size(valves_data, 2)) + (max_time - time);
            elseif strcmp(action, 'Close')
                if mod(size(valves_data, 2), 2) == 0
                    valves_data = [valves_data zeros(30, 1)];
                end
                valves_data(valve_to_change, last_spot) = valves_data(valve_to_change, last_spot) - (max_time-time);
                valves_data(valve_to_change, size(valves_data, 2)) = valves_data(valve_to_change, size(valves_data, 2)) + (max_time - time);
            end
        end
    end

    %first row is inlet
    %second row is outlet
    %even columns are open-durations
    %odd columns are closed-durations
    %valves_data_spread = valves_data;
    valves_data_spread = zeros(45, size(valves_data, 2));
    for i = 1:15
        valves_data_spread(3*i-2, :) = valves_data(2*i-1, :);
        valves_data_spread(3*i-1, :) = valves_data(2*i, :);
    end
    h = barh(flipud(valves_data_spread), 'stacked');
    xlim([0,max_time])
    ylim([-1.8, 46]);

    yPoints = 1:45;
    set(gca, 'YTick', [yPoints(find(mod(yPoints, 3) ~= 0))+1])
    set(gca, 'yticklabel', {'Outlet';'Inlet'});
    xlabel('Time (minutes)')

    for i = find(mod(1:length(h), 2) == 0)
        set(h(i), 'FaceColor', [.47, .67 .19]);
    end
    for i = find(mod(1:length(h), 2) == 1)
        set(h(i), 'FaceColor', [.85, .33, .1]);
    end
end