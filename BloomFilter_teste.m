clear;
n= 40000;
k=7;

ficheiro = 'Dados_Jogadores.txt';
data = readcell(ficheiro,'Delimiter',',');

jogadores= string(data(2:end,1));
classes= string(data(2:end,9));

BF = zeros(1,n,'uint8');

R.a = randi(123457,1,k);
R.b = randi(123457,1,k);
R.p = 123453;
while ~ isprime(R.p)
    R.p = R.p+2;
end

for nj = 1:length(jogadores)
    j = jogadores(nj);
    if classes(nj)=='Suspeito'
        BF = adicionarElemento(j,BF,k,R);
    end
end
 
%% TESTES DE FALSOS POSITIVOS(dados para o relatório)

ntests = 1000;
falsos_positivos = 0;
testados = strings(ntests, 1);

for i = 1:ntests
    teste = sprintf('192.168.%d.%d', randi([0, 255]), randi([0, 255]));
    testados(i) = teste;
    if verificarElemento(teste, BF, k, R) && ~any(jogadores == teste)
        falsos_positivos = falsos_positivos + 1;
    end
end


percentFalsosPositivos = falsos_positivos / ntests * 100;
OcupacaoBF = sum(BF) / n * 100;

fprintf('Taxa de falsos positivos: %.2f%%\n', percentFalsosPositivos);
fprintf('Ocupação do Bloom Filter: %.2f%%\n', OcupacaoBF);








%% VER O ~ANY(ISTO), FAZER AS VERIFICAÇÕES