function plot_circles(a, b, circles)
    hold on;
    axis equal;
    axis([0 a 0 b]);
    for i = 1:size(circles, 1)
        plot_circle(circles(i, 1), circles(i, 2), circles(i, 3));
    end
    hold off
end
