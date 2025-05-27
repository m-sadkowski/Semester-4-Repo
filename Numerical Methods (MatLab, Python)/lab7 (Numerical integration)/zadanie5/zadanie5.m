clear all
close all
format long g

[x, y, z, zmin, lake_volume] = compute_lake_volume_monte_carlo();

fprintf('Objetosc jeziora: %6.0f\n', lake_volume);