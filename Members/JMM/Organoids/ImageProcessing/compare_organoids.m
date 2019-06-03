function rmse = compare_organoids(organoids, manual, number)
organoid = organoids((organoids(:, end) == number), :);
organoid_sizes = organoid(:, 3);
organoid_times = organoid(:, end-1);
clf
subplot(3, 1, 1);
plot(organoid_times, organoid_sizes, 'o-')
hold on
plot(1:136, manual, 'o-r')

subplot(3, 1, 2);
organoid_manual_times = manual(organoid_times);

difference = organoid_manual_times - organoid_sizes;
rmse = 1.3 * sqrt(sum(difference.^2)/length(difference))

organoid_manual_times_corrected = organoid_manual_times + (mean(organoid_sizes)-mean(organoid_manual_times));
plot(organoid_times, organoid_sizes, 'o-')
hold on
plot(organoid_times, organoid_manual_times_corrected, 'o-r')

difference = organoid_manual_times - organoid_sizes;
rmse = 1.3 * sqrt(sum(difference.^2)/length(difference))

subplot(3, 1, 3);

organoid_manual_times_normalized = organoid_manual_times ./ organoid_manual_times(1);
organoid_sizes_normalized = organoid_sizes ./ organoid_sizes(1);
plot(organoid_times, organoid_sizes_normalized, 'o-')
hold on
plot(organoid_times, organoid_manual_times_normalized, 'o-r')

difference = organoid_manual_times - organoid_sizes;
rmse = 1.3 * sqrt(sum(difference.^2)/length(difference))