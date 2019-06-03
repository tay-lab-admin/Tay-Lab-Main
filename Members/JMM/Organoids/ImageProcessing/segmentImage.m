function [mask] = segmentImage(I, lastCentroids)
I_eq = imadjust(I);

bw1 = imbinarize(I_eq, adaptthresh(I_eq, 0.2));
bw2 = imclose(bw1, ones(10, 10));
bw2 = imfill(bw2,'holes');
bw2 = bwmorph(bw2, 'thin', 5);

bw3 = imopen(bw2, ones(10, 10));
bw3 = bwareaopen(bw3, 800);
bw3 = bwmorph(bw3, 'thick', 5);

pw_mask = bw3;

fgm = imextendedmax(bwdist(~pw_mask), 3);

if ~isempty(lastCentroids)
    for centroid_index = 1:size(lastCentroids, 1)
        centroid = lastCentroids(centroid_index, :);
        fgm(floor(centroid(2)), floor(centroid(1))) = true;
    end
end

fgm = imdilate(fgm, strel('disk', 15));

basin = -bwdist(~pw_mask);
imposed = imimposemin(basin, ~pw_mask | fgm);
L = watershed(imposed);
pw_mask(L == 0) = 0;
mask = bwareaopen(pw_mask, 800);

organoids = regionprops(mask, {'PixelIdxList', 'Eccentricity'});
for i = 1:length(organoids)
    if organoids(i).Eccentricity > 0.6
        mask(organoids(i).PixelIdxList) = 0;
    end
end

verbose = false;
if verbose
    bw4 = imposed;
    bw5 = label2rgb(L);
    bw6 = mask;
    
    figure
    imshow(I_eq);
    
    figure
    subplot(3, 2, 1)
    imshow(bw1)
    title('(BW1)')
    
    subplot(3, 2, 2)
    imshow(bw2)
    title('(BW2)')
    
    subplot(3, 2, 3)
    imshow(bw3)
    title('(BW3)')
    
    subplot(3, 2, 4)
    imshow(bw4, [])
    title('(BW4)')
    
    subplot(3, 2, 5)
    imshow(bw5, [])
    title('(BW5)')
    
    subplot(3, 2, 6)
    title('(BW6)')
    imshow(bw6, [])
end