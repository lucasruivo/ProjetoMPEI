clear;
ficheiro = 'InventariosBots.txt';
ksh=3;
[Set,Nb,InvBots] = criar_sets(ficheiro,ksh);
k=500;

p = 123456781;

while ~isprime(p)
    p=p+2;
end
R = randi(p,k,ksh);
MA= Calcular_Assinaturas_Inv(Set,Nb,k,R,p);

%% TESTE

test = {{'Sniper', 'Explosivo', 'Lança-granadas', 'GranadaFumo'}, %Exatamente igual a um Bot
        {'GranadaInc', 'Metralhadora', 'Silenciador', 'MedKit'},  %Items trocados de ordem 
        {'Metralhadora', 'Pistola', 'GranadaFumo','GranadaInc'}, %Desordenados e um item semelhante
        {'Cadeira', 'Bolacha', 'Carro', 'Meia'}}; %Items completamente diferentes

for n=1:length(test)
    %fazer shingles
    [Set2] = criar_sets_um_inv(test{n,1},ksh);
    
    %calcular assinaturas
    MA2 = Calcular_Assinaturas_Inv(Set2,1,k,R,p);
    %calcular distancias
    
    J = distanciasMinHash(MA,MA2,Nb,1,k);
    
    %%
    threshold = 0.35;
    SimilarUsers = paresSimilares(J,Nb,1,InvBots,test{n,1},threshold);
    if ~isempty(SimilarUsers)
            distancias = cell2mat(SimilarUsers(:, 9)); 
            dist = min(distancias);
            indiceBot = find(distancias == dist, 1);
            fprintf('Inventário similar encontrado:\n');
            fprintf('  Inventário do Jogador: %s || %s || %s || %s\n', SimilarUsers{indiceBot, 5:8});
            fprintf('  Inventário do Bot mais próximo: %s || %s || %s || %s\n', SimilarUsers{indiceBot, 1:4});
            fprintf('  Distância: %.3f\n', dist);
    else
        fprintf('Nenhum inventário similar encontrado.\n');
    end
end