function varargout = chip_control(varargin)
% CHIP_CONTROL MATLAB code for chip_control.fig
%      CHIP_CONTROL, by itself, creates a new CHIP_CONTROL or raises the existing
%      singleton*.
%
%      H = CHIP_CONTROL returns the handle to a new CHIP_CONTROL or the handle to
%      the existing singleton*.
%
%      CHIP_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHIP_CONTROL.M with the given input arguments.
%
%      CHIP_CONTROL('Property','Value',...) creates a new CHIP_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chip_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chip_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chip_control

% Last Modified by GUIDE v2.5 20-Jun-2017 23:58:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chip_control_OpeningFcn, ...
                   'gui_OutputFcn',  @chip_control_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before chip_control is made visible.
function chip_control_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chip_control (see VARARGIN)

addpath(genpath('API'))
if ispc
    rmpath(genpath('API/FTDI_MAC'));
else
    rmpath(genpath('API/FTDI_WIN'));
end

%% Set up chip data
global vc;
global application;
global chipdata;

chipdata = struct;
application = struct;

application.open = true;
application.red_color = [.85, .33, .1];
application.green_color = [.47, .67 .19];
application.navy_color = [0.149 0.149 0.149];
application.light_navy_color = [0.249 0.249 0.249];

chipdata.valves = struct;
chipdata.valves.upper_pump = 35:37;
chipdata.valves.middle_pump = [4 39 3];
chipdata.valves.lower_pump = 0:2;
chipdata.valves.supplies = [6:18 21:33];
chipdata.valves.rinse_left_1 = 5;
chipdata.valves.rinse_right_1 = 19;
chipdata.valves.rinse_left_2 = 20;
chipdata.valves.rinse_right_2 = 34;
chipdata.valves.divider = 38;
chipdata.valves.block = 40;
chipdata.valves.lanes = fliplr([41:55 57:71]);
chipdata.valves.rinse_lower = 56;
chipdata.valve_states = ones(1, 72);

chipdata.upper_pump = 1;
chipdata.middle_pump = 2;
chipdata.lower_pump = 3;
chipdata.pump_states = struct;
chipdata.pump_states.running = [false false false];
chipdata.pump_states.reverse = [false false false];
chipdata.pump_states.rate = [0 0 0];
chipdata.pump_states.last_update = {clock, clock, clock};
chipdata.pump_states.current_step = [0 0 0];
chipdata.pump_states.num_cycles = [0 0 0];
chipdata.pump_valves = [chipdata.valves.upper_pump; chipdata.valves.middle_pump; chipdata.valves.lower_pump];
chipdata.pump_pattern = [0, 1, 0; 0, 1, 1; 0, 0, 1; 1, 0, 1; 1, 0, 0; 1, 1, 0];

chipdata.channels = struct;
chipdata.channels.rinse_left_1 = 0;
chipdata.channels.solutions = [1:13 16:28];
chipdata.channels.rinse_right_1= 14;
chipdata.channels.rinse_left_2 = 15;
chipdata.channels.rinse_right_2= 29;
chipdata.channels.inlets = 30:59;
chipdata.channels.outlets = 60:89;
chipdata.channels.wastes = 90:119;
chipdata.channels.rinse_lower = 120:123;

v_pos_0_2 = [71 287;71 287-62; 71 287-(62*2)];
v_pos_3_4 = [71 97; 71 34];
v_pos_5_19 = [149:54.3:920;ones(1, 15)*34]';
v_pos_20_34 = [1030:54.3:1800;ones(1, 15)*34]';
v_pos_35_38 = [ones(1, 4)*1914;64:63:265]';
v_pos_39 = [1914 317];
v_pos_40_55 = [fliplr(1080:59:1970);ones(1, 16)*959]';
v_pos_56_71 = [fliplr(32:59:930);ones(1, 16)*959]';
chipdata.image_valve_positions = [v_pos_0_2;v_pos_3_4;v_pos_5_19;v_pos_20_34;v_pos_35_38;v_pos_39;v_pos_40_55;v_pos_56_71];

c_pos_0_14 = [174:54:940;ones(1,15)*101]';
c_pos_15_29 = [1055:54:1820;ones(1,15)*101]';
c_pos_30_44 = [57:59:890;ones(1,15)*662]';
c_pos_45_59 = [1104:59:1940;ones(1,15)*662]';
c_pos_60_74 = [57:59:890;ones(1,15)*755]';
c_pos_75_89 = [1104:59:1940;ones(1,15)*755]';
c_pos_90_104 = [57:59:890;ones(1,15)*897]';
c_pos_105_119 = [1104:59:1940;ones(1,15)*897]';
c_pos_120_123 = [939 742;939 898; 1045 742; 1045 898];
chipdata.image_channel_positions = [c_pos_0_14; c_pos_15_29; c_pos_30_44; c_pos_45_59; c_pos_60_74; c_pos_75_89; c_pos_90_104; c_pos_105_119; c_pos_120_123];

chipdata.procedure = struct;
chipdata.procedure.running = false;
chipdata.procedure.action = 'Idle';
chipdata.procedure.rate = 0;
chipdata.procedure.outlet_hold_time = 0;
chipdata.procedure.start_time = clock;
chipdata.procedure.pause_time = 0;
chipdata.procedure.solutions = [];
chipdata.procedure.experiment = 'Left';
chipdata.procedure.channels = [];
chipdata.procedure.all_phase = 'Rinse Left';
chipdata.procedure.all_cycle_time_sec = 1.5;
chipdata.procedure.use_pump = false;

chipdata.schedule = struct;
chipdata.schedule.path = '';
chipdata.schedule.log_file = '';
chipdata.schedule.loaded = false;
chipdata.schedule.start_time = clock;
chipdata.schedule.pause_time = 0;
chipdata.schedule.running = false;
chipdata.schedule.loop = false;
chipdata.schedule.data = struct;
chipdata.schedule.completed = [];
chipdata.schedule.current_step = 0;
chipdata.schedule.loop_count = 0;

%% Parameters for connecting to two controller boxes
%  Number of boxes
vc.num = 3;
% Serial number of USB interface in box #1
vc.info(1).sn = 'ELUJM96R'; % mj system
vc.info(1).handle = 0;
vc.info(1).status = 0;
% Polarity of valves in box #1 (see help of function vc_open_setup for
% a description of how the polarity works
vc.info(1).polarity = false(1, 24); 

