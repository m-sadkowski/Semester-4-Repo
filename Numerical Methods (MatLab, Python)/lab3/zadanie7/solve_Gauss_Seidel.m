function [x, r_norm] = solve_Gauss_Seidel(A, b)
    
D = diag(diag(A));
L = tril(A, -1);
U = triu(A, 1);
T = A - U;
    
x = zeros(length(b), 1);
w = T \ b;
inorm = norm(A * x - b);
r_norm = inorm;
iteration_count = 0;
    
while ((inorm > 1e-12 || iteration_count < 500) && iteration_count < 1000)
    iteration_count = iteration_count + 1;
    x = - (T \ (U * x)) + w;
    inorm = norm(A * x - b);
    r_norm = [r_norm, inorm];
end

end