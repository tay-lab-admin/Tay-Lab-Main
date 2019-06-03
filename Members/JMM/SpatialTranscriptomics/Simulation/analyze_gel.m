if strcmp(scaling_mode, 'Logarithmic')
    cell_barcode_concentrations_rescale = log(rescale(nthroot(cell_barcode_concentrations, 3), 1, 2));
elseif strcmp(scaling_mode, 'Reciprocal')
    cell_barcode_concentrations_rescale = 1./(rescale(nthroot(cell_barcode_concentrations, 3), 1, 2));
elseif strcmp(scaling_mode, 'None')
    cell_barcode_concentrations_rescale = rescale(nthroot(cell_barcode_concentrations, 3), 1, 2);
end
calculated_distances = squareform(pdist(cell_barcode_concentrations_rescale));

reconstructed_points = mdscale(calculated_distances, 3);
reconstructed_diameter = min(calculated_distances(calculated_distances ~= 0))/2;