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
%      *See GUI Options on GUIDE's Tools menu.  Choose 'GUI allows only one
%      instance to run (singleton)'.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chip_control

% Last Modified by GUIDE v2.5 20-Jun-2017 10:58:15

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
function chip_control_OpeningFcn(hObject, eventdata, handles, varargin)
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

global vc;
global chipdata;
global schedule;

schedule.loaded = false;
schedule.times = [];
schedule.lanes = [];
schedule.valves = [];
schedule.actions = [];
schedule.filename = 'Not loaded.';
schedule.path = '';
schedule.current_time = 0;
schedule.timeplot = 0;
schedule.running = false;

chipdata.num_lanes = 15;
chipdata.inlet_valves = fliplr(57:71);
chipdata.outlet_valves = fliplr(41:55);

%% Parameters for connecting to two controller boxes
%  Number of boxes
vc.num = 3;
% Serial number of USB interface in box #1
vc.info(1).sn = 'ELUJM96R'; % mj system
vc.info(1).handle = 0;
vc.info(1).status = 0;
% Polarity of valves in box #1 (see help of function vc_open_setup for
% a description of how the polarity works
vc.info(1).polarity = logical([zeros(1, 24)]); 

% Serial number of USB interface in box #2
vc.info(2).sn = 'ELZ5KXT9'; % mj system
vc.info(2).handle = 0;
vc.info(2).status = 0;
% Polarity of valves in box #2
vc.info(2).polarity = logical([zeros(1, 24)]);

% Serial number of USB interface in box #3
vc.info(3).sn = 'ELZ5LP15'; % Ce system
vc.info(3).handle = 0;
vc.info(3).status = 0;
% Polarity of valves in box #3
vc.info(3).polarity = [1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1]; % normally opened

%% Open connection to controller boxes
vc = vc_open_setup(vc);
% Check status of both connections
disp(['Status of box#1 = ' num2str(vc.info(1).status)]);
disp(['Status of box#2 = ' num2str(vc.info(2).status)]);
disp(['Status of box#3 = ' num2str(vc.info(3).status)]);
set_box_state(1, (vc.info(1).status == 0), handles);
set_box_state(2, (vc.info(2).status == 0), handles);
set_box_state(3, (vc.info(3).status == 0), handles);

% Choose default command line output for chip_control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set_all_valves(false, handles);
update_schedule_view(handles);

% UIWAIT makes chip_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = chip_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function set_manual_enable(enabled, handles)
    if enabled
        onoff = 'on';
    else
        onoff = 'off';
    end
    for handle=findobj('Style', 'pushbutton')
        set(handle,'Enable',onoff);
    end

function set_box_state(box_number, connected, handles)
    status_handle = eval(strcat('handles.box', num2str(box_number), '_status'));
    if connected
        set(status_handle, 'String', strcat('Box ', num2str(box_number), ': ', ' Connected'));
        set(status_handle, 'BackgroundColor', [.47, .67 .19]);
    else
        set(status_handle, 'String', strcat('Box ', num2str(box_number), ': ', ' Error'));
        set(status_handle, 'BackgroundColor', [.85, .33, .1]);
    end

function valve = get_valve(lane_number, is_inlet)
    global chipdata
    if is_inlet
        valve = chipdata.inlet_valves(lane_number);
    else
        valve = chipdata.outlet_valves(lane_number);
    end

function set_valve_state(lane_number, is_inlet, open, handles)
    global vc chipdata;
    
    set_valve_display(lane_number, is_inlet, open, handles)
    vc = vc_set_1bit(vc, get_valve(lane_number, is_inlet), open); 
    
function set_valve_display(lane_number, is_inlet, open, handles)
    type = 'outlet';
    if is_inlet
        type = 'inlet';
    end
    indicator_handle = handles.(strcat(type, '_state_', num2str(lane_number)));
    if open
        set(indicator_handle, 'String', 'OPEN');
        set(indicator_handle, 'BackgroundColor', [.47, .67 .19]);
    else
        set(indicator_handle, 'String', 'CLOSED');
        set(indicator_handle, 'BackgroundColor', [.85, .33, .1]);
    end

% set inlet or outlet
function set_half_valves(is_inlet, open, handles)
    global vc chipdata;
    
    values = ones(1,chipdata.num_lanes) * open;
    
    if is_inlet
        vc = vc_set_bits_ac(vc, [chipdata.inlet_valves], values);
    else
        vc = vc_set_bits_ac(vc, [chipdata.outlet_valves], values);
    end
    
    for i=1:chipdata.num_lanes
        set_valve_display(i, is_inlet, open, handles);
    end

