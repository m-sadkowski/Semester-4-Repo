clear all
close all
format compact

n_max = 200;

[circle_areas, circles, a, b, r_max] = generate_circles(n_max);

print -dpng zadanie2.png