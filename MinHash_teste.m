clear;
ficheiro = 'Dados_Jogadores.csv';
[Set,Nj,jogadores] = criar_sets(ficheiro);
k=200;
%%
R.a = randi(123457,1,k);
R.b = randi(123457,1,k);
R.p = 123453;
while ~ isprime(R.p)
    R.p = R.p+2;
end

J = distanciasMinHash(Set,Nj,k,R);

%%
threshold = 0.01;
SimilarUsers = paresSimilares(J,Nj,jogadores,threshold);

