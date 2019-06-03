% Calculate cell barcode amounts
fprintf('Calculating amount of barcode ');
n = 0;
cell_barcode_concentrations = zeros(num_cells, num_barcodes);
for cell_number = 1:num_cells
    for barcode_number = 1:num_barcodes
        fprintf(repmat('\b', 1, n));
        n = fprintf('%d/%d in cell %d/%d', barcode_number, num_barcodes, cell_number, num_cells);
        cell_x = cell_positions(cell_number, 1);
        cell_y = cell_positions(cell_number, 2);
        cell_z = cell_positions(cell_number, 3);
        barcode_x = barcode_positions(barcode_number, 1);
        barcode_y = barcode_positions(barcode_number, 2);
        barcode_z = barcode_positions(barcode_number, 3);
        
        true_amount = compute_amount(cell_x, cell_y, cell_z, cell_diameter,...
                barcode_x, barcode_y, barcode_z, ...
                copies_per_barcode, barcode_diffusion_time, diffusion_coefficient);
        
        % Binomial sampling at sensitivy of sequencing method
        bdist = makedist('Binomial', 'N', round(true_amount), 'p', detection_sensitivity);
        cell_barcode_concentrations(cell_number, barcode_number) = random(bdist);
    end
end
fprintf('\nDone.\n');