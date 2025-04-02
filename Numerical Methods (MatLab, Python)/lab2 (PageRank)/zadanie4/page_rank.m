function [Edges, I, B, A, b, r] = page_rank()
    Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7; 4, 6, 4, 3, 5, 5, 6, 7, 6, 5, 6, 4, 4, 7, 6];
    N = 7; 
    r = zeros(N, 1) / N;
    d = 0.85;
    B = sparse(Edges(2,:), Edges(1,:), 1, N, N); 
    L = sum(B).'; 
    I = speye(N);
    A = spdiags(1./L, 0, N, N);
    b = zeros(N,1) + (1-d)/N;
    M = sparse(I - d*B*A);
    r = M \ b; 
    
    figure;
    bar(r);
    xlabel('węzeł sieci');
    ylabel('wartość PR');
    title('Wartość PR dla każdej strony internetowej w sieci');
end