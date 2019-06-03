cell_colors = distinguishable_colors(num_cells);

[x, y, z] = sphere;
clf
if show_per_cell_plots
    subplot(2, 2, 1);
else
    subplot(1, 2, 1);
end
title('Simulated Gel');
hold on
xlim([0 maxdim]);
ylim([0 maxdim]);
zlim([0 maxdim]);
xticks([0 maxdim]);
yticks([0 maxdim]);
zticks([0 maxdim]);

xlabel('X (\mum)');
ylabel('Y (\mum)');
zlabel('Z (\mum)');

barcode_color = [1 1 1];
decay = 0.8;
bc_std = sqrt(diffusion_coefficient * barcode_diffusion_time);
plot3(barcode_positions(:, 1), barcode_positions(:, 2), barcode_positions(:, 3),'o', 'MarkerSize', 15, 'Color', barcode_color*decay*decay)
plot3(barcode_positions(:, 1), barcode_positions(:, 2), barcode_positions(:, 3),'o', 'MarkerSize', bc_std*2, 'Color', barcode_color*decay)
plot3(barcode_positions(:, 1), barcode_positions(:, 2), barcode_positions(:, 3),'o', 'MarkerSize', bc_std*4, 'Color', barcode_color)
labels = arrayfun(@(in) num2str(in), 1:num_barcodes, 'un', 0);
text(barcode_positions(:, 1), barcode_positions(:, 2), barcode_positions(:, 3), labels, 'HorizontalAlignment', 'Center', 'Color', barcode_color*decay*decay, 'FontSize', 8)

% plot cell
for cell_number = 1:num_cells
    newX = (cell_diameter/2 * x) + cell_positions(cell_number, 1);
    newY = (cell_diameter/2 * y) + cell_positions(cell_number, 2);
    newZ = (cell_diameter/2 * z) + cell_positions(cell_number, 3);
    surf(newX, newY, newZ, 'FaceColor', cell_colors(cell_number, :), 'EdgeColor', cell_colors(cell_number, :));
end
    
view(3)
camproj('perspective')
axis vis3d

widerange = [0 maxdim];
minrange = [0 0];
maxrange = [maxdim maxdim];

boxcolor = [1 1 1] * .5;
plot3(widerange, minrange, minrange, 'Color', boxcolor);
plot3(widerange, maxrange, maxrange, 'Color', boxcolor);
plot3(widerange, minrange, maxrange, 'Color', boxcolor);
plot3(widerange, maxrange, minrange, 'Color', boxcolor);

plot3(minrange, widerange, minrange, 'Color', boxcolor);
plot3(maxrange, widerange, maxrange, 'Color', boxcolor);
plot3(minrange, widerange, maxrange, 'Color', boxcolor);
plot3(maxrange, widerange, minrange, 'Color', boxcolor);

plot3(maxrange, maxrange, widerange, 'Color', boxcolor);
plot3(minrange, minrange, widerange, 'Color', boxcolor);
plot3(maxrange, minrange, widerange, 'Color', boxcolor);
plot3(minrange, maxrange, widerange, 'Color', boxcolor);

if show_per_cell_plots
    subplot(2, 2, 3);
else
    subplot(1, 2, 2);
end

minx = min(reconstructed_points(:, 1));
maxx = max(reconstructed_points(:, 1));
miny = min(reconstructed_points(:, 2));
maxy = max(reconstructed_points(:, 2));
minz = min(reconstructed_points(:, 3));
maxz = max(reconstructed_points(:, 3));

maxdim_reconstructed = max([maxx-minx maxy-miny maxz-minz])*.8;

xlim([-maxdim_reconstructed maxdim_reconstructed]);
ylim([-maxdim_reconstructed maxdim_reconstructed]);
zlim([-maxdim_reconstructed maxdim_reconstructed]);
xticks([]);
yticks([]);
zticks([]);

xlabel('Axis 1 (AU)');
ylabel('Axis 2 (AU)');
zlabel('Axis 3 (AU)');

title('Reconstruction of Simulated Gel');

hold on

% plot predicted cell
for cell_number = 1:num_cells
    newX = (reconstructed_diameter/2 * x) + reconstructed_points(cell_number, 1);
    newY = (reconstructed_diameter/2 * y) + reconstructed_points(cell_number, 2);
    newZ = (reconstructed_diameter/2 * z) + reconstructed_points(cell_number, 3);
    surf(newX, newY, newZ, 'FaceColor', cell_colors(cell_number, :), 'EdgeColor', cell_colors(cell_number, :));
end
    
view(3)
camproj('perspective')
axis vis3d

widerange = [-maxdim_reconstructed maxdim_reconstructed];
minrange = [-maxdim_reconstructed -maxdim_reconstructed];
maxrange = [maxdim_reconstructed maxdim_reconstructed];

boxcolor = [1 1 1] * .5;
plot3(widerange, minrange, minrange, 'Color', boxcolor);
plot3(widerange, maxrange, maxrange, 'Color', boxcolor);
plot3(widerange, minrange, maxrange, 'Color', boxcolor);
plot3(widerange, maxrange, minrange, 'Color', boxcolor);

plot3(minrange, widerange, minrange, 'Color', boxcolor);
plot3(maxrange, widerange, maxrange, 'Color', boxcolor);
plot3(minrange, widerange, maxrange, 'Color', boxcolor);
plot3(maxrange, widerange, minrange, 'Color', boxcolor);

plot3(maxrange, maxrange, widerange, 'Color', boxcolor);
plot3(minrange, minrange, widerange, 'Color', boxcolor);
plot3(maxrange, minrange, widerange, 'Color', boxcolor);
plot3(minrange, maxrange, widerange, 'Color', boxcolor);

if show_per_cell_plots
    for cell_number = 1:num_cells
        if mod(cell_number, 2) == 1
            subplot(ceil(num_cells/2), 4, 2*cell_number+1);
        else
            subplot(ceil(num_cells/2), 4, 2*cell_number);
        end
        bar(cell_barcode_concentrations(cell_number, :), 'FaceColor', cell_colors(cell_number, :), 'EdgeColor', cell_colors(cell_number, :));
        xlabel('Barcode Number');
        ylabel('Copies In Cell (mmol)');
        legend(sprintf('Cell %d', cell_number));
    end
end

subtitle(sprintf('Virtual %dx%dx%d \\mum^3 gel with %d cells (diameter: %d \\mum) and %d barcodes (%d copies per barcode, diffusion coefficient: %d \\mum^2/sec, diffusion time: %d sec, detection sensitivity: %d%%, scaling mode: %s)',...
    xdim, ydim, zdim, num_cells, cell_diameter, num_barcodes, copies_per_barcode, diffusion_coefficient, barcode_diffusion_time, detection_sensitivity*100, scaling_mode));

cameratoolbar;