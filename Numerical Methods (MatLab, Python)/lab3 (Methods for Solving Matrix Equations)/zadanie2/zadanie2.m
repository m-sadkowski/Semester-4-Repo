clear all
close all
format compact

vN = 100:100:800;

[A,b,x,vec_time_direct] = benchmark_solve_direct(vN);

print -dpng zadanie2.png