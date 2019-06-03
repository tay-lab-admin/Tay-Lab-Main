function varargout = SIMPLE_GUI_01(varargin)
% SIMPLE_GUI_01 MATLAB code for SIMPLE_GUI_01.fig
%      SIMPLE_GUI_01, by itself, creates a new SIMPLE_GUI_01 or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI_01 returns the handle to a new SIMPLE_GUI_01 or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI_01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI_01.M with the given input arguments.
%
%      SIMPLE_GUI_01('Property','Value',...) creates a new SIMPLE_GUI_01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SIMPLE_GUI_01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SIMPLE_GUI_01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SIMPLE_GUI_01

% Last Modified by GUIDE v2.5 17-Feb-2017 15:33:05

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Van's comment %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Valve value = 0 means valve pressurized/closed

%%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SIMPLE_GUI_01_OpeningFcn, ...
                   'gui_OutputFcn',  @SIMPLE_GUI_01_OutputFcn, ...
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


% --- Executes just before SIMPLE_GUI_01 is made visible.
function SIMPLE_GUI_01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SIMPLE_GUI_01 (see VARARGIN)

% Choose default command line output for SIMPLE_GUI_01
handles.output = hObject;
% im = imread( 'Chip_01_LHS.tif' );
% imshow(im) % This was used on previous matlab version
% image(im)
global vc;
global chipdata;

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
% vc.info(1).polarity = logical(ones(1, 24));  % For 4th floor test system

% Serial number of USB interface in box #2
vc.info(2).sn = 'ELZ5KXT9'; % mj system
vc.info(2).handle = 0;
vc.info(2).status = 0;
% Polarity of valves in box #2
vc.info(2).polarity = logical([zeros(1, 24)]);
% vc.info(2).polarity = logical(ones(1, 24));

% Serial number of USB interface in box #3
vc.info(3).sn = 'ELZ5LP15'; % Ce system
vc.info(3).handle = 0;
vc.info(3).status = 0;
% Polarity of valves in box #3
% vc.info(3).polarity = logical([zeros(1, 24)]);
vc.info(3).polarity = [1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1]; % normally opened

%% Open connection to controller boxes
vc = vc_open_setup(vc);
% Check status of both connections
disp(['Status = 0 is good, 1 is bad']);
disp(['Status of box #1 = ' num2str(vc.info(1).status)]);
disp(['Status of box #2 = ' num2str(vc.info(2).status)]);
disp(['Status of box #3 = ' num2str(vc.info(3).status)]);

%%%%SPECIFY NEEDED PARAMETERS
chipdata.No_Valves = 72; % Specify the number of valves the chip has

% ***********Pumping valve configurations for the 6-step pumping program **************************************
% ***********Pumping valve configurations for the 6-step pumping program **************************************
% ***********Pumping valve configurations for the 6-step pumping program **************************************
chipdata.Pump_Pattern = [0, 1, 0; 0, 1, 1; 0, 0, 1; 1, 0, 1; 1, 0, 0; 1, 1, 0];
chipdata.Pump_Pattern_Reverse = fliplr(chipdata.Pump_Pattern);

chipdata.Pump01_valves = [1, 2, 3]; %set pump valve #s here
chipdata.Pump01_Cycle = 10; %should match default values on .fig
chipdata.Pump01_Timing = 500/1000; %should match default values on .fig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% ----- Color <----- do NOT change
chipdata.valve_close_color = [1 0 0];
chipdata.valve_open_color = [0 1 1];

chipdata.names={'V_00','V_01','V_02','V_03','V_04','V_05','V_06','V_07','V_08',...
    'V_09','V_10','V_11','V_12','V_13','V_14','V_15','V_16','V_17','V_18',...
    'V_19','V_20','V_21','V_22','V_23','V_24','V_25','V_26','V_27','V_28',...
    'V_29','V_30','V_31','V_32','V_33','V_34','V_35','V_36','V_37','V_38',...
    'V_39','V_40','V_41','V_42','V_43','V_44','V_45','V_46','V_47','V_48',...
    'V_49','V_50','V_51','V_52','V_53','V_54','V_55','V_56','V_57','V_58',...
    'V_59','V_60','V_61','V_62','V_63','V_64','V_65','V_66','V_67','V_68',...
    'V_69','V_70','V_71'}; %need to MANUALLY set to # of valves
