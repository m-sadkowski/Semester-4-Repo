function [residuum_norm_direct, residuum_norm_Jacobi, residuum_norm_Gauss_Seidel] = filter_solutions()
% residuum_norm_direct - norma residuum dla rozwiązania metodą bezpośrednią
% residuum_norm_Jacobi - norma residuum dla rozwiązania metodą Jacobiego
% residuum_norm_Gauss_Seidel - norma residuum dla rozwiązania metodą Gaussa-Seidele'a
    load results.mat;
    residuum_norm_direct = r_direct;
    residuum_norm_Jacobi = r_jacobi(end); 
    residuum_norm_Gauss_Seidel = r_gs(end);

    fprintf('Metoda bezpośrednia: norma residuum = %e\n', r_direct);
    fprintf('Metoda Jacobiego: norma residuum = %e\n', r_jacobi(end));
    fprintf('Metoda Gauss-Seidla: norma residuum = %e\n', r_gs(end));
end