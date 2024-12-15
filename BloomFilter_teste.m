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

teste='192.168.124.246';
r= verificarElemento(teste,BF,k,R)
%{ 
Este código foi feito pelo chatgpt e tem de ser refeito
% Testes para verificar a taxa de falsos positivos
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

% Resultados
false_positive_rate = false_positives / num_tests;
bf_occupation = sum(BF) / n;

fprintf('Taxa de falsos positivos: %.2f%%\n', false_positive_rate * 100);
fprintf('Ocupação do Bloom Filter: %.2f%%\n', bf_occupation * 100);

% Visualização do Bloom Filter
rows = 10; % Número de linhas para organizar o vetor em forma de matriz
cols = ceil(n / rows);
BF_matrix = reshape([BF, zeros(1, rows * cols - n)], rows, cols);

figure;
imagesc(BF_matrix); % Exibe o Bloom Filter como imagem
colormap([1 1 1; 0 0 1]); % Branco para 0, Azul para 1
colorbar('Ticks', [0, 1], 'TickLabels', {'0', '1'});
title('Visualização do Bloom Filter');
xlabel('Colunas');
ylabel('Linhas');
axis equal tight;
grid on;
%}