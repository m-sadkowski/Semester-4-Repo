clear all
close all
format compact

[A,b,L,U,P,y,x,r_norm,t_factorization,t_substitution,t_direct] = solve_direct();

print -dpng zadanie1.png;