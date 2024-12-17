clear;
ficheiro = 'InventariosBots.txt';
ksh=3;
[Set,Nb,InvBots] = criar_sets(ficheiro,ksh);
k=200;

p = 123456781;

while ~isprime(p)
    p=p+2;
end
R = randi(p,k,ksh);
MA= Calcular_Assinaturas_Inv(Set,Nb,k,R,p);

%% TESTE

test = {'GranadaInc', 'Pistola', 'Metralhadora', 'Colete'};


%fazer shingles
[Set2] = criar_sets_um_inv(test,ksh);

%calcular assinaturas
MA2 = Calcular_Assinaturas_Inv(Set2,1,k,R,p);
%calcular distancias

J = distanciasMinHash(MA,MA2,Nb,1,k);

%%
threshold = 0.35;
SimilarUsers = paresSimilares(J,Nb,1,InvBots,test,threshold);
disp(SimilarUsers);