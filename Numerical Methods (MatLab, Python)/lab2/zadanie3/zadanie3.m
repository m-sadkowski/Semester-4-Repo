clear all
close all
format compact

n_max = 200;

[rand_counts, counts_mean, circles, a, b, r_max] = generate_circles(n_max);

print -dpng zadanie3.png