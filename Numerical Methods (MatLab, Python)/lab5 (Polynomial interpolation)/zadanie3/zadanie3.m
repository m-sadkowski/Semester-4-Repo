clear all
close all

% warning('off','MATLAB:nearlySingularMatrix')

[matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = ill_conditioning_effects();

print -dpng zadanie3.png;