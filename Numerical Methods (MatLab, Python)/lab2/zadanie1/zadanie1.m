clear all
close all
format compact

% Maksymalna liczba okręgów
n_max = 200;

% Wywołanie funkcji losującej okręgi
[circles, a, b, r_max] = generate_circles(n_max);

% Wywołanie funkcji rysującej
plot_circles(a, b, circles);

% Zapisanie wykresu do pliku PNG (na potrzeby sprawozdania):
print -dpng zadanie1.png