% Serial number of USB interface in box #2
vc.info(2).sn = 'ELZ5KXT9'; % mj system
vc.info(2).handle = 0;
vc.info(2).status = 0;
% Polarity of valves in box #2
vc.info(2).polarity = false(1, 24);

% Serial number of USB interface in box #3
vc.info(3).sn = 'ELZ5LP15'; % Ce system
vc.info(3).handle = 0;
vc.info(3).status = 0;
% Polarity of valves in box #3
vc.info(3).polarity = true(1, 24); % normally opened

%% Open connection to controller boxes
vc = vc_open_setup(vc);
% Check status of both connections
disp(['Status of box#1 = ' num2str(vc.info(1).status)]);
disp(['Status of box#2 = ' num2str(vc.info(2).status)]);
disp(['Status of box#3 = ' num2str(vc.info(3).status)]);

%%
% Choose default command line output for chip_control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chip_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% Load images+plots into GUI
chipdata.status_image = imread('Chip.png');
chipdata.status_image_plot = imshow(chipdata.status_image, 'Parent', handles.chip_status_axes);
hold on;

x = chipdata.image_valve_positions(:,1);
y = chipdata.image_valve_positions(:,2);
chipdata.valves_open_plot = plot([x;-100], [y;-100],'o','MarkerEdgeColor',[.49 1 .63],'MarkerFaceColor',[.49 1 .63],'MarkerSize',25);
chipdata.valves_closed_plot = plot(-100, -100,'o','MarkerEdgeColor',[.85, .33, .1],'MarkerFaceColor',[.85, .33, .1],'MarkerSize',25);
chipdata.valves_plot_text = [];
for i = 1:length(x)
    x_coord = x(i);
    y_coord = y(i);
    newText = text(x_coord, y_coord, num2str(i-1), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 12);
    chipdata.valves_plot_text = [chipdata.valves_plot_text newText];
end

x = chipdata.image_channel_positions(:,1);
y = chipdata.image_channel_positions(:,2);
chipdata.channels_plot = plot(x, y,'o','MarkerEdgeColor',[0 0.74 1],'MarkerFaceColor',[0 0.74 1],'MarkerSize',25);
chipdata.channels_plot_text = [];

for i = [chipdata.channels.rinse_left_1 chipdata.channels.rinse_right_1 chipdata.channels.rinse_left_2 chipdata.channels.rinse_right_2 chipdata.channels.rinse_lower]
    x_coord = x(i+1);
    y_coord = y(i+1);
    newText = text(x_coord, y_coord, 'R', 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10);
    chipdata.channels_plot_text = [chipdata.channels_plot_text newText];
end

for i = 1:length(chipdata.channels.solutions)
    solution_i = chipdata.channels.solutions(i);
    x_coord = x(solution_i+1);
    y_coord = y(solution_i+1);
    newText = text(x_coord, y_coord, strcat('S', num2str(i)), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10);
    chipdata.channels_plot_text = [chipdata.channels_plot_text newText];
end

for i = 1:length(chipdata.channels.inlets)
    inlet_i = chipdata.channels.inlets(i);
    x_coord = x(inlet_i+1);
    y_coord = y(inlet_i+1);
    newText = text(x_coord, y_coord, strcat('I', num2str(i)), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10);
    chipdata.channels_plot_text = [chipdata.channels_plot_text newText];
end

for i = 1:length(chipdata.channels.outlets)
    outlet_i = chipdata.channels.outlets(i);
    x_coord = x(outlet_i+1);
    y_coord = y(outlet_i+1);
    newText = text(x_coord, y_coord, strcat('O', num2str(i)), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10);
    chipdata.channels_plot_text = [chipdata.channels_plot_text newText];
end

for i = 1:length(chipdata.channels.wastes)
    waste_i = chipdata.channels.wastes(i);
    x_coord = x(waste_i+1);
    y_coord = y(waste_i+1);
    newText = text(x_coord, y_coord, strcat('W', num2str(i)), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10);
    chipdata.channels_plot_text = [chipdata.channels_plot_text newText];
end

set(hObject, 'ResizeFcn', @chip_status_resize);

%% Load pump valve buttons
columns = 24;
xoffset = 0.01;
xpadding = 0.01;

yoffset = 0.05;
ypadding = 0.1;
height = 0.2;
width = (1-xoffset-xoffset+xpadding)/columns - xpadding;

chipdata.valve_buttons = [];
non_pumps = 0:71;
for i = 0:length(non_pumps)-1
    valve = non_pumps(i+1);
    left = xoffset + mod(i, columns)*(width+xpadding);
    bottom = (1-yoffset-height) - ((floor(i/columns))*(height+ypadding));
    chipdata.valve_buttons = [chipdata.valve_buttons uicontrol(handles.non_pump_valve_container, ...
        'Tag', strcat('manual_valve_', num2str(i)),...
        'Units', 'normalized',...
        'Position', [left bottom width height],...
        'String', num2str(valve),...
        'Callback', @(b, data) toggle_valve(valve))];
end

%% Set callbacks
set(handles.button_open_all, 'Callback', @(a, b) prompt_open_all());
set(handles.button_close_all, 'Callback', @(a, b) set_all_valves(0));

set(handles.button_open_pump_1, 'Callback', @(a, b) set_pump(chipdata.upper_pump, 1));
set(handles.button_close_pump_1, 'Callback', @(a, b) set_pump(chipdata.upper_pump, 0));
set(handles.button_start_pump_1, 'Callback', @(a, b) toggle_pump(chipdata.upper_pump, str2double(get(handles.pump_1_rate, 'String')), get(handles.pump_1_reverse, 'Value'), floor(str2double(get(handles.pump_1_num_cycles, 'String')))));

set(handles.button_open_pump_2, 'Callback', @(a, b) set_pump(chipdata.middle_pump, 1));
set(handles.button_close_pump_2, 'Callback', @(a, b) set_pump(chipdata.middle_pump, 0));
set(handles.button_start_pump_2, 'Callback', @(a, b) toggle_pump(chipdata.middle_pump, str2double(get(handles.pump_2_rate, 'String')), get(handles.pump_2_reverse, 'Value'), floor(str2double(get(handles.pump_2_num_cycles, 'String')))));

