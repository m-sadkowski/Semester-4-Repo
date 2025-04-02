function [A,b,U,T,w,x,r_norm,iteration_count] = solve_Gauss_Seidel()
% A - macierz z równania macierzowego A * x = b
% b - wektor prawej strony równania macierzowego A * x = b
% U - macierz trójkątna górna, która zawiera wszystkie elementy macierzy A powyżej głównej diagonalnej,
% T - macierz trójkątna dolna równa A-U
% w - wektor pomocniczy opisany w instrukcji do Laboratorium 3
%       – sprawdź wzór (7) w instrukcji, który definiuje w jako w_{GS}.
% x - rozwiązanie równania macierzowego
% r_norm - wektor norm residuum kolejnych przybliżeń rozwiązania; norm(A*x-b);
% iteration_count - liczba iteracji wymagana do wyznaczenia rozwiązania
%       metodą Gaussa-Seidla

N = randi([5000, 8000]);
[A, b] = generate_matrix(N);
    
D = diag(diag(A));
L = tril(A, -1);
U = triu(A, 1);
T = A - U;
    
x = ones(N, 1);
w = T \ b;
inorm = norm(A*x - b);
r_norm = inorm;
iteration_count = 0;
    
while r_norm(end) > 1e-12 && iteration_count < 1000
    iteration_count = iteration_count + 1;
    x = - (T \ (U * x)) + w;
    inorm = norm(A*x - b);
    r_norm = [r_norm, inorm];
end
    
figure;
semilogy(0:iteration_count, r_norm, '-o', 'LineWidth', 1);
xlabel('Liczba iteracji');
ylabel('Norma residuum (skala logarytmiczna)');
title('Zbieżność metody Gaussa-Seidla');

end