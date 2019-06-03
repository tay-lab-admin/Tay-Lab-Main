function A = compute_amount(cell_x, cell_y, cell_z, cell_diameter, ...
    barcode_x, barcode_y, barcode_z, copies_per_barcode, ...
    barcode_diffusion_time, diffusion_coefficient)
xp = barcode_x - cell_x;
yp = barcode_y - cell_y;
zp = barcode_z - cell_z;
r = cell_diameter/2;
c = sqrt(diffusion_coefficient * barcode_diffusion_time); % Microns (one standard deviation)
a = copies_per_barcode / ((sqrt(2*pi) * c))^3;

conc_func = @(x, y, z) a * exp(-((x-xp).^2 + (y-yp).^2 + (z-zp).^2)/(2*c^2));

xmin = -r;
xmax = r;
ymin = @(x) -sqrt(r^2-x.^2);
ymax = @(x) sqrt(r^2-x.^2);
zmin = @(x,y) -sqrt(r^2-x.^2-y.^2);
zmax = @(x,y) sqrt(r^2-x.^2-y.^2);

A = integral3(conc_func, xmin, xmax, ymin, ymax, zmin, zmax, 'Method', 'tiled');
end