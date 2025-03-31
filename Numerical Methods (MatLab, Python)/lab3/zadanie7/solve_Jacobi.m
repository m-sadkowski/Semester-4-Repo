function [x, r_norm] = solve_Jacobi(A, b)

L = tril(A, -1);
U = triu(A, 1);
D = diag(diag(A));

iteration_count = 0;
M = -(D \ (L + U));
w = D \ b;
x = zeros(length(b),1);
inorm = norm(A * x - b);
r_norm = inorm;

while((inorm > 1e-12 || iteration_count < 500) && iteration_count < 1000)
    x = M * x + w;
    inorm = norm(A * x - b);
    iteration_count = iteration_count + 1;
    r_norm = [ r_norm, inorm ];
end

end