%%%%%%%% Settings %%%%

% In microns -- size of the virtual gel
xdim = 50;
ydim = 50;
zdim = 50;

cell_diameter = 10;         % In microns -- the diameter of each cell
cell_spawn_mode = 'Grid';   % Set to 'Random' or 'Grid'
% Random variables
num_cells = 10;             % Number of cells in the gel (these are randomly distributed with no overlap)
% Grid variables
cell_spacing = 10;                % Spacing between cells

num_barcodes = 100;         % Number of unique barcodes added to the gel
copies_per_barcode = 100000;    % Raw number of copies of each barcode in the gel
barcode_diffusion_time = 10; % In seconds -- amount of time allowed for the barcodes to diffuse through the gel
diffusion_coefficient = 10;       % In microns squared per second -- diffusion coefficient of the gel for the barcodes

detection_sensitivity = .1;

scaling_mode = 'Logarithmic'; % Set to 'Logarithmic', 'Reciprocal', or 'None'

%%% Plot settings
show_per_cell_plots = true;

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
