clear;
ficheiro = 'InventariosBots.txt';
ksh=3;
[Set,Nb,InvBots] = criar_sets(ficheiro,ksh);

%% TESTE
k=[50,100,200,500,1000];

test = {{'Sniper', 'Explosivo', 'Lança-granadas', 'GranadaFumo'}, %Exatamente igual a um Bot
        {'GranadaInc', 'Metralhadora', 'Silenciador', 'MedKit'},  %Items trocados de ordem 
        {'Metralhadora', 'Pistola', 'GranadaFumo','GranadaInc'}, %Desordenados e um item semelhante
        {'GranadaFumo', 'GranadaInc', 'GranadaGas', 'GranadaFrag'}}; %Items completamente diferentes
for nk = 1:length(k)
    fprintf('Teste para %d funções de hash-----------------------------------------------------------------------------------\n',k(nk));
    p = 123456781;
    while ~isprime(p)
        p=p+2;
    end
    R = randi(p,k(nk),ksh);
    MA= Calcular_Assinaturas_Inv(Set,Nb,k(nk),R,p);
    
    for n=1:length(test)
        %fazer shingles
        [Set2] = criar_sets_um_inv(test{n,1},ksh);
        
        %calcular assinaturas
        MA2 = Calcular_Assinaturas_Inv(Set2,1,k(nk),R,p);
        %calcular distancias
        
        J = distanciasMinHash(MA,MA2,Nb,1,k(nk));
        
        %%
        threshold = 0.35;
        SimilarUsers = paresSimilares(J,Nb,1,InvBots,test{n,1},threshold);
        if ~isempty(SimilarUsers)
                nbots = length(SimilarUsers(:,1));
                distancias = cell2mat(SimilarUsers(:, 9)); 
                dist = min(distancias);
                indiceBot = find(distancias == dist, 1);
                fprintf('%d inventários similares encontrados:\n',nbots);
                fprintf('  Inventário do Jogador: %s || %s || %s || %s\n', SimilarUsers{indiceBot, 5:8});
                fprintf('  Inventário do Bot mais próximo: %s || %s || %s || %s\n', SimilarUsers{indiceBot, 1:4});
                fprintf('  Distância mais próxima: %.3f\n', dist);
        else
            fprintf('Nenhum inventário similar encontrado.\n');
        end
    end
end