chipdata.aux_names={'x00','x01', 'x02', 'chamber15_remote', 'chamber14_remote', 'chamber13_remote', 'chamber12_remote',...
    'chamber11_remote', 'chamber10_remote', 'chamber09_remote', 'chamber08_remote','chamber07_remote','chamber06_remote',...
    'chamber05_remote','x14','x15','x16','x17','x18','x19','x20','x21','x22','x23','x24','x25','Top_Branch_Remote', 'x27',...
    'x28','x29','x30','x31','x32','x33','x34','x35','x36','x37','Cell_Chamber_Bypass_Remote','Cell_Remote','Transfer_Valve_Remote',...
    'x41','x42','x43','Circulation_Chamber_Remote','Loop_Cutoff_Remote','chamber01_remote', 'chamber02_remote',...
    'chamber03_remote', 'chamber04_remote','x50','x51'};% MANUALLy specify here so that other commands will update button color

chipdata.multiplexer_names={'M01','M02','M03','M04','M05','M06','M07','M08',...
    'M09','M10','M11','M12','M13','M14','M15','M16','M17','M18',...
    'M19','M20','M21','M22','M23','M24','M25','M26','M27','M28',...
    'M29','M30','M31','M32','M33','M34','M35','M36','M37','M38',...
    'M39','M40',... # of multiplexers
    'Msubset_1to8','Msubset_9to16','Msubset_17to24',...
    'Msubset_25to32','Msubset_33to40'}; % subsets of 8 multiplexers

chipdata.All_valves = [00,01,02,03,04,05,06,07,08,09,...
    10,11,12,13,14,15,16,17,18,19,...
    20,21,22,23,24,25,26,27,28,29,...
    30,31,32,33,34,35,36,37,38,39,...
    40,41,42,43,44,45,46,47,48,49,...
    50,51,52,53,54,55,56,57,58,59,...
    60,61,62,63,64,65,66,67,68,69,...
    70,71];%need to MANUALLY set to # of valves

chipdata.multiplexer_valves = 0:10; % control multiple chamber columns
chipdata.supply_multiplexer_valves = 33:38;

%%%%%%%%SCRIPT VARIALBE%%%%%%%%%%%%%%%%%%%%%%
%%%%END of SPECIFY NEEDED PARAMETERS

guidata(hObject, handles);

% UIWAIT makes SIMPLE_GUI_01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SIMPLE_GUI_01_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in CLOSE_control.
function CLOSE_control_Callback(hObject, eventdata, handles)
global vc;
opt = questdlg('Are you sure you want to close valve controllers?',...
    'Close Valve Controllers');
if strcmpi(opt, 'yes')
        vc = vc_close(vc, 1);
        'contollers closed'
end
clear vc

% --- Executes on button press in Open_All.
function Open_All_Callback(hObject, eventdata, handles)
global vc chipdata
opt = questdlg('Are you sure you want to open all valves?',...
    'Open All Valves');
