function [circle_areas, circles, a, b, r_max] = generate_circles(n_max)
    a = randi([150, 250]); 
    b = randi([50, 100]);
    rect_area = a * b;
    r_max = randi([20, 50]);
    circles = zeros(n_max, 3); 
    areas = zeros(n_max, 1);
    
    for i = 1:n_max
        while true
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
                areas(i) = pi * R^2;
                break;
            end
        end
    end

    circle_areas = cumsum(areas) / rect_area * 100;

    figure;
    plot(1:n_max, circle_areas);
    xlabel('Liczba kół');
    ylabel('Skumulowane pole kół / pole prostokąta [%]');
    title('Skumulowany stosunek sumy pól kół do pola prostokąta');
end