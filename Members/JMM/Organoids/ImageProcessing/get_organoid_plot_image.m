function v = get_organoid_plot_image(organoids, frame_number)
    ids = unique(organoids(:, end));

    p = figure('visible', 'off');
    hold on;
    minS = Inf;
    maxS = -Inf;
    for id = ids'
        organoid = organoids(find(organoids(:, end) == id), :);
        sizes = organoid(:, 3) * 1.3;
        minS = min(minS, min(sizes));
        maxS = max(maxS, max(sizes));
        times = organoid(:, end-1);
        plot(times, sizes, '--o');
    end

    range = [minS maxS] + ([-1 1] * .1 * (maxS-minS));
    ylim(range);
    ylabel('Major Axis Diameter (\mum)');
    xlabel('Time (hr)');
    legend(cellfun(@num2str,num2cell(ids),'uniformoutput',0))

    tplot = plot([0 0], range, 'LineWidth', 2, 'color', [0 0 1]);

    set(tplot, 'XData', [frame_number frame_number]);
    v = frame2im(getframe(p));
end