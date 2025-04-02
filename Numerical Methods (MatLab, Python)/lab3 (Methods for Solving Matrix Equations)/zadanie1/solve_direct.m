function [A, b, L, U, P, y, x, r_norm, t_factorization, t_substitution, t_direct] = solve_direct()
    N = randi([5000, 9000]);
    [A, b] = generate_matrix(N);
    
    tic;
    [L, U, P] = lu(A);
    t_factorization = toc;
    
    tic;
    y = L \ (P * b);
    x = U \ y;
    t_substitution = toc;
    
    t_direct = t_factorization + t_substitution;

    r_norm = norm(A * x - b);
    r = [t_direct, t_factorization, t_substitution];

    figure;
    bar(r);
    set(gca, 'XTickLabel', {'t_{direct}', 't_{factorization}', 't_{substitution}'});
    ylabel('Czas (s)');
    title('Czas obliczeń metodą LU');
end
