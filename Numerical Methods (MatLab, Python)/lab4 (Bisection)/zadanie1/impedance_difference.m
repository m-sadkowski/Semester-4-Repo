function impedance_delta = impedance_difference(f)
% Wyznacza moduł impedancji równoległego obwodu rezonansowego RLC pomniejszoną o wartość M.
% f - częstotliwość


R = 525; % Ω
C = 7 * 10^(-5); % F
L = 3; % H
M = 75; % Ω

if f <= 0
    error("f mniejsze od 0");
end

Z = 1/sqrt(1/R^2+(2*pi*f*C-1/(2*pi*f*L))^2);

impedance_delta = Z - M;

end