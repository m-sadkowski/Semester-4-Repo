clear all
close all

[matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = vpa_ill_conditioning_demo();

print -dpng zadanie4.png;