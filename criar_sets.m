function [Set,Nj,jogadores] = criar_sets(ficheiro)

% Código base para deteção de pares similares
data = readtable(ficheiro); % Carrega o ficheiro dos dados dos jogadores
% Mantém apenas as duas primeiras colunas (jogador, inventário)
d = data(:, 1:2); 

% Lista de jogadores
jogadores = d(:, 1); % Extrai os IPs dos jogadores
Nj = height(jogadores); % Número total de jogadores

% Constrói a lista de itens de cada jogador
Set = cell(Nj, 1); % Usa células para armazenar os conjuntos de items
for n = 1:Nj
    Set{n} = strsplit(d.Inventario{n}, ', ');
end

end