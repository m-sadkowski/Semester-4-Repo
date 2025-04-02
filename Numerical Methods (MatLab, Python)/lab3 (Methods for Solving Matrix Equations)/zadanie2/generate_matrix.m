function [A,b] = generate_matrix(N)
    % A - macierz o rozmiarze NxN
    % b - wektor o rozmiarze Nx1
    % convergense_factor - regulacja elementów diagonalnych macierzy A, które
    %       wpływają na zbieżność algorytmów iteracyjnego rozwiązywania
    %       równania macierzowego
    convergence_factor = 5;

    if(convergence_factor<0 || convergence_factor>9)
        error('Wartość convergence_factor powinna być zawarta w przedziale [1,9]');
    end

    seed = 0; % seed - kontrola losowości elementów niezerowych macierzy A
    rng(seed); % ustawienie generatora liczb losowych

    A = rand(N, N);
    A = A - diag(diag(A)); % wyzerowanie głównej diagonalnej

    convergence_factor_2 = 1.2 + convergence_factor/10;
    diag_values = sum(abs(A),2) * convergence_factor_2;
    A = A + diag(diag_values); % nadanie nowych wartości na głównej diagonalnej

    % regulacja normy macierzy
    norm_Frobenius = norm(A,'fro');
    A = A/norm_Frobenius;

    b = rand(N,1);
end

