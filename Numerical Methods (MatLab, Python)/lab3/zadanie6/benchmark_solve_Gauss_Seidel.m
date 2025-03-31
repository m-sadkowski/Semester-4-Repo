function [A,b,x,vec_loop_times,vec_iteration_count] = benchmark_solve_Gauss_Seidel(vN)
% Pomiar wydajności metody Gaussa-Seidla dla length(vN) równań macierzowych,
% przy czym liczba zmiennych i-tego równania wynosi vN(i).
% A - tablica komórkowa zawierająca zestaw macierzy A do równania macierzowego
%       A{i}*x{i}=b{i}, gdzie size(A{i},1) = vN(i)
% b - tablica komórkowa prawych stron równań A{i}*x{i}=b{i}
% x - tablica komórkowa z rozwiązaniami równań A{i}*x{i}=b{i}
% vec_loop_times(i) - czas wyznaczenia i-tego rozwiązania metodą Gaussa-Seidla
% vec_iterations_count(i) - liczba iteracji wykonana przy wyznaczeniu
%       i-tego rozwiązania metodą Gaussa-Seidla


vec_loop_times = zeros(1,length(vN));
vec_iteration_count = zeros(1,length(vN));

for i=1:length(vN)
    N = vN(i);
    [A{i},b{i}] = generate_matrix(N);

    D = diag(diag(A{i}));
    L = tril(A{i}, -1);
    U = triu(A{i}, 1);
    T = A{i} - U;
    w = T \ b{i};

    x{i} = ones(N,1);
    iteration_count = 0;
    inorm = 1e22;

    tic
    while(inorm > 1e-12 && iteration_count<1000)
        x{i} = - (T \ (U * x{i})) + w;
        inorm = norm(A{i} * x{i} - b{i});
        iteration_count = iteration_count + 1;
    end
    vec_loop_times(i) = toc;
    vec_iteration_count(i) = iteration_count;
end

figure;

subplot(2, 1, 1);
plot(vN, vec_loop_times, '-o');
title('Czas obliczeń w zależności od rozmiaru macierzy A');
xlabel('Rozmiar macierzy A (N)');
ylabel('Czas obliczeń (s)');
    
subplot(2, 1, 2);
plot(vN, vec_iteration_count, '-o');
title('Liczba iteracji w zależności od rozmiaru macierzy A');
xlabel('Rozmiar macierzy A (N)');
ylabel('Liczba iteracji');

end