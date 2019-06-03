function centers = EliminateNeighborDistances(centroids, minDistance)
   centers = [centroids{1}];
   for i = 2:length(centroids)
       centroid = centroids{i};
       distances = sqrt(sum((centroid-centers).^2, 2));
       if sum(distances <= minDistance)
           continue
       else
           centers = [centers;centroid];
       end
   end
end