if strcmpi(opt, 'yes')
    b = length(chipdata.All_valves);
    values = ones(1,b);
    vc = vc_set_bits_ac(vc, chipdata.All_valves, values);
    for i=1:b
        set(handles.(chipdata.names{(chipdata.All_valves(i)+1)}), 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
    end
end
clear vc chipdata

% --- Executes on button press in Close_All.
function Close_All_Callback(hObject, eventdata, handles)
global vc chipdata
b = length(chipdata.All_valves);
values = zeros(1,b);
vc = vc_set_bits_ac(vc, chipdata.All_valves, values);
for i=1:b
    set(handles.(chipdata.names{(chipdata.All_valves(i)+1)}), 'BackgroundColor', chipdata.valve_close_color); % resets color of buttons
end
clear vc chipdata

% --- This is the basic function of switching the valves from open <-> closed which is called by the individual valves.
function V_XX_Callback(hObject, eventdata, handles)
global vc chipdata;
V_num = str2double(get(hObject,'String'));
[vc, value] = vc_get_1bit(vc, V_num);
vc = vc_set_1bit(vc, V_num, ~value);
set(hObject, 'BackgroundColor', xor(chipdata.valve_open_color,value));
clear vc chipdata

% --- Executes on button press in V_00.
function V_00_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_01.
function V_01_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_02.
function V_02_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_03.
function V_03_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_04.
function V_04_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_05.
function V_05_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_06.
function V_06_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_07.
function V_07_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_08.
function V_08_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_09.
function V_09_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_10.
function V_10_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_11.
function V_11_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_12.
function V_12_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_19.
function V_13_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_14.
function V_14_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_15.
function V_15_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_16.
function V_16_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_17.
function V_17_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_18.
function V_18_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_19.
function V_19_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_20.
function V_20_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_21.
function V_21_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_22.
function V_22_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_23.
function V_23_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_24.
function V_24_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_25.
function V_25_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_26.
function V_26_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_27.
function V_27_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_28.
function V_28_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_29.
function V_29_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_30.
function V_30_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_31.
function V_31_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_32.
function V_32_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_33.
function V_33_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_34.
function V_34_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_35.
function V_35_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_36.
function V_36_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_37.
function V_37_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_38.
function V_38_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
function V_39_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_40.
function V_40_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_41.
function V_41_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_42.
function V_42_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_43.
function V_43_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_44.
function V_44_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_45.
function V_45_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_46.
function V_46_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_47.
function V_47_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_48.
function V_48_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_49.
function V_49_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_50.
function V_50_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_51.
function V_51_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_52.
function V_52_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_53.
function V_53_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_54.
function V_54_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_55.
function V_55_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_56.
function V_56_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_57.
function V_57_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_58.
function V_58_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_59.
function V_59_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_60.
function V_60_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_61.
function V_61_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_62.
function V_62_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_63.
function V_63_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_64.
function V_64_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_65.
function V_65_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_66.
function V_66_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_67.
function V_67_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_68.
function V_68_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_69.
function V_69_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_70.
function V_70_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata
% --- Executes on button press in V_71.
function V_71_Callback(hObject, eventdata, handles)
global vc chipdata;
V_XX_Callback(hObject, eventdata, handles) %executes the called function
clear vc chipdata

% --- Executes on button press in Quit.
function Quit_Callback(hObject, eventdata, handles)
global vc;
opt = questdlg('Are you sure you want to quit?',...
    'Quit?');
if strcmpi(opt, 'yes')
        vc = vc_close(vc, 1);
        close all
        clear vc
end

% --- Executes during object creation, after setting all properties.
function Pump01_Timing_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%             Pump 01             %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Open_Pump01.
function Open_Pump01_Callback(hObject, eventdata, handles)
global vc chipdata;
b = length(chipdata.Pump01_valves);
values = ones(1,b);
vc = vc_set_bits_ac(vc, chipdata.Pump01_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.Pump01_valves(i)+1)}), 'BackgroundColor', chipdata.valve_open_color);
end
clear vc chipdata

% --- Executes on button press in Close_Pump01.
function Close_Pump01_Callback(hObject, eventdata, handles)
global vc chipdata;
b = length(chipdata.Pump01_valves);
values = zeros(1,b);
vc = vc_set_bits_ac(vc, chipdata.Pump01_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.Pump01_valves(i)+1)}), 'BackgroundColor', chipdata.valve_close_color);
end
clear vc chipdata

% --- Executes on button press in Pump01.
function Pump01_Callback(hObject, eventdata, handles)
% Top to Bottom 010	011	001	101	100	110
global vc chipdata;
b = size(chipdata.Pump_Pattern,1);
chipdata.stop01 = 0;
for i = 1:chipdata.Pump01_Cycle
    if chipdata.stop01
        break
    end
    for j = 1:b
        values = chipdata.Pump_Pattern(j,:);
        vc = vc_set_bits_ac(vc, chipdata.Pump01_valves, values);
        set(handles.(chipdata.names{chipdata.Pump01_valves(1)+1}), 'BackgroundColor', xor([1,0,0],values(1)));
        set(handles.(chipdata.names{chipdata.Pump01_valves(2)+1}), 'BackgroundColor', xor([1,0,0],values(2)));
        set(handles.(chipdata.names{chipdata.Pump01_valves(3)+1}), 'BackgroundColor', xor([1,0,0],values(3)));
        pause(chipdata.Pump01_Timing);
    end
end
clear vc chipdata

