function f = get_lake_depth( x, y )
    % Zwraca aproksymację głębokości jeziora w punkcie (x,y).
    % Zmienna f określa głębokość jeziora w metrach.

    % Sprawdzenie liczby argumentów
    if nargin ~= 2
        error('Funkcja wymaga dokładnie dwóch argumentów: x oraz y.');
    end

    % Sprawdzenie typu danych
    if ~isnumeric(x) || ~isnumeric(y)
        error('Argumenty x i y muszą być typu numerycznego (double).');
    end

    if ~isa(x, 'double') || ~isa(y, 'double')
        error('Argumenty x i y muszą być typu double.');
    end

    % Sprawdzenie wymiarów: wektory wierszowe
    if ~isrow(x) || ~isrow(y)
        error('Zarówno x, jak i y muszą być wektorami wierszowymi.');
    end

    % Sprawdzenie zgodności rozmiarów
    if length(x) ~= length(y)
        error('Wektory x i y muszą mieć ten sam rozmiar.');
    end


    x = x/100;
    y = y/100;

    w1=5; a1=30; x1=0.2; y1=0.3;
    w2=6; a2=40; x2=0.6; y2=1.0;
    w3=7; a3=50; x3=0.9; y3=0.5;
    w4=6; a4=40; x4=0.6; y4=0.1;
    w5=7; a5=70; x5=0.1; y5=0.95;
    w6=-5; a6=10; x6=0.5; y6=0.5;
    f=10 + w1*exp(-a1*((x-x1).^2+(y-y1).^2))+w2*exp(-a2*((x-x2).^2+(y-y2).^2))+w3*exp(-a3*((x-x3).^2+(y-y3).^2))+w4*exp(-a4*((x-x4).^2+(y-y4).^2))+w5*exp(-a5*((x-x5).^2+(y-y5).^2))+w6*exp(-a6*((x-x6).^2+(y-y6).^2));
    f = f - 9.5;
    f = f * 10;
    f(f>0) = 0;
end