set(handles.button_open_pump_3, 'Callback', @(a, b) set_pump(chipdata.lower_pump, 1));
set(handles.button_close_pump_3, 'Callback', @(a, b) set_pump(chipdata.lower_pump, 0));
set(handles.button_start_pump_3, 'Callback', @(a, b) toggle_pump(chipdata.lower_pump, str2double(get(handles.pump_3_rate, 'String')), get(handles.pump_3_reverse, 'Value'), floor(str2double(get(handles.pump_3_num_cycles, 'String')))));

set(handles.button_rinse_upper_left, 'Callback', @(a, b) start_procedure_UI('Rinse Left'));
set(handles.button_rinse_upper_right, 'Callback', @(a, b) start_procedure_UI('Rinse Right'));
set(handles.button_rinse_lower, 'Callback', @(a, b) start_procedure_UI('Rinse Lower'));
set(handles.button_rinse_all, 'Callback', @(a, b) start_procedure_UI('Rinse All'));

set(handles.button_start_delivery, 'Callback', @(a, b) start_procedure_UI('Deliver'));

set(handles.button_stop_procedure, 'Callback', @(a, b) stop_procedure());

set(handles.button_choose_file, 'Callback', @(a, b) load_schedule_file());
set(handles.button_run_schedule, 'Callback', @(a, b) run_schedule());
set(handles.button_stop_schedule, 'Callback', @(a, b) stop_schedule());

set(handles.pump_1_rate, 'Callback', @check_numeric);
set(handles.pump_2_rate, 'Callback', @check_numeric);
set(handles.pump_3_rate, 'Callback', @check_numeric);
set(handles.supply_rate, 'Callback', @check_numeric);
set(handles.outlet_hold_time, 'Callback', @check_numeric);

set(handles.pump_1_num_cycles, 'Callback', @check_numeric);
set(handles.pump_2_num_cycles, 'Callback', @check_numeric);
set(handles.pump_3_num_cycles, 'Callback', @check_numeric);

set(handles.experiment_radio_buttons, 'SelectionChangeFcn', @experiment_changed);

%% Store static handles
chipdata.handles = handles;

%% Initial conditions
set_all_valves(0);
experiment_changed(0, 0, 0);
update_schedule_view();
update_controls();
%%

% Redraws chip status
function refresh_valve_display()
    global chipdata application;
    
    open_valves = chipdata.valve_states == 1;
    closed_valves = chipdata.valve_states == 0;
    
    open_valve_pos = [chipdata.image_valve_positions(open_valves, :); -100 -100];
    closed_valve_pos = [chipdata.image_valve_positions(closed_valves, :); -100 -100];
    if application.open
        set(chipdata.valves_open_plot, 'XData', open_valve_pos(:, 1), 'YData', open_valve_pos(:, 2));
        set(chipdata.valves_closed_plot, 'XData', closed_valve_pos(:, 1), 'YData', closed_valve_pos(:, 2));
    end

