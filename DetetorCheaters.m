clear;
ficheiro_inventarios = 'InventariosBots.txt';
ficheiro_dados = 'Dados_Jogadores.txt';

%% BLOOM FILTER
fprintf('--- Iniciando Bloom Filter ---\n');
n = 40000;
kb = 7;

M = readcell(ficheiro_dados);

jogadores = string(M(2:end, 1));
classes = string(M(2:end, 9));

BF = zeros(1, n, 'uint8');

R.a = randi(123457, 1, kb);
R.b = randi(123457, 1, kb);
R.p = 123453;
while ~isprime(R.p)
    R.p = R.p + 2;
end

for nj = 1:length(jogadores)
    j = jogadores(nj);
    if classes(nj) == 'Suspeito'
        BF = adicionarElemento(j, BF, kb, R);
    end
end
fprintf('Bloom Filter inicializado com %d bits.\n', n);

%% MINHASH
fprintf('\n--- Iniciando MinHash ---\n');
ksh = 3;
[Set, Nb, InvBots] = criar_sets(ficheiro_inventarios, ksh);
km = 500;

p = 123456781;

while ~isprime(p)
    p = p + 2;
end
Rm = randi(p, km, ksh);
MA = Calcular_Assinaturas_Inv(Set, Nb, km, Rm, p);
fprintf('MinHash calculado com %d funções de hash.\n', km);

%% INPUT DE DADOS E VERIFICAÇÃO BLOOMFILTER/MINHASH
fprintf('\n--- Verificação de Jogadores ---\n');
NovosJogadores = {};
NJogadores = input('Quantos jogadores quer verificar? ');

for i = 1:NJogadores
    fprintf('\n*** Verificação para Jogador %d ***\n', i);
    ip = input('IP: ', 's');

    JaFoiSuspeito = verificarElemento(ip, BF, kb, R);
    if JaFoiSuspeito == 1
        fprintf('ALERTA: O Jogador %d (%s) já foi suspeito!\n', i, ip);
    end

    inventario = strsplit(input('\nInventário (ex: GranadaInc Pistola Metralhadora Colete): ', 's'), ' ');

    % Fazer shingles
    [Set2] = criar_sets_um_inv(inventario, ksh);
    
    % Calcular assinaturas
    MA2 = Calcular_Assinaturas_Inv(Set2, 1, km, Rm, p);
    
    % Calcular distâncias
    J = distanciasMinHash(MA, MA2, Nb, 1, km);
    
    threshold = 0.35;
    SimilarUsers = paresSimilares(J, Nb, 1, InvBots, inventario, threshold);
    if ~isempty(SimilarUsers)
        susInv = 1;
        distancias = cell2mat(SimilarUsers(:, 9)); 
        dist = min(distancias);
        indiceBot = find(distancias == dist, 1);
        fprintf('Inventário similar encontrado para Jogador %d:\n', i);
        fprintf('  Inventário do Jogador: %s || %s || %s || %s\n', SimilarUsers{indiceBot, 5:8});
        fprintf('  Inventário do Bot mais próximo: %s || %s || %s || %s\n', SimilarUsers{indiceBot, 1:4});
        fprintf('  Distância: %.3f\n', dist);
    else
        susInv = 0;
    end
    
    precisao = input('\nPrecisão: ');
    tempoReacao = input('\nTempo de Reação: ');
    apm = input('\nAPM (ações por minuto): ');
    taxaHeadshots = input('\nTaxa de Headshots: ');

    NovosJogadores = [NovosJogadores; {ip, inventario, precisao, tempoReacao, apm, taxaHeadshots, double(JaFoiSuspeito), susInv}];
end

%% CLASSIFICAÇÃO USANDO NAIVE BAYES
fprintf('\n--- Classificação com Naive Bayes ---\n');

classes = categorical(M(2:end, end))'; 
X = M(2:end, 3:end-1); 
dados = cell2mat(X);

continuousFeatures = [1 2 3 4];
binaryFeatures = [5, 6]; 
Ncf = length(continuousFeatures);
Nbf = length(binaryFeatures);

classes_treino = categorical(M(2:end, end))'; 
TREINO = cell2mat(M(2:end, 3:end-1));
Dados = NovosJogadores(:, 3:end);
TESTE = cell2mat(Dados);

% Cálculo das probabilidades
numLeg = sum(classes_treino == 'Legítimo');
numSus = sum(classes_treino == 'Suspeito');
pLeg = numLeg / length(classes_treino);
pSus = numSus / length(classes_treino);

% Condicionais para dados binários
pFeatureGivenLeg = zeros(1, Nbf);
pFeatureGivenSus = zeros(1, Nbf);
for i = 1:Nbf
    indiceBinary = binaryFeatures(i);
    pFeatureGivenLeg(i) = sum(TREINO(classes_treino == 'Legítimo', indiceBinary)) / numLeg;
    pFeatureGivenSus(i) = sum(TREINO(classes_treino == 'Suspeito', indiceBinary)) / numSus;
end

% Condicionais para dados contínuos
mediaLeg = zeros(1, Ncf);
mediaSus = zeros(1, Ncf);
desvioLeg = zeros(1, Ncf);
desvioSus = zeros(1, Ncf);

for i = 1:Ncf
    indiceContinuous = continuousFeatures(i);
    mediaLeg(i) = mean(TREINO(classes_treino == 'Legítimo', indiceContinuous));
    mediaSus(i) = mean(TREINO(classes_treino == 'Suspeito', indiceContinuous));
    desvioLeg(i) = std(TREINO(classes_treino == 'Legítimo', indiceContinuous));
    desvioSus(i) = std(TREINO(classes_treino == 'Suspeito', indiceContinuous));
end

% Classificação
Y_pred = categorical(repmat({'Legítimo'}, NJogadores));
for j = 1:size(TESTE, 1)
    pinicialLeg = pLeg;
    pinicialSus = pSus;

    % Dados binários
    for k = 1:Nbf
        indiceBinary = binaryFeatures(k);
        if TESTE(j, indiceBinary) == 1
            pinicialLeg = pinicialLeg * pFeatureGivenLeg(k);
            pinicialSus = pinicialSus * pFeatureGivenSus(k);
        else
            pinicialLeg = pinicialLeg * (1 - pFeatureGivenLeg(k));
            pinicialSus = pinicialSus * (1 - pFeatureGivenSus(k));
        end
    end

    % Dados contínuos
    for k = 1:Ncf
        indiceContinuous = continuousFeatures(k);
        valor = TESTE(j, indiceContinuous);

        % Densidade gaussiana
        pGaussianaLeg = (1 / (sqrt(2 * pi) * desvioLeg(k))) * exp(-0.5 * ((valor - mediaLeg(k)) / desvioLeg(k))^2);
        pGaussianaSus = (1 / (sqrt(2 * pi) * desvioSus(k))) * exp(-0.5 * ((valor - mediaSus(k)) / desvioSus(k))^2);
        pinicialLeg = pinicialLeg * pGaussianaLeg;
        pinicialSus = pinicialSus * pGaussianaSus;
    end

    % Decisão final
    if pinicialLeg > pinicialSus
        Y_pred(j) = 'Legítimo';
    else
        Y_pred(j) = 'Suspeito';
    end
end

% Exibir resultados
for j = 1:NJogadores
    fprintf('\nJogador %d (%s): %s\n', j, NovosJogadores{j, 1}, Y_pred(j));
end
