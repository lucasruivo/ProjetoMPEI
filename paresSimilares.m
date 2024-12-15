function SimilarUsers = paresSimilares(J,Nb,Nj,InvBots,inventario,threshold)

% Determina pares com distância inferior a um limiar
%threshold = 0.35; % Limiar de decisão

SimilarUsers = [];
for b = 1:Nb
    for j = 1:Nj
        if J(b, j) < threshold
            SimilarUsers = [SimilarUsers; InvBots{b}, inventario, J(b, j)];
        end
    end
end


end