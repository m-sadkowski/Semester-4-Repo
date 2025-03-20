function plot_circle(X, Y, R)
    % X - współrzędna x środka okręgu
    % Y - współrzędna y środka okręgu
    % R - promień okręgu
    theta = linspace(0,2*pi);
    x = R*cos(theta) + X;
    y = R*sin(theta) + Y;
    plot(x,y)
end
