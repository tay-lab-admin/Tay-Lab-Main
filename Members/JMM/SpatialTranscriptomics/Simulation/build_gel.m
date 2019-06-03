maxdim = max([xdim ydim zdim]);
barcode_positions = rand(num_barcodes, 3) .* [xdim ydim zdim];

if strcmp(cell_spawn_mode, 'Random')
    cell_positions = zeros(num_cells, 3);
    for cell_number = 1:num_cells
        fprintf('Making cell %d. \n', cell_number);
        min_cell_distance = 0;
        min_wall_distance = 0;
        while min_cell_distance < cell_diameter || min_wall_distance < cell_diameter/2
            test_cell_pos = rand(1, 3) .* [xdim ydim zdim];
            cell_distances = sqrt(sum((cell_positions(1:cell_number-1, :) - test_cell_pos).^2, 2));

            walls = ...
                [test_cell_pos(1)   test_cell_pos(2)    0; ...
                 test_cell_pos(1)   test_cell_pos(2)    zdim; ...
                 test_cell_pos(1)   0                   test_cell_pos(3); ...
                 test_cell_pos(1)   ydim                test_cell_pos(3); ...
                 0                  test_cell_pos(2)    test_cell_pos(3); ...
                 xdim               test_cell_pos(2)    test_cell_pos(3)];
            wall_distances = sqrt(sum((walls - test_cell_pos).^2, 2));

            min_wall_distance = min(wall_distances);
            min_cell_distance = min(cell_distances);
            if isempty(min_cell_distance)
                min_cell_distance = Inf;
            end
        end

        % Add cell to list
        cell_positions(cell_number, :) = test_cell_pos;
    end
elseif strcmp(cell_spawn_mode, 'Grid')
    x_range= (cell_diameter/2):(cell_spacing+cell_diameter):(xdim-cell_diameter/2);
    y_range= (cell_diameter/2):(cell_spacing+cell_diameter):(ydim-cell_diameter/2);
    z_range= (cell_diameter/2):(cell_spacing+cell_diameter):(zdim-cell_diameter/2);
    cell_positions = combvec(x_range, y_range, z_range)';
    num_cells = length(cell_positions(:, 1));
end
