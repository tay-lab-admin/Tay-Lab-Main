function [success, out_data] = load_schedule(filename)
    
    
    [num, ~, raw_schedule] = xlsread(filename, 'A1:E100');
    [~, ~, raw_globals] = xlsread(filename, 'H2:H4');
    
    fprintf('Loaded schedule.\n');
    
    out_data = struct();
    out_data.times = {};
    out_data.actions = {};
    out_data.solutions = {};
    out_data.rates = {};
    out_data.channels = {};
    out_data.outlet_hold_time = -1;
    out_data.experiment_side = '';
    out_data.speed_factor = -1;
    out_data.seconds_per_time_unit = 60;
    out_data.seconds_per_rinse_time_unit = 1;
    out_data.seconds_per_outlet_hold_time_unit = 1;
    
    % Import and check global parameters
    [outlet_hold_time, experiment_side, speed_factor] = raw_globals{1:3};
    if isnumeric(outlet_hold_time) && outlet_hold_time >= 0
        out_data.outlet_hold_time = outlet_hold_time * out_data.seconds_per_outlet_hold_time_unit;
    else
        errordlg(sprintf('Error loading XLS file. Invalid outlet hold time.'));
        success = false;
        return;
    end
    if isnumeric(speed_factor) && speed_factor >= 0
        out_data.speed_factor = speed_factor;
    else
        errordlg(sprintf('Error loading XLS file. Invalid speed factor.'));
        success = false;
        return;
    end
    if isequal(experiment_side, 'Both') || isequal(experiment_side, 'Right') || isequal(experiment_side, 'Left')
        out_data.experiment_side = experiment_side;
    else
        errordlg(sprintf('Error loading XLS file. Invalid experiment side.'));
        success = false;
        return;
    end
    
    num_rows = length(num(:, 1))+1;
    
    % Skip row 1 (header) and import+check steps.
    for row_number = 2:num_rows
        step_number = row_number-1;
        
        row = raw_schedule(row_number, :);
        
        [time, action, solution, rate, channel] = row{1:5};
        
        if isnan(time) || ~isnumeric(time)
            errordlg(sprintf('Error loading XLS file. Invalid time at step #%d.', step_number));
            success = false;
            return;
        else
            out_data.times{end+1} = time * out_data.seconds_per_time_unit;
        end
        
        if isequal(action, 'Pumped Delivery') || isequal(action, 'Flow Delivery') || isequal(action, 'Close All') || isequal(action, 'Rinse Left') || isequal(action, 'Rinse Right') || isequal(action, 'Rinse Lower')
            out_data.actions{end+1} = action;
        else
            errordlg(sprintf('Error loading XLS file. Invalid action at step #%d.', step_number));
            success = false;
            return;
        end
        
        if ~isempty(out_data.times)
            if length(out_data.times) > 1
                last_time = out_data.times{end-1};
            else
                last_time = 0;
            end

            if (out_data.times{end} - last_time) < 0
                errordlg(sprintf('Error loading XLS file. Step #%d is not chronologically valid (must occur after the previous step).', step_number));
                success = false;
                return;
            end
        end
        
        if isequal(action, 'Pumped Delivery')
            if isnumeric(rate) && ~isnan(rate)
                out_data.rates{end+1} = rate;
            else
                errordlg(sprintf('Error loading XLS file. Invalid rate for pumped delivery at step #%d.', step_number));
                success = false;
                return;
            end
        else
            if ~isnan(rate)
                errordlg(sprintf('Error loading XLS file. A rate was specified for action "%s" at step #%d. Rates should only be specified for pumped delivery.', action, step_number));
                success = false;
                return;
            else
                out_data.rates{end+1} = 0;
            end
        end
        
        if isequal(action, 'Close All')
            if ~isnan(solution)
                errordlg(sprintf('Error loading XLS file. Solutions were specified for action "%s" at step #%d. Solutions should only be specified for delivery.', action, step_number));
                success = false;
                return;
            else
                out_data.solutions{end+1} = [];
            end
        else
            if isnan(solution)
                errordlg(sprintf('Error loading XLS file. No solution was provided for action "%s" at step #%d.', action, step_number));
                success = false;
                return;
            else
                if ischar(solution)
                    solution = str2double(strtrim(strread(solution, '%s', 'delimiter', ',')))';
                end
                if sum(isnan(solution)) > 0
                    errordlg(sprintf('Error loading XLS file. An invalid solution list was provided at step #%d. Values should be separated by commas and be between %d and %d.', action, step_number, 1, 26));
                    success = false;
                    return;
                else
                    out_data.solutions{end+1} = solution;
                end
            end
        end
        
        if isequal(action, 'Close All') || isequal(action, 'Rinse Left') || isequal(action, 'Rinse Right') || isequal(action, 'Rinse Lower')
            if ~isnan(channel)
                errordlg(sprintf('Error loading XLS file. Channels were specified for action "%s" at step #%d. Channels should only be specified for delivery.', action, step_number));
                success = false;
                return;
            else
                out_data.channels{end+1} = [];
            end
        else
            if isnan(channel)
                errordlg(sprintf('Error loading XLS file. No channel was provided for action "%s" at step #%d.', action, step_number));
                success = false;
                return;
            else
                if ischar(channel)
                    if isequal(lower(channel), 'all')
                        if isequal(experiment_side, 'Left')
                            channel = 1:15;
                        elseif isequal(experiment_side, 'Right')
                            channel = 16:30;
                        elseif isequal(experiment_side, 'Both')
                            channel = 1:30;
                        end
                    else
                        channel = str2double(strtrim(strread(channel, '%s', 'delimiter', ',')))';
                    end
                end
                if sum(isnan(channel)) > 0
                    errordlg(sprintf('Error loading XLS file. An invalid channel list was provided at step #%d. Values should be separated by commas and be between %d and %d or be "ALL" (no quotes) for all channels.', action, step_number, 1, 30));
                    success = false;
                    return;
                else
                    out_data.channels{end+1} = channel;
                end
            end
        end
    end
    
    % Modify for speed factor
    out_data.times = cellfun(@(x) x/out_data.speed_factor, out_data.times, 'UniformOutput', false);
    
    out_data.outlet_hold_time = out_data.outlet_hold_time/out_data.speed_factor;

    success = true;
end