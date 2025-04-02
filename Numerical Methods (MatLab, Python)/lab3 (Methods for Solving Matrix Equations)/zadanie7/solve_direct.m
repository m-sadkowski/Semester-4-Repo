function [x, r_norm] = solve_direct(A, b)

x = A \ b;
r_norm = norm(A * x - b);

end