% set all
function set_all_valves(open, handles)
    global vc chipdata;
    % TODO: This.
    % hObject    handle to open_all (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    values = ones(1,chipdata.num_lanes*2) * open;
    vc = vc_set_bits_ac(vc, [chipdata.inlet_valves chipdata.outlet_valves], values);
    
    for i=1:chipdata.num_lanes
        set_valve_display(i, 0, open, handles);
        set_valve_display(i, 1, open, handles);
    end

% --- Executes on button press in inlet_open_1.
function inlet_open_Callback(hObject, eventdata, handles)
% hObject    handle to inlet_open_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lane_number = get(hObject, 'UserData');
set_valve_state(lane_number, true, true, handles);


% --- Executes on button press in inlet_close_1.
function inlet_close_Callback(hObject, eventdata, handles)
% hObject    handle to inlet_close_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lane_number = get(hObject, 'UserData');
set_valve_state(lane_number, true, false, handles);


% --- Executes on button press in outlet_open_1.
function outlet_open_Callback(hObject, eventdata, handles)
% hObject    handle to outlet_open_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lane_number = get(hObject, 'UserData');
set_valve_state(lane_number, false, true, handles);


% --- Executes on button press in outlet_close_1.
function outlet_close_Callback(hObject, eventdata, handles)
% hObject    handle to outlet_close_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lane_number = get(hObject, 'UserData');
set_valve_state(lane_number, false, false, handles);


% --- Executes on button press in both_open_1.
function both_open_Callback(hObject, eventdata, handles)
% hObject    handle to both_open_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inlet_open_Callback(hObject, eventdata, handles);
outlet_open_Callback(hObject, eventdata, handles);


% --- Executes on button press in both_close_1.
function both_close_Callback(hObject, eventdata, handles)
% hObject    handle to both_close_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inlet_close_Callback(hObject, eventdata, handles);
outlet_close_Callback(hObject, eventdata, handles);


% --- Executes on button press in choose_file.
function choose_file_Callback(hObject, eventdata, handles)
global schedule;
% hObject    handle to choose_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path,~] = uigetfile({'*.xlsx', '*.xls'});
if filename ~= 0
    if path ~= 0
        hold off
        [schedule.times, schedule.lanes, schedule.valves, schedule.actions] = load_schedule(strcat(path, filename));
        plot_schedule(schedule.times, schedule.lanes, schedule.valves, schedule.actions);
        hold on
        schedule.current_time = 0;
        schedule.timeplot = plot([schedule.current_time, schedule.current_time], [-2, 47], 'b', 'LineWidth', 4);
        schedule.loaded = true;
        schedule.filename = filename;
        schedule.path = path;
        reset_schedule();
        update_schedule_view(handles);
    end
end

function update_schedule_view(handles)
    global schedule;
    set(handles.loaded_filename, 'String', strcat(schedule.path, schedule.filename));
    if schedule.loaded
        set(handles.run_file,'Enable','on')
        set(handles.run_file, 'String', 'Run');
        set(handles.stop_file, 'String', 'Reset');
    else
        set(handles.run_file,'Enable','off')
        set(handles.stop_file,'Enable','off')
    end

% --- Executes on button press in run_file.
function run_file_Callback(hObject, eventdata, handles)
    global schedule;
% hObject    handle to run_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if schedule.loaded
        set_manual_enable(false, handles);
        set(handles.run_file,'Enable','off');
        set(handles.stop_file,'Enable','on');
        set(handles.stop_file, 'String', 'Pause');
        set(handles.choose_file,'Enable','off');
        
        run_schedule(handles);
    end

%%% Run schedule.
function run_schedule(handles)
    global schedule;
    t0 = datevec(datenum(clock) - datenum([0 0 0 0 0 schedule.current_time*60]));
    schedule.running = true;
    while schedule.running
        schedule.current_time = etime(clock, t0)/60;
        x = [schedule.current_time, schedule.current_time];
        y = [-2, 47];
        set(schedule.timeplot,'XData',x,'YData',y);
        for i = 1:length(schedule.times)
            time = schedule.times(i);
            completed = schedule.completed(i);
            if time <= schedule.current_time && ~completed
                lane = schedule.lanes(i);
                valve = schedule.valves(i);
                action = schedule.actions(i);
                
                isOpen = strcmp(action, 'Open');
                
                if lane == 0
                    if strcmp(valve, 'Both') || strcmp(valve, 'Inlet')
                        set_half_valves(1, isOpen, handles);
                    end
                    if strcmp(valve, 'Both') || strcmp(valve, 'Outlet')
                        set_half_valves(0, isOpen, handles);
                    end
                else
                    if strcmp(valve, 'Both') || strcmp(valve, 'Inlet')
                        set_valve_state(lane, 1, isOpen, handles)
                    end
                    if strcmp(valve, 'Both') || strcmp(valve, 'Outlet')
                        set_valve_state(lane, 0, isOpen, handles)
                    end
                end
                schedule.completed(i) = true;
            end
        end
        if sum(schedule.completed == false) == 0
            if get(handles.should_loop, 'Value') == 1
                reset_schedule();
                t0 = clock;
            else
                stop_file_Callback(0, 0, handles);
            end
        end
        pause(0.016);
    end

% reset
function reset_schedule()
    global schedule;
    schedule.current_time = 0;
    x = [schedule.current_time, schedule.current_time];
    y = [-2, 47];
    set(schedule.timeplot,'XData',x,'YData',y);
    schedule.completed = zeros(length(schedule.times), 1);
    
% --- Executes on button press in stop_file.
function stop_file_Callback(hObject, eventdata, handles)
    global schedule;
% hObject    handle to stop_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if schedule.loaded
        if schedule.running == false
            % reset
            reset_schedule();
            set(handles.run_file, 'String', 'Run');
            set(handles.stop_file,'Enable','off')
        else
            % pause
            schedule.running = false;
            set_manual_enable(true, handles);
            set(handles.run_file,'Enable','on')
            set(handles.run_file, 'String', 'Resume');
            set(handles.choose_file,'Enable','on')
            set(handles.stop_file, 'String', 'Reset');
        end
    end

% --- Executes on button press in open_all.
function open_all_Callback(hObject, eventdata, handles)
set_all_valves(1, handles);


% --- Executes on button press in close_all.
function close_all_Callback(hObject, eventdata, handles)
set_all_valves(0, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vc;

vc = vc_close(vc, 1);

% Hint: delete(hObject) closes the figure
delete(hObject);