% Updates controls
function update_controls()
    global chipdata application;
    
    handles = chipdata.handles;
    
    if chipdata.schedule.running
        pump_enables = zeros(1, length(chipdata.pump_states.running));
        can_stop_pump = 'off';
        can_change_all = 'off';
        can_control_manual = 'off';
        can_control_procedures = 'off';
        can_stop_procedure = 'off';
    else
        if isequal(chipdata.procedure.action, 'Idle')
            pump_enables = ~chipdata.pump_states.running;
            can_stop_pump = 'on';
            if sum(chipdata.pump_states.running) > 0
                can_change_all = 'off';
            else
                can_change_all = 'on';
            end
            can_control_manual = 'on';
            can_control_procedures = 'on';
            can_stop_procedure = 'off';
        else
            pump_enables = zeros(1, length(chipdata.pump_states.running));
            can_stop_pump = 'off';
            can_change_all = 'off';
            can_control_manual = 'off';
            can_control_procedures = 'off';
            can_stop_procedure = 'on';
        end
    end
    
    solutions_string = regexprep(num2str(chipdata.procedure.solutions),' +',', S');
    if ~isempty(solutions_string)
        solutions_string = strcat('S', solutions_string);
    end
    channels_string = regexprep(num2str(chipdata.procedure.channels),' +',', ');
    
    switch(chipdata.procedure.action)
        case 'Idle'
            status_text = 'No procedure running.';
        case 'Rinse Left'
            status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing upper left with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
        case 'Rinse Right'
            status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing upper right with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
        case 'Rinse Lower'
            status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing lower with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
        case 'Rinse All'
            status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing all with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
        case 'Deliver'
            status_text = strcat('(', upper(chipdata.procedure.experiment), {') Delivering '}, solutions_string, {' to channels '}, channels_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
        case 'Stop'
            status_text = 'Closing channels...';
        case 'CloseAll'
            status_text = 'All channels closed.';
        otherwise
            status_text = 'Undefined procedure.';
    end
    set(handles.procedure_status, 'String', strcat({'   '}, status_text));
    
    set(handles.button_open_all, 'Enable', can_change_all);
    set(handles.button_close_all, 'Enable', can_change_all);
    
    set(chipdata.valve_buttons, 'Enable', can_control_manual);
    
    set(handles.radio_experiment_left, 'Enable', can_control_procedures);
    set(handles.radio_experiment_right, 'Enable', can_control_procedures);
    set(handles.radio_experiment_both, 'Enable', can_control_procedures);
    set(handles.select_solution, 'Enable', can_control_procedures);
    
    set(handles.button_rinse_upper_left, 'Enable', can_control_procedures);
    set(handles.button_rinse_upper_right, 'Enable', can_control_procedures);
    set(handles.button_rinse_lower, 'Enable', can_control_procedures);
    
    if isequal(can_control_procedures, 'off')
        set(handles.supply_rate, 'Enable', 'inactive', 'BackgroundColor', application.light_navy_color);
        set(handles.outlet_hold_time, 'Enable', 'inactive', 'BackgroundColor', application.light_navy_color);
    else
        set(handles.supply_rate, 'Enable', can_control_procedures,  'BackgroundColor', application.navy_color);
        set(handles.outlet_hold_time, 'Enable', can_control_procedures,  'BackgroundColor', application.navy_color);
    end
    set(handles.button_rinse_all, 'Enable', can_control_procedures);
    set(handles.select_channel, 'Enable', can_control_procedures);
    set(handles.button_start_delivery, 'Enable', can_control_procedures);
    
    if isequal(can_stop_procedure, 'on')
        set(handles.button_stop_procedure, 'Enable', can_stop_procedure, 'BackgroundColor', application.red_color);
    else
        set(handles.button_stop_procedure, 'Enable', can_stop_procedure, 'BackgroundColor', [1 1 1]);
    end
    
    for pump_index = 1:length(chipdata.pump_states.running)
        start_handle = eval(strcat('handles.button_start_pump_', num2str(pump_index)));
        open_handle = eval(strcat('handles.button_open_pump_', num2str(pump_index)));
        close_handle = eval(strcat('handles.button_close_pump_', num2str(pump_index)));
        rate_handle = eval(strcat('handles.pump_', num2str(pump_index), '_rate'));
        reverse_handle = eval(strcat('handles.pump_', num2str(pump_index), '_reverse'));
        if pump_enables(pump_index)
            set(start_handle, 'BackgroundColor', application.green_color, 'String', 'Start');
            enable_controls = 'on';
        else
            set(start_handle, 'BackgroundColor', application.red_color, 'String', 'Stop');
            enable_controls = 'off';
        end
        set(open_handle, 'Enable', enable_controls);
        set(close_handle, 'Enable', enable_controls);
        if isequal(enable_controls, 'off')
            set(rate_handle, 'Enable', 'inactive', 'BackgroundColor', application.light_navy_color);
        else
            set(rate_handle, 'Enable', enable_controls,  'BackgroundColor', application.navy_color);
        end
        set(reverse_handle, 'Enable', enable_controls);
        set(start_handle, 'Enable', can_stop_pump);
        if isequal(can_stop_pump, 'off')
            set(start_handle, 'BackgroundColor', application.green_color);
            if chipdata.pump_states.running(pump_index)
                set(start_handle, 'String', 'Running...');
            else
                set(start_handle, 'String', 'Idle');
            end
        end
    end

% Set valve
function set_valve_state(valve, open)
    global chipdata vc;
    
    if chipdata.valve_states(valve+1) ~= open
        chipdata.valve_states(valve+1) = open;
        vc = vc_set_1bit(vc, valve, open);
        refresh_valve_display();
    end

% Set set of valves to a pattern
function set_valves(valves, open)
    global vc chipdata;
    
    if length(open) == 1
        new_valve_states = ones(1, length(valves))*open;
    else
        new_valve_states = open;
    end
    
    if ~isequal(chipdata.valve_states(valves+1), new_valve_states)
        chipdata.valve_states(valves+1) = new_valve_states;
        vc = vc_set_bits_ac(vc, valves, chipdata.valve_states(valves+1));
        refresh_valve_display();
    end

% Set complementary set of valves to just open or closed
function set_complement_valves(valves_not_to_set, open)
    global chipdata;
    
    complement_valves = setdiff(0:length(chipdata.valve_states)-1, valves_not_to_set);
    set_valves(complement_valves, open);
    
% Set all valves
function set_all_valves(open)
    set_valves(0:71, open);
    
% Toggle valve
function toggle_valve(valve)
    global chipdata;
    
    set_valve_state(valve, ~chipdata.valve_states(valve+1));

% Open/close pump
function set_pump(pump_index, open)
    global chipdata;
    for valve = chipdata.pump_valves(pump_index, :)
        set_valve_state(valve, open);
    end

% Toggle if pump should be running
function toggle_pump(pump_index, rate, reverse, num_cycles)
    global chipdata;
    set_pump_running(~(chipdata.pump_states.running(pump_index)), pump_index, rate, reverse, num_cycles);

% Set pump to be running or not
function set_pump_running(should_run, pump_index, rate, reverse, num_cycles)
    if should_run && (isnan(rate) || ~(rate > 0))
        errordlg('Invalid pump rate (must be a number greater than zero).','Error');
        return;
    end
    global chipdata;
    
    if ~isequal(chipdata.pump_states.running(pump_index), should_run)
        chipdata.pump_states.running(pump_index) = should_run;
        chipdata.pump_states.rate(pump_index) = rate;
        chipdata.pump_states.reverse(pump_index) = reverse;
        chipdata.pump_states.last_update{pump_index} = clock;
        chipdata.pump_states.current_step(pump_index) = length(chipdata.pump_pattern)-1;
        chipdata.pump_states.num_cycles(pump_index) = num_cycles;

        update_controls();

        if should_run
            begin_procedure();
        end
    end
    
% Entry-point to update procedures
function begin_procedure()
    global chipdata;
    
    if ~chipdata.procedure.running
        chipdata.procedure.running = true;
        update_procedure();
    end
    
% Loop function to update procedures (including running pumps via manual
% control.
function update_procedure()
    global chipdata application;
    
    % Stop updating when no procedure is running (should never stop running
    % unless the application is closed in our model).
    while chipdata.procedure.running && application.open
        % Set current procedure if there is a schedule running.
        if chipdata.schedule.running
            uncompleted_modes = find(chipdata.schedule.completed == false)';
            if isequal(chipdata.schedule.current_step, uncompleted_modes)
                if get(chipdata.handles.checkbox_loop_schedule, 'Value')
                    loop_schedule();
                else
                    stop_schedule();
                end
                continue;
            end
            if ~isempty(uncompleted_modes)
                for i = uncompleted_modes
                    if i ~= chipdata.schedule.current_step && chipdata.schedule.data.times{i} <= etime(clock, chipdata.schedule.start_time)
                        if isequal(chipdata.schedule.data.actions{i}, 'Close All')
                            chipdata.procedure.action = 'CloseAll';
                        elseif isequal(chipdata.schedule.data.actions{i}, 'Pumped Delivery')
                            chipdata.procedure.use_pumps = true;
                            chipdata.procedure.action = 'Deliver';
                        elseif isequal(chipdata.schedule.data.actions{i}, 'Flow Delivery')
                            chipdata.procedure.use_pumps = false;
                            chipdata.procedure.action = 'Deliver';
                        else
                            chipdata.procedure.action = chipdata.schedule.data.actions{i};
                        end
                        chipdata.procedure.rate = chipdata.schedule.data.rates{i};
                        chipdata.procedure.outlet_hold_time = chipdata.schedule.data.outlet_hold_time;
                        chipdata.procedure.start_time = datevec(datenum(clock) - datenum([0 0 0 0 0 chipdata.procedure.pause_time]));
                        chipdata.procedure.solutions = chipdata.schedule.data.solutions{i};
                        chipdata.procedure.experiment = chipdata.schedule.data.experiment_side;
                        chipdata.procedure.channels = chipdata.schedule.data.channels{i};
                        
                        solutions_string = strrep(num2str(chipdata.procedure.solutions), '  ', ', S');
                        if ~isempty(solutions_string)
                            solutions_string = strcat('S', solutions_string);
                        end
                        channels_string = strrep(num2str(chipdata.procedure.channels), '  ', ', ');

                        status_text = '';
                        switch(chipdata.procedure.action)
                            case 'Idle'
                                status_text = {'No procedure running.'};
                            case 'Rinse Left'
                                status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing upper left with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
                            case 'Rinse Right'
                                status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing upper right with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
                            case 'Rinse Lower'
                                status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing lower with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
                            case 'Rinse All'
                                status_text = strcat('(', upper(chipdata.procedure.experiment), {') Rinsing all with '}, solutions_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
                            case 'Deliver'
                                status_text = strcat('(', upper(chipdata.procedure.experiment), {') Delivering '}, solutions_string, {' to channels '}, channels_string, {' ('}, num2str(chipdata.procedure.rate), ' cycles/sec)');
                            case 'Stop'
                                status_text = {'Closing channels...'};
                            case 'CloseAll'
                                status_text = {'All channels closed.'};
                            otherwise
                                status_text = {'Undefined procedure.'};
                        end
                        fprintf(chipdata.schedule.log_file, ...
                            '%s (T+%s)\t--\t%s\n', ...
                            datestr(clock, 'mm/dd/yyyy--HH:MM:SS'), ...
                            gettime(etime(clock, chipdata.schedule.start_time)), ...
                            status_text{1});
                        
                        if chipdata.schedule.current_step > 0
                            chipdata.schedule.completed(chipdata.schedule.current_step) = true;
                            fprintf('Set step %d to true.\n', chipdata.schedule.current_step);
                        end
                        
                        chipdata.schedule.current_step = i;
                        
                        update_schedule_view();
                        update_controls();
                        break;
                    end
                end
            end
            update_schedule_view();
        end
        
        % Set chip configuration for current procedure
        if isequal(chipdata.procedure.action, 'Idle')
            % Do nothing. Manual control takes over here.
        else
            if isequal(chipdata.procedure.action, 'Stop')
                % A formal procedure or automation was stopped. Close all
                % valves, stop all pumps, and pass control back to manual.
                set_pump_running(0, 1, 0, false, 0);
                set_pump_running(0, 2, 0, false, 0);
                set_pump_running(0, 3, 0, false, 0);
                set_all_valves(false);
                chipdata.procedure.action = 'Idle';
                update_controls();
            elseif isequal(chipdata.procedure.action, 'CloseAll')
                set_pump_running(0, 1, 0, false, 0);
                set_pump_running(0, 2, 0, false, 0);
                set_pump_running(0, 3, 0, false, 0);
                set_all_valves(false);
                update_controls();
            elseif isequal(chipdata.procedure.action, 'Rinse Left') || (isequal(chipdata.procedure.action, 'Rinse All') && isequal(chipdata.procedure.all_phase, 'Rinse Left'))
                set_pump_running(0, 1, 0, false, 0);
                set_pump_running(0, 2, 0, false, 0);
                set_pump_running(0, 3, 0, false, 0);
                
                % Figure out which should be rinsing and which ones should be supplied.
                supply_valves = chipdata.valves.supplies(chipdata.procedure.solutions);
                if isequal(chipdata.procedure.experiment, 'Right')
                    rinse_valve = chipdata.valves.rinse_left_2;
                else
                    rinse_valve = chipdata.valves.rinse_left_1;
                end
                
                if should_open_divider()
                    divider_valve = chipdata.valves.divider;
                else
                    divider_valve = [];
                end
                
                set_valves([rinse_valve supply_valves divider_valve chipdata.valves.upper_pump], true);
                
                % Everything else should be closed.
                set_complement_valves([rinse_valve supply_valves divider_valve chipdata.valves.upper_pump], false);
            elseif isequal(chipdata.procedure.action, 'Rinse Right') || (isequal(chipdata.procedure.action, 'Rinse All') && isequal(chipdata.procedure.all_phase, 'Rinse Right'))
                set_pump_running(0, 1, 0, false, 0);
                set_pump_running(0, 2, 0, false, 0);
                set_pump_running(0, 3, 0, false, 0);
                
                % Figure out which should be rinsing and which ones should be supplied.
                supply_valves = chipdata.valves.supplies(chipdata.procedure.solutions);
                if isequal(chipdata.procedure.experiment, 'Left')
                    rinse_valve = chipdata.valves.rinse_right_1;
                else
                    rinse_valve = chipdata.valves.rinse_right_2;
                end
                
                if should_open_divider()
                    divider_valve = chipdata.valves.divider;
                else
                    divider_valve = [];
                end
                
                set_valves([rinse_valve supply_valves divider_valve chipdata.valves.upper_pump], true);
                
                % Everything else should be closed.
                set_complement_valves([rinse_valve supply_valves divider_valve chipdata.valves.upper_pump], false);
            elseif isequal(chipdata.procedure.action, 'Rinse Lower') || (isequal(chipdata.procedure.action, 'Rinse All') && isequal(chipdata.procedure.all_phase, 'Rinse Lower'))
                set_pump_running(0, 1, 0, false, 0);
                set_pump_running(0, 2, 0, false, 0);
                set_pump_running(0, 3, 0, false, 0);
                
                % Figure out which should be rinsing and which ones should be supplied.
                rinse_valve = chipdata.valves.rinse_lower;
                supply_valves = chipdata.valves.supplies(chipdata.procedure.solutions);
                
                if should_open_divider()
                    divider_valve = chipdata.valves.divider;
                else
                    divider_valve = [];
                end
                
                set_valves([rinse_valve supply_valves divider_valve chipdata.valves.upper_pump chipdata.valves.middle_pump chipdata.valves.lower_pump], true);
                
                % Everything else should be closed.
                set_complement_valves([rinse_valve supply_valves divider_valve chipdata.valves.upper_pump chipdata.valves.middle_pump chipdata.valves.lower_pump], false);
                
            elseif isequal(chipdata.procedure.action, 'Deliver')
                % Set pumps to run if they should
                set_pump_running(chipdata.procedure.use_pumps, 1, chipdata.procedure.rate, false, -1);
                set_pump_running(chipdata.procedure.use_pumps, 2, chipdata.procedure.rate, false, -1);
                set_pump_running(chipdata.procedure.use_pumps, 3, chipdata.procedure.rate, false, -1);
                
                channel_valves = chipdata.valves.lanes(chipdata.procedure.channels);
                supply_valves = chipdata.valves.supplies(chipdata.procedure.solutions);
                
                if should_open_divider()
                    divider_valve = chipdata.valves.divider;
                else
                    divider_valve = [];
                end
                
                if chipdata.procedure.use_pumps
                    pump_valves = [];
                else
                    pump_valves = [chipdata.valves.upper_pump chipdata.valves.middle_pump chipdata.valves.lower_pump];
                end
                
                set_valves([channel_valves supply_valves divider_valve pump_valves], true);
                
                if etime(clock, chipdata.procedure.start_time) > chipdata.procedure.outlet_hold_time
                    set_valve_state(chipdata.valves.block, true);
                else
                    set_valve_state(chipdata.valves.block, false);
                end
                
                % Everything else should be closed.
                set_complement_valves([pump_valves chipdata.valves.block channel_valves supply_valves divider_valve], false);
            end
            if isequal(chipdata.procedure.action, 'Rinse All')
                %% Need to switch between left, right, lower.
                elapsed = etime(clock, chipdata.procedure.start_time);
                active_set = mod(floor(elapsed/chipdata.procedure.all_cycle_time_sec), 3);
                switch active_set
                    case 0
                        chipdata.procedure.all_phase = 'Rinse Left';
                    case 1
                        chipdata.procedure.all_phase = 'Rinse Right';
                    case 2
                        chipdata.procedure.all_phase = 'Rinse Lower';
                end
            end
        end
        
        % Update all running pumps
        for pump_index = find(chipdata.pump_states.running)
            % See if this pump is due for advancing one step
            time_since_last_step = etime(clock, chipdata.pump_states.last_update{pump_index});
            rate = chipdata.pump_states.rate(pump_index);
            delay = (1/((rate)*length(chipdata.pump_pattern)));
            if (time_since_last_step >= delay)
                % Advance one step
                current_step = chipdata.pump_states.current_step(pump_index);
                
                % Check to see if we are done with cycling
                if chipdata.pump_states.num_cycles(pump_index) > -1
                    if chipdata.pump_states.num_cycles(pump_index) == 0
                        set_valves(chipdata.pump_valves(pump_index, :), 0);
                        set_pump_running(0, pump_index, 0, false, 0);
                        continue;
                    else
                        if current_step == 0
                            chipdata.pump_states.num_cycles(pump_index) = chipdata.pump_states.num_cycles(pump_index) - 1;
                        end
                    end
                end
                
                if chipdata.pump_states.reverse(pump_index)
                    current_step = mod(current_step + 1, length(chipdata.pump_pattern));
                else
                    current_step = mod(current_step - 1, length(chipdata.pump_pattern));
                end

                pump_state = chipdata.pump_pattern(current_step+1, :);
                
                if (chipdata.pump_states.running(pump_index))
                    set_valves(chipdata.pump_valves(pump_index, :), pump_state);
                end
                
                chipdata.pump_states.last_update{pump_index} = clock;
                chipdata.pump_states.current_step(pump_index) = current_step;
            end
        end
        pause(0.05);
    end
    if ~application.open
        close_program();
    end

% Check if we need to have the divider open
function should_open = should_open_divider()
    global chipdata;
    
    action = chipdata.procedure.action;
    
    should_open = false;
    if isequal(action, 'Rinse Left') || isequal(action, 'Rinse Right') || isequal(action, 'Rinse Lower') || isequal(action, 'Rinse All')
        if isequal(chipdata.procedure.experiment, 'Both')
            should_open = true;
        end
    elseif isequal(action, 'Deliver')
        solLen = (floor(length(chipdata.channels.solutions)/2));
        chanLen = (floor(length(chipdata.channels.outlets)/2));
        
        if isempty(chipdata.procedure.solutions) || isempty(chipdata.procedure.channels)
            return;
        end
        
        solOnLeft = min(chipdata.procedure.solutions) <= solLen;
        solOnRight = max(chipdata.procedure.solutions) > solLen;
        chanOnLeft = min(chipdata.procedure.channels) <= chanLen;
        chanOnRight = max(chipdata.procedure.channels) > chanLen;
        
        if (solOnLeft && chanOnRight) || (solOnRight && chanOnLeft)
            should_open = true;
        end
    end

% Run procedure from procedures panel (load values from UIControls)
function start_procedure_UI(procedure)
    global chipdata;
    
    chipdata.procedure.action = procedure;
    
    handles = chipdata.handles;
    
    solLen = (floor(length(chipdata.channels.solutions)/2));
    chanLen = (floor(length(chipdata.channels.outlets)/2));
    if get(handles.radio_experiment_left, 'Value')
        chipdata.procedure.experiment = 'Left';
        chipdata.procedure.solutions = get(handles.select_solution, 'Value');
        chipdata.procedure.channels = get(handles.select_channel, 'Value');
    elseif get(handles.radio_experiment_right, 'Value')
        chipdata.procedure.experiment = 'Right';
        chipdata.procedure.solutions = get(handles.select_solution, 'Value') + solLen;
        chipdata.procedure.channels = get(handles.select_channel, 'Value') + chanLen;
    elseif get(handles.radio_experiment_both, 'Value')
        chipdata.procedure.experiment = 'Both';
        chipdata.procedure.solutions = get(handles.select_solution, 'Value');
        chipdata.procedure.channels = get(handles.select_channel, 'Value');
    end
    
    chipdata.procedure.use_pumps = get(handles.pumped_delivery, 'Value');
    outlet_hold_time = str2double(get(handles.outlet_hold_time, 'string'));
    if isequal(procedure, 'Deliver')
        if (isnan(outlet_hold_time) || ~(outlet_hold_time > 0))
            errordlg('Invalid outlet hold time (must be a number greater than zero.','Error');
            return;
        else
            chipdata.procedure.outlet_hold_time = outlet_hold_time;
        end
        
        if chipdata.procedure.use_pumps
            rate = str2double(get(handles.supply_rate, 'String'));
            if (isnan(rate) || ~(rate > 0))
                errordlg('Invalid pump rate (must be a number greater than zero).','Error');
                return;
            else
                chipdata.procedure.rate = rate;
            end
        end
    end
    
    chipdata.procedure.start_time = clock;
    
    update_controls();
    
    begin_procedure();
    
% Stop procedure
function stop_procedure()
    global chipdata;
    if ~(isequal(chipdata.procedure.action, 'Idle'))
        chipdata.procedure.action = 'Stop';
    end

% Load schedule
function load_schedule_file()
    global chipdata;
    [filename,path,~] = uigetfile({'*.xlsx', '*.xls'});
    if filename ~= 0
        if path ~= 0
            chipdata.schedule.path = path;
            [success, chipdata.schedule.data] = load_schedule(strcat(path, filename));
            
            if success
                % Display file name in the box
                set(chipdata.handles.loaded_filename, 'String', filename);
                chipdata.schedule.loaded = true;
                chipdata.schedule.running = false;
                chipdata.schedule.completed = zeros(length(chipdata.schedule.data.times), 1);
                % Update information loaded into the table
                update_schedule_view();
                
                set(chipdata.handles.button_run_schedule, 'String', 'Run');
                set(chipdata.handles.button_stop_schedule, 'String', 'Reset');
                
                reset_schedule();
            else
                errordlg('Unable to load file.','Error');
            end
        end
    end

% Run schedule
function run_schedule()
    global chipdata;
    if chipdata.schedule.pause_time == 0
        % New run, create the log file.
        if chipdata.schedule.log_file ~= ''
            fclose(chipdata.schedule.log_file);
        end
        log_fname = sprintf('%sexperiment_%s.log', chipdata.schedule.path, datestr(clock, 'mmddyy_HHMMSS'));
        chipdata.schedule.log_file = fopen(log_fname, 'w');
    end
    chipdata.schedule.running = true;
    chipdata.schedule.start_time = datevec(datenum(clock) - datenum([0 0 0 0 0 chipdata.schedule.pause_time]));
    chipdata.schedule.current_step = 0;
    set(chipdata.handles.button_stop_schedule, 'String', 'Pause');
    begin_procedure();

% Stop schedule
function stop_schedule()
    global chipdata;
    if chipdata.schedule.running
        set(chipdata.handles.button_stop_schedule, 'String', 'Reset');
        set(chipdata.handles.button_run_schedule, 'String', 'Resume');
        chipdata.schedule.running = false;
        chipdata.schedule.pause_time = etime(clock, chipdata.schedule.start_time);
        chipdata.procedure.pause_time = etime(clock, chipdata.procedure.start_time);
        update_schedule_view();
        chipdata.procedure.action = 'Stop';
    else
        reset_schedule();
    end

% Reset schedule
function reset_schedule()
    global chipdata;
    set(chipdata.handles.button_run_schedule, 'String', 'Run');
    chipdata.schedule.pause_time = 0;
    chipdata.procedure.pause_time = 0;
    chipdata.schedule.loop_count = 0;
    chipdata.schedule.completed = zeros(length(chipdata.schedule.data.times), 1);
    update_schedule_view();
    chipdata.procedure.action = 'Stop';
    
% Loop schedule
function loop_schedule()
    global chipdata;
    chipdata.schedule.start_time = clock;
    chipdata.schedule.loop_count = chipdata.schedule.loop_count + 1;
    chipdata.schedule.pause_time = 0;
    chipdata.procedure.pause_time = 0;
    chipdata.schedule.completed = zeros(length(chipdata.schedule.data.times), 1);
    chipdata.schedule.current_step = 0;
    fprintf('Reset.\n');
    update_schedule_view();
    
% Produce table formatted text
function [formatted] = colorgen(color, text)
    if isequal(text, '')
        text = '&nbsp;';
    end
    formatted = strcat('<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>');


% Update the schedule's appearance in the table.
function update_schedule_view()
    global chipdata application;
    
    if chipdata.schedule.loaded
        set(chipdata.handles.loaded_schedule_info, 'String', ...
            sprintf('Outlet Hold Time (s): %.2f\nSpeed Factor: %.2f', ...
            chipdata.schedule.data.outlet_hold_time/chipdata.schedule.data.seconds_per_outlet_hold_time_unit, ...
            chipdata.schedule.data.speed_factor));
        set(chipdata.handles.checkbox_loop_schedule, 'Enable', 'on');
        
        set(chipdata.handles.button_stop_schedule, 'Enable', 'on');
        set(chipdata.handles.button_stop_schedule, 'BackgroundColor', application.red_color);
        
        if chipdata.schedule.running
            set(chipdata.handles.button_run_schedule, 'Enable', 'off');
            set(chipdata.handles.button_run_schedule, 'BackgroundColor', [1 1 1]);
            set(chipdata.handles.button_choose_file, 'Enable', 'off');
        else
            set(chipdata.handles.button_run_schedule, 'Enable', 'on');
            set(chipdata.handles.button_run_schedule, 'BackgroundColor', application.green_color);
            set(chipdata.handles.button_choose_file, 'Enable', 'on');
        end
        
        % Go through each thing in the table and add it on
        loaded_first = false;
        if get(chipdata.handles.checkbox_loop_schedule, 'Value')
            loops_text = sprintf(' (%d loops completed)', chipdata.schedule.loop_count);
        else
            loops_text = '';
        end
        if chipdata.schedule.running
            active_times = find(chipdata.schedule.completed == false)';
            set(chipdata.handles.running_time, 'BackgroundColor', [0.5 1 0.5]);
            set(chipdata.handles.running_time, 'String', sprintf('   Running. Elapsed: %s%s', gettime(etime(clock, chipdata.schedule.start_time)), loops_text));
        else
            set(chipdata.handles.running_time, 'BackgroundColor', [0.94 0.94 0.94]);
            active_times = 1:length(chipdata.schedule.data.times);
            if chipdata.schedule.pause_time == 0
                set(chipdata.handles.running_time, 'String', '   Not running.');
            else
                set(chipdata.handles.running_time, 'String', sprintf('   Paused. Elapsed: %s%s', gettime(chipdata.schedule.pause_time), loops_text));
            end
        end
        table_data = {};
        next_row = 1;
        for i = active_times
            time = gettime(chipdata.schedule.data.times{i});
            action = chipdata.schedule.data.actions{i};
            solution = regexprep(num2str(chipdata.schedule.data.solutions{i}),' +',', ');
            if chipdata.schedule.data.rates{i} == -1
                rate = '';
            else
                rate = num2str(chipdata.schedule.data.rates{i});
            end
            channel = regexprep(num2str(chipdata.schedule.data.channels{i}),' +',', ');

            new_row = {time action solution rate channel};
            if loaded_first || ~chipdata.schedule.running
                table_data(next_row, :) = cellfun(@(x) colorgen('#f0f0f0', x), new_row, 'UniformOutput', false);
            else
                table_data(next_row, :) = cellfun(@(x) colorgen('#80ff80', x), new_row, 'UniformOutput', false);
                loaded_first = true;
            end
            next_row = next_row + 1;
        end
        set(chipdata.handles.schedule_table, 'Data', table_data);
        
    else
        set(chipdata.handles.loaded_schedule_info, 'String', 'Information about the loaded schedule will appear here. Click "Choose File" to load a schedule.');
        
        set(chipdata.handles.running_time, 'BackgroundColor', [0.94 0.94 0.94]);
        
        set(chipdata.handles.running_time, 'String', '   No schedule running.');
        
        set(chipdata.handles.button_run_schedule, 'Enable', 'off');
        set(chipdata.handles.button_run_schedule, 'BackgroundColor', [1 1 1]);
        
        set(chipdata.handles.button_stop_schedule, 'Enable', 'off');
        set(chipdata.handles.button_stop_schedule, 'BackgroundColor', [1 1 1]);
        
        set(chipdata.handles.checkbox_loop_schedule, 'Enable', 'off');
        
        set(chipdata.handles.button_choose_file, 'Enable', 'on');
        
        set(chipdata.handles.loaded_filename, 'String', '');
    end

    
% -- Resize plot markers proportionally
function chip_status_resize(~, ~)
    global chipdata;
    
    curunits = get(chipdata.handles.chip_status_axes, 'Units');
    set(chipdata.handles.chip_status_axes, 'Units', 'Points');
    cursize = get(chipdata.handles.chip_status_axes, 'Position');
    set(chipdata.handles.chip_status_axes, 'Units', curunits)
        
    marker_proportions = [1 1 1];
    text_proportions = [1 0.7];
    plot_handles = {chipdata.valves_open_plot, chipdata.valves_closed_plot, chipdata.channels_plot};
    text_handles = {chipdata.valves_plot_text, chipdata.channels_plot_text};
    
    for i = 1:length(marker_proportions)
        plot_handle = plot_handles{i};
        marker_proportion = marker_proportions(i);
        set(plot_handle, 'MarkerSize', cursize(3)*marker_proportion * 0.02);
    end
    
    for i = 1:length(text_proportions)
        text_proportion = text_proportions(i);
        text_handle = text_handles{i};
        for t = text_handle
            set(t, 'FontSize', cursize(3)*text_proportion * 0.012);
        end
    end

% --- Outputs from this function are returned to the command line.
function varargout = chip_control_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global chipdata application;

    application.open = false;

    if ~chipdata.procedure.running
        close_program();
    end
        
% Closes the window
function close_program()
    global vc chipdata;
    vc = vc_close(vc, 1);
    delete(chipdata.handles.figure1);
    if chipdata.schedule.log_file ~= ''
        fclose(chipdata.schedule.log_file);
    end
    
% Checks numeric inputs
function check_numeric(src,~)
str=get(src,'String');
if isnan(str2double(str))
    set(src,'string','1');
    warndlg('Input must be numerical');
end

% Updates on experiment changed
function experiment_changed(~, ~, ~)
    global chipdata;
    solutions = [];
    channels = [];
    solLen = (floor(length(chipdata.channels.solutions)/2));
    chanLen = (floor(length(chipdata.channels.outlets)/2));
    if get(chipdata.handles.radio_experiment_left, 'Value')
        solutions = 1:solLen;
        channels = 1:chanLen;
    elseif get(chipdata.handles.radio_experiment_right, 'Value')
        solutions = (solLen+1):(solLen*2);
        channels = (chanLen+1):(chanLen*2);
    elseif get(chipdata.handles.radio_experiment_both, 'Value')
        solutions = 1:(solLen*2);
        channels = 1:(chanLen*2);
    end
    set(chipdata.handles.select_solution, 'Value', []);
    set(chipdata.handles.select_channel, 'Value', []);
    
    solutionStrings = cellfun(@(x) sprintf('Solution %d', x), num2cell(solutions'), 'UniformOutput', false);
    channelStrings = cellfun(@(x) sprintf('Channel %d', x), num2cell(channels'), 'UniformOutput', false);
    set(chipdata.handles.select_solution, 'String', solutionStrings);
    set(chipdata.handles.select_channel, 'String', channelStrings);
    
% Prompt open all valves
function prompt_open_all()
    b = questdlg('Do you really want to OPEN all valves?', 'Confirm Action', 'Yes', 'No', 'No');
    
    if isequal(b, 'Yes')
        set_all_valves(1)
    end
    
% Date conversion
function t = gettime(seconds)
    t = strcat(num2str(floor(seconds/3600)), datestr(seconds/24/3600, ':MM:SS'));