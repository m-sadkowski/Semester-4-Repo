function [index_number, Edges, I, B, A, b, r] = page_rank()
    index_number = 197776
    last = mod(index_number, 10)
    A_value = 1 + mod(last, 7)
    
    Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7; 4, 6, 4, 3, 5, 5, 6, 7, 6, 5, 6, 4, 4, 7, 6];
    N = 7;
    
    new_edges = []
    for i = 1:N
        if i ~= A_value && ~any(ismember(Edges.', [i, A_value], 'rows'))
            new_edges = [new_edges, [i; A_value]];
        end
    end
    
    for i = 1:N
        if i ~= A_value && ~any(ismember(Edges.', [A_value, i], 'rows'))
            new_edges = [new_edges, [A_value; i]];
        end
    end
    
    Edges = [Edges, new_edges];
    r = zeros(N, 1) / N;
    d = 0.85;
    B = sparse(Edges(2,:), Edges(1,:), 1, N, N);
    I = speye(N);
    L = sum(B).';
    A = spdiags(1./L, 0, N, N)
    b = zeros(N,1) + (1-d)/N;
    M = sparse(I - d*B*A);
    r = M \ b;

    figure;
    bar(r);
    xlabel('węzeł');
    ylabel('wartość PR');
    title('Wartości PageRank dla poszczególnych węzłów');
end