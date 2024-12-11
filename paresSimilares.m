function SimilarUsers = paresSimilares(J,Nb,Nj,InvBots,inventario,threshold)

% Determina pares com distância inferior a um limiar
%threshold = 0.3; % Limiar de decisão
% Array para guardar pares similares (utilizador1, utilizador2, distância)
SimilarUsers = [];
for b = 1:Nb
    for j = 1:Nj
        if J(b, j) < threshold
            SimilarUsers = [SimilarUsers; InvBots{b}, inventario, J(b, j)];
        end
    end
end

% Exibe os pares de utilizadores similares
disp('Pares de utilizadores similares:');
disp(SimilarUsers);

end