% --- Executes on button press in Pump01_Reverse.
function Pump01_Reverse_Callback(hObject, eventdata, handles)
% Top to Bottom 010	011	001	101	100	110
% Bottom to Top 010	110	100	101	001	011
global vc chipdata;
b = size(chipdata.Pump_Pattern_Reverse,1);
chipdata.stop01 = 0;
for i = 1:chipdata.Pump01_Cycle
    if chipdata.stop01
        break
    end
    for j = 1:b
        values = chipdata.Pump_Pattern_Reverse(j,:);
        vc = vc_set_bits_ac(vc, chipdata.Pump01_valves, values);
        set(handles.(chipdata.names{chipdata.Pump01_valves(1)+1}), 'BackgroundColor', xor([1,0,0],values(1)));
        set(handles.(chipdata.names{chipdata.Pump01_valves(2)+1}), 'BackgroundColor', xor([1,0,0],values(2)));
        set(handles.(chipdata.names{chipdata.Pump01_valves(3)+1}), 'BackgroundColor', xor([1,0,0],values(3)));
        pause(chipdata.Pump01_Timing);
    end
end
clear vc chipdata

function Pump01_Cycle_Callback(hObject, eventdata, handles)
global chipdata;
chipdata.Pump01_Cycle = str2double(get(hObject,'String'));
% disp(['#cycles = ' num2str(chipdata.Pump01_Cycle)]);
clear chipdata

function Pump01_Cycle_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pump01_Timing_Callback(hObject, eventdata, handles)
global chipdata;
timing = str2double(get(hObject,'String'));
chipdata.Pump01_Timing = timing / 1000; % convert to milliseconds
% disp(['#cylde delay (sec) = ' num2str(chipdata.P01timing)]); 
clear chipdata

% --- Executes on button press in Stop_Pump01.
function Stop_Pump01_Callback(hObject, eventdata, handles)
global chipdata;
chipdata.stop01 = 1;
clear chipdata

% --- Executes on button press in Input_To_Waste_A.
function Valve_Config_01_Callback(hObject, eventdata, handles)
global vc chipdata
%      [0,1,2,3,4,5,6,7,8  TEMPORARY!!!
values=[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
b=size(chipdata.All_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.All_valves, values);
for i=1:b;
    if values(i)==0;
      set(handles.(chipdata.names{(chipdata.All_valves(i)+1)}), 'BackgroundColor', chipdata.valve_close_color); % resets color of buttons
%       set(handles.(chipdata.aux_names{(chipdata.All_valves(i)+1)}), 'BackgroundColor', chipdata.valve_close_color); % resets color of buttons
    else if values(i)==1;
      set(handles.(chipdata.names{(chipdata.All_valves(i)+1)}), 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
%       set(handles.(chipdata.aux_names{(chipdata.All_valves(i)+1)}), 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
        end
    end
end
clear vc chipdata

% --- Executes on button press in M01. Multiplexer
function M01_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M02_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M03_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M04_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M05_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M06_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M07_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M08_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M09_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M10_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M11_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M12_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M13_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M14_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M15_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M16_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M17_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M18_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M19_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M20_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M21_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M22_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M23_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M24_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M25_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M26_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M27_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M28_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M29_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M30_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M31_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M32_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M33_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M34_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M35_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M36_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M37_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M38_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M39_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

function M40_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata

% --- Executes on button press in Msubset_1to8.
function Msubset_1to8_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,0,0,1,1,1,1,1,1,1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 1:8
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_open_color);
end
clear vc chipdata
% --- Executes on button press in Msubset_9to16.
function Msubset_9to16_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,0,1,0,1,1,1,1,1,1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 9:16
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_open_color);
end
clear vc chipdata
% --- Executes on button press in Msubset_17to24.
function Msubset_17to24_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,1,0,0,1,1,1,1,1,1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 17:24
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_open_color);
end
clear vc chipdata
% --- Executes on button press in Msubset_25to32.
function Msubset_25to32_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,1,0,0,0,1,1,1,1,1,1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 25:32
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_open_color);
end
clear vc chipdata
% --- Executes on button press in Msubset_33to40.
function Msubset_33to40_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,0,0,0,0,1,1,1,1,1,1]; % specify configuration for given iput channel
b=size(chipdata.multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i = 1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end

set(hObject, 'BackgroundColor', chipdata.valve_open_color);
for i = 33:40
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_open_color);
end
clear vc chipdata

