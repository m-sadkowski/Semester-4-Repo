clear all
close all
format compact

[ft_5, yrmax, Nt, xr, yr, integration_error] = monte_carlo_accuracy_evaluation();

print -dpng zadanie4.png;