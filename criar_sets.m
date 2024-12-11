function [Set,Nb,InvBots] = criar_sets(ficheiro,ksh)
% Código base para deteção de pares similares

InvBots_Raw = readcell(ficheiro,'Delimiter',', ');

Nb = length(InvBots_Raw); 
InvBots = cell(Nb, 1);
Set = cell(Nb, 1); 

for n = 1:Nb
    InvBots{n} = InvBots_Raw(n, :);
    inventario = strjoin(InvBots_Raw(n, :), '');
    
% Criar shingles a partir da string combinada
    nsh = strlength(inventario) - ksh + 1;
    shingles = cell(1, nsh);
    for sh = 1:nsh
        shingles{sh} = inventario(sh:sh + ksh - 1);
    end
    Set{n} = shingles;
end
end