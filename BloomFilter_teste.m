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
%%

teste='192.168.200.30';
r= verificarElemento(teste,BF,k,R)
 
%% TESTES DE PRECISÃO(dados para o relatório)
%% Este código foi feito pelo chatgpt e tem de ser refeito

% testes para falsos positivos
num_tests = 1000; % Número de testes com IPs aleatórios
false_positives = 0;
tested_elements = strings(num_tests, 1);

for i = 1:num_tests
    teste = sprintf('192.168.%d.%d', randi([0, 255]), randi([0, 255]));
    tested_elements(i) = teste;
    if verificarElemento(teste, BF, k, R) && ~any(jogadores == teste)
        false_positives = false_positives + 1;
    end
end


false_positive_rate = false_positives / num_tests;
bf_occupation = sum(BF) / n;

fprintf('Taxa de falsos positivos: %.2f%%\n', false_positive_rate * 100);
fprintf('Ocupação do Bloom Filter: %.2f%%\n', bf_occupation * 100);

