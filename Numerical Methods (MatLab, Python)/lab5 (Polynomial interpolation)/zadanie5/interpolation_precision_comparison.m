function [coef_double, coef_vpa, y_double, y_vpa, y_mix] = ...
        interpolation_precision_comparison()
% Funkcja ilustrująca wpływ precyzji obliczeń na interpolację wielomianową.
% coef_double - wsp. wielomianu interpolacyjnego wyznaczone operując na zmiennych double
% coef_vpa - wsp. wielomianu interpolacyjnego wyznaczone operując na zmiennych vpa
% Wartości wielomianów interpolacyjnych wyznaczone dla x_fine = linspace(-1, 1, 1000):
% y_double - wartości double wielomianu określonego przez coef_double
% y_vpa - wartości vpa wielomianu określonego przez coef_vpa
% y_mix - wartości double wielomianu określonego przez double(coef_vpa)

    f = @(x) 1 ./ (1 + 25 * x.^2); % interpolowana jest funkcja Rungego

    % Węzły interpolacji:
    n = 80;
    x_nodes = linspace(-1, 1, n);
    y_nodes = f(x_nodes);

    % Gęsta siatka punktów do testowania interpolacji
    x_fine = linspace(-1, 1, 1000);

    % Interpolacja z użyciem double
    V_double = get_vandermonde_matrix(x_nodes);
    coef_double = V_double \ y_nodes';
    coef_double = coef_double(end:-1:1);
    y_double = polyval(coef_double, x_fine);

    % Interpolacja z użyciem vpa
    digits(50);
    indices = vpa(0:n-1);
    a = vpa(-1);
    b = vpa(1);
    x_nodes_vpa = a + indices * (b - a) / vpa(n - 1);
    y_nodes_vpa = f(x_nodes_vpa);

    V_vpa = get_vandermonde_matrix_vpa(x_nodes_vpa);
    coef_vpa = V_vpa \ y_nodes_vpa';
    coef_vpa = coef_vpa(end:-1:1);
    y_vpa = polyval_vpa(coef_vpa, vpa(x_fine));

    % Współczynniki vpa konwertowane na double do obliczeń wartości wielomianu
    % wykonanych na zmiennych double
    coef_vpa_to_double = double(coef_vpa);
    y_mix = polyval(coef_vpa_to_double, x_fine);

    % Wykresy
    figure;
    subplot(3,1,1);
    plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_double, 'r-', 'LineWidth', 1, 'DisplayName', 'double');
    axis([-1 1 -2 2]);
    legend('show');
    title('Interpolacja z double');
    xlabel('x');
    ylabel('f(x)');
    grid on;

    subplot(3,1,2);
    plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, double(y_vpa), 'b-', 'LineWidth', 1, 'DisplayName', 'vpa');
    axis([-1 1 -2 2]);
    legend('show');
    title('Interpolacja z vpa');
    xlabel('x');
    ylabel('f(x)');
    grid on;

    subplot(3,1,3);
    plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_mix, 'g-', 'LineWidth', 1, 'DisplayName', 'vpa na double');
    axis([-1 1 -2 2]);
    legend('show');
    title('Współczynniki vpa konwertowane na double');
    xlabel('x');
    ylabel('f(x)');
    grid on;

    set(gcf, 'Position', [1000 500 2000 1500]);
end

function y = polyval_vpa(coefficients, x)
% Oblicza wartość wielomianu w punktach x dla argumentów vpa.
% coefficients – wektor współczynników wielomianu [an,...,a0]; (zmienna vpa)
% x – wektor argumentów (vpa)
% y – wektor wartości wielomianu (vpa)
    n = length(coefficients);
    y = vpa(zeros(size(x)));  % inicjalizacja wyniku jako vpa
    for i = 1:n
        y = y .* x + coefficients(i);  % schemat Hornera
    end
end

function V = get_vandermonde_matrix(x)
    % Buduje macierz Vandermonde’a na podstawie wektora węzłów interpolacji x.
    % Wykonuje obliczeniach w podwójnej precyzji
    n = length(x);
    V = zeros(n);
    for i = 1:n
        V(:, i) = x.^(i-1);
    end
end

function V = get_vandermonde_matrix_vpa(x)
    % Buduje macierz Vandermonde’a na podstawie wektora węzłów interpolacji x.
    % Wykonuje obliczeniach na zmiennych vpa
    n = length(x);
    V = vpa(zeros(n));
    for i = 1:n
        V(:, i) = x.^(i-1);
    end
end