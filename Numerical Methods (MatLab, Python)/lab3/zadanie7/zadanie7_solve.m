clear all
close all
format compact

load filtr_dielektryczny.mat;

[x_direct, r_direct] = solve_direct(A, b);
[x_jacobi, r_jacobi] = solve_Jacobi(A, b);
[x_gs, r_gs] = solve_Gauss_Seidel(A, b);

save('results.mat', 'r_direct', 'r_jacobi', 'r_gs');