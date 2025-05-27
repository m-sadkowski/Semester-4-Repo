function [x, y, z, zmin, lake_volume] = compute_lake_volume_monte_carlo()
    % Wyznacza objętość jeziora metodą Monte Carlo.
    %
    % x/y/z - wektory wierszowe, które zawierają współrzędne x/y/z punktów
    %       wylosowanych w celu wyznaczenia przybliżonej objętości jeziora
    % zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów
    % lake_volume - objętość jeziora wyznaczona metodą Monte Carlo

    N = 1e6;
    x = 100*rand(1,N); % [m]
    y = 100*rand(1,N); % [m]
    
    zmin = -80;
    z = zmin + (0 - zmin) * rand(1, N);

    N_1 = 0;

    for i = 1:N
        lake_depth = get_lake_depth(x(i), y(i));
        if z(i) >= lake_depth
            N_1 = N_1 + 1;
        end
    end

    V = 100 * 100 * (0 - zmin);
    lake_volume = (N_1 / N) * V;
end