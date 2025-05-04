clear all
close all

[node_counts, exact_runge, exact_sine, V, interpolated_runge, interpolated_sine] = plot_runge_sine_interpolations();

print -dpng zadanie1.png;