% --- Executes on button press in M_Open_All.
function M_Open_All_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; % specify configuration for given iput channel
b = length(chipdata.multiplexer_valves); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i=1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
end

b = length(chipdata.multiplexer_names);
for i = 1:b
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
end
clear vc chipdata

% --- Executes on button press in M_Close_All.
function M_Close_All_Callback(hObject, eventdata, handles)
global vc chipdata
values =  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; % specify configuration for given iput channel
b = length(chipdata.multiplexer_valves); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.multiplexer_valves, values);
for i=1:b
    set(handles.(chipdata.names{(chipdata.multiplexer_valves(i)+1)}), 'BackgroundColor', chipdata.valve_close_color); % resets color of buttons
end

b = length(chipdata.multiplexer_names);
for i = 1:b
    set(handles.(chipdata.multiplexer_names{i}), 'BackgroundColor', chipdata.valve_close_color); % resets color of buttons
end
clear vc chipdata

% --- Executes on button press in display_values.
function display_values_Callback(hObject, eventdata, handles)
global vc chipdata
b = length(chipdata.All_valves);
state_values = zeros(1,b);
for i = 1:b
    [~, state_values(i)] = vc_get_1bit(vc, i-1);
end
%  fprintf(sprintf('%d,',state_values))
sprintf('%d,',state_values)
clear vc chipdata

function edit10_Callback(hObject, eventdata, handles)
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit11_Callback(hObject, eventdata, handles)
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit12_Callback(hObject, eventdata, handles)
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit13_Callback(hObject, eventdata, handles)
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit14_Callback(hObject, eventdata, handles)
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit15_Callback(hObject, eventdata, handles)
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit16_Callback(hObject, eventdata, handles)
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit17_Callback(hObject, eventdata, handles)
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit18_Callback(hObject, eventdata, handles)
function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit19_Callback(hObject, eventdata, handles)
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit20_Callback(hObject, eventdata, handles)
function edit20_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit21_Callback(hObject, eventdata, handles)
function edit21_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit22_Callback(hObject, eventdata, handles)
function edit22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit23_Callback(hObject, eventdata, handles)
function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit24_Callback(hObject, eventdata, handles)
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in S_01.
function S_01_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,0,1,1,1]; % specify configuration for given iput channel
b=size(chipdata.supply_multiplexer_valves,2); % Returns number of valves being manipulated
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_02.
function S_02_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,1,0,1,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_03.
function S_03_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,1,0,0,1,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_04.
function S_04_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,0,0,0,1,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_05.
function S_05_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,1,1,0,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_06.
function S_06_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,1,0,1,0,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_07.
function S_07_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,0,0,1,0,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_08.
function S_08_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,0,1,0,0,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_09.
function S_09_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,1,1,0,0,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_10.
function S_10_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,1,0,1,0,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_11.
function S_11_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,1,0,0,1,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_12.
function S_12_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,1,0,0,0,1];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_13.
function S_13_Callback(hObject, eventdata, handles)
global vc chipdata
values = [1,0,1,1,0,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_14.
function S_14_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,1,1,1,0,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in S_15.
function S_15_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,1,1,1,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(hObject, 'BackgroundColor', chipdata.valve_open_color); % resets color of buttons
for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', xor(chipdata.valve_close_color,values(i))); % resets color of buttons
end
clear vc chipdata
% --- Executes on button press in Close_All_Supply.
function Close_All_Supply_Callback(hObject, eventdata, handles)
global vc chipdata
values = [0,0,0,0,0,0];
b=size(chipdata.supply_multiplexer_valves,2);
vc = vc_set_bits_ac(vc, chipdata.supply_multiplexer_valves, values);

set(handles.S_01, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_02, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_03, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_04, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_05, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_06, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_07, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_08, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_09, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_10, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_11, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_12, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_13, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_14, 'BackgroundColor', chipdata.valve_close_color);
set(handles.S_15, 'BackgroundColor', chipdata.valve_close_color);

for i=1:b
    set(handles.(chipdata.names{(chipdata.supply_multiplexer_valves(i)+1)}), 'BackgroundColor', chipdata.valve_close_color);
end
clear vc chipdata


function pushbutton2_Callback(hObject, eventdata, handles)
% blank to not give an error

function pushbutton3_Callback(hObject, eventdata, handles)
% blank to not give an error
