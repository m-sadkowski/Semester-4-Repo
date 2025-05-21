function [dates, y, M, a, b, x_fine, ya, rmse_values] = test_trigonometric_approximation()
% 1) Wyznacza pierwiastek błędu średniokwadratowego w zależności od liczby
%    harmonicznych zastosowanych w aproksymacji trygonometrycznej.
% 2) Wyznacza i przedstawia na wykresie aproksymację trygonometryczną.
% Dla kraju C oraz źródła energii S:
% dates - wektor energy_2025.C.S.Dates (daty pomiaru produkcji energii)
% y - wektor energy_2025.C.S.EnergyProduction (poziomy miesięcznych produkcji energii)
% M - liczba harmonicznych zastosowana w aproksymacji (dla wykresu)
% a - współczynniki amplitudowe funkcji cosinus
% b - współczynniki amplitudowe funkcji sinus
% x_fine - określa próbkowanie funkcji aproksymacyjnej.
% ya - wartości aproksymacji trygonometrycznej wyznaczone dla siatki punktów
%       określonej przez x_fine
% rmse_values(i,1) - RMSE wyznaczony dla wektora y i rezultatu aproksymacji
%       trygonometrycznej.

    M = 20; 

    load energy_2025

    dates = energy_2025.Poland.Coal.Dates;
    y = energy_2025.Poland.Coal.EnergyProduction;

    N = numel(y);
    x = (0:N-1)';  % oryginalna siatka
    k_max = floor(N/2);

    % Gęsta siatka do aproksymacji
    Mx = 4; % Mx = (x_fine(2)-x_fine(1)) / (x(2)-x(1))
    x_fine = linspace(0,N-1,Mx*(N-1)+1)';
    % x_fine = x;

    % FFT danych
    [a, b] = calculate_ab_from_DFT(y);
    
    % Aproksymacja dla ustalonej liczby harmonicznych
    % M = k_max;
    ya = trigonometric_approximation(x_fine, N, M, a, b);

    % RMSE: dane wejściowe vs. aproksymacja trygonometryczna
    rmse_values = zeros(k_max,1);
    for k = 1:k_max
        ya4rmse = trigonometric_approximation(x, N, k, a, b);
        rmse_values(k) = sqrt(mean((y - ya4rmse).^2));
    end

    % Wykresy
    figure

    subplot(2, 1, 1);
    plot(1:k_max, rmse_values, 'b-', 'LineWidth', 1.5);
    title('RMSE w zależności od liczby harmonicznych');
    xlabel('Liczba harmonicznych');
    ylabel('RMSE');
    grid on;

    subplot(2, 1, 2);
    plot(x, y, 'k-', 'DisplayName', 'Dane oryginalne', 'LineWidth', 1.5); hold on;
    plot(x_fine, ya, 'r-', 'DisplayName', sprintf('Aproksymacja (%d harmonicznych)', M), 'LineWidth', 1.5);
    hold off;
    title('Aproksymacja trygonometryczna');
    xlabel('Indeks');
    ylabel('Produkcja energii');
    legend('Location', 'best');
    grid on;
end

function ya = trigonometric_approximation(x_fine, N, M, a, b)
    % Wyznacza wartość aproksymacji trygonometrycznej.
    % x_fine - określa próbkowanie funkcji aproksymacyjnej.
    % N - liczba danych wejściowych
    % M - liczba harmonicznych zastosowana do trygonomicznej aproksymacji
    % a - współczynniki amplitudowe funkcji cosinus
    % b - współczynniki amplitudowe funkcji sinus
    if(N==0)
        ya = [];
        return;
    end


    k_max = length(a) - 1;
    ya = zeros(length(x_fine), 1);

    ya = ya + a(1);  % składowa stała

    if(M>k_max)
        M = k_max;
    end

    for n = 1:M
        ya = ya + a(n+1)*cos(2*pi*n*x_fine/N) + b(n+1)*sin(2*pi*n*x_fine/N);
    end
end


function [a, b] = calculate_ab_from_DFT(x)
    if(length(x)==0)
        a = [];
        b = [];
        return
    end
    N = length(x);
    Y = fft(x);
    k_max = floor(N/2);  % całkowita liczba harmonicznych

    a = zeros(k_max+1, 1);
    b = zeros(k_max+1, 1);

    % Składowa stała
    a(1) = real(Y(1)) / N;

    for n = 1:k_max
        idx = n + 1;

        % Sprawdzenie, czy to częstotliwość Nyquista
        is_nyquist = (mod(N,2) == 0) && (n == N/2);

        if is_nyquist
            a(idx) = real(Y(n+1)) / N;
            b(idx) = 0;
        else
            a(idx) = 2 * real(Y(n+1)) / N;
            b(idx) = -2 * imag(Y(n+1)) / N;
        end
    end
end