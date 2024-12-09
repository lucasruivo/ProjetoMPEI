function SimilarUsers = paresSimilares(J,Nj,jogadores,threshold)

% Determina pares com distância inferior a um limiar
%threshold = 0.4; % Limiar de decisão
% Array para guardar pares similares (utilizador1, utilizador2, distância)
SimilarUsers = [];
for n1 = 1:Nj
    for n2 = n1 + 1:Nj
        if J(n1, n2) < threshold
            SimilarUsers = [SimilarUsers; jogadores{n1,1}, jogadores{n2,1}, J(n1, n2)];
        end
    end
end

% Exibe os pares de utilizadores similares
disp('Pares de utilizadores similares:');
disp(SimilarUsers);

end