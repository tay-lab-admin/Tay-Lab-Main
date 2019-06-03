function numberOfCells = CountCells(image, cellRadiusApproximate)
    adjusted = adapthisteq(image);
    
    I = adjusted;
    I = imbinarize(I, 'adaptive');
    
    
end

