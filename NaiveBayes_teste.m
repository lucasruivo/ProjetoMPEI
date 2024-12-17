clear all
%% Ler o ficheiro CSV

M = readcell("Dados_Jogadores.txt");
size(M);

classes = categorical(M(2:end, end))'; 
X = M(2:end, 3:end-1); 
dados = cell2mat(X);

continuousFeatures = [1 2 3 4];
binaryFeatures = [5, 6]; 
Ncf = length(continuousFeatures);
Nbf = length(binaryFeatures);

%% Dividir TREINO/TESTE 80/20
percentTreino = 0.8;
numTreino = round(percentTreino * size(dados, 1));
indices = randperm(size(dados, 1));

indicesTreino = indices(1:numTreino);
indicesTeste = indices(numTreino + 1:end);

TREINO = dados(indicesTreino, :);
TESTE = dados(indicesTeste, :);
classes_treino = classes(indicesTreino);
classes_teste = classes(indicesTeste);


%% Calcular probabilidades

numLeg = sum(classes_treino == 'Legítimo');
numSus = sum(classes_treino == 'Suspeito');
pLeg = numLeg / length(classes_treino);
pSus = numSus / length(classes_treino);

%% Calcular probabilidades condicionais para o Classificador Naïve Bayes

numFeatures = size(TREINO, 2);

% para dados binários
pFeatureGivenLeg = zeros(1, Nbf);
pFeatureGivenSus = zeros(1, Nbf);

for i = 1:Nbf
    indiceBinary = binaryFeatures(i);
    pFeatureGivenLeg(i) = sum(TREINO(classes_treino == 'Legítimo', indiceBinary)) / numLeg;
    pFeatureGivenSus(i) = sum(TREINO(classes_treino == 'Suspeito', indiceBinary)) / numSus;
end

%para dados contínuos
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

%% e) Classificar os dados de teste
Y_pred = categorical(repmat({'Legítimo'}, size(classes_teste))); % Inicializar como 'Legítimo'

%para dados binários
for j = 1:size(TESTE,1)
    pinicialLeg = pLeg;
    pinicialSus = pSus;

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

% para dados contínuos
    for k = 1:length(continuousFeatures)
        indiceContinuous = continuousFeatures(k);
        valor = TESTE(j, indiceContinuous);

        % densidade gaussiana
        pGaussianaLeg = (1 / (sqrt(2 * pi) * desvioLeg(k))) * exp(-0.5 * ((valor - mediaLeg(k)) / desvioLeg(k))^2);
        pGaussianaSus = (1 / (sqrt(2 * pi) * desvioSus(k))) * exp(-0.5 * ((valor - mediaSus(k)) / desvioSus(k))^2);
        pinicialLeg = pinicialLeg * pGaussianaLeg;
        pinicialSus = pinicialSus * pGaussianaSus;
    end

    % Decidir a classe com base nas probabilidades
    if pinicialLeg > pinicialSus
        Y_pred(j) = 'Legítimo';
    else
        Y_pred(j) = 'Suspeito';
    end
end

%% TESTES DE PRECISÃO, RECALL E F1-SCORE(dados para o relatório)

Matriz_conf = confusionmat(classes_teste, Y_pred);

TP = Matriz_conf(2, 2); 
FP = Matriz_conf(1, 2); 
FN = Matriz_conf(2, 1); 
TN = Matriz_conf(1, 1); 

precisao = TP / (TP + FP) * 100;
recall = TP / (TP + FN) * 100;
f1_score = 2 * precisao * recall / (precisao + recall);

fprintf('Precisão: %.2f%%\n', precisao);
fprintf('Recall: %.2f%%\n', recall);
fprintf('F1-Score: %.2f%%\n', f1_score);

confusionchart(classes_teste, Y_pred);