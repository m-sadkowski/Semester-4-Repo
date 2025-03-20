function [rand_counts, counts_mean, circles, a, b, r_max] = generate_circles(n_max)
    a = randi([150, 250]); 
    b = randi([50, 100]);
    r_max = randi([20, 50]);
    circles = zeros(n_max, 3); 
    rand_counts = zeros(1, n_max);
    counts_mean = zeros(1, n_max);

    for i = 1:n_max
        counter = 0
        while true
            counter = counter + 1
            R = rand() * r_max;
            X = rand() * a;
            Y = rand() * b;
            if X - R < 0 || X + R > a || Y - R < 0 || Y + R > b
                continue; 
            end
            
            is_valid = true;
            for j = 1:i-1
                distance = sqrt((X - circles(j, 1))^2 + (Y - circles(j, 2))^2);
                if distance < R + circles(j, 3)
                    is_valid = false;
                    break;
                end
            end
            
            if is_valid
                circles(i, :) = [X, Y, R];
                rand_counts(:, i) = counter;
                counts_mean(i) = mean(rand_counts(1:i));
                break;
            end
        end
    end

    figure;

    subplot(2,1,1);
    plot(1:n_max, rand_counts);
    xlabel('i-ty okrąg');
    ylabel('liczba losowań');
    title('Liczba losowań potrzebnych do wyznaczenia parametrów kolejnych okręgów');

    subplot(2,1,2);
    plot(1:n_max, counts_mean);
    xlabel('i-ty okrąg');
    ylabel('średnia liczba losowań');
    title('Średnia liczba losowań na kolejnych etapach generowania okręgów');
end