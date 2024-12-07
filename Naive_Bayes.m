clear all
%% Ler o ficheiro CSV

M = readcell("dados_jogadores.csv");
size(M);

% Classes
classes = categorical(M(2:end, end))'; 
X = M(2:end, 2:end-1); 
X = cell2mat(X); 

%% b) Dividir em treino e teste

permutacao = randperm(size(X, 1));
X2 = X(permutacao, :); 
classes2 = classes(permutacao);

n1 = round(0.7 * size(X, 1));
TREINO = X2(1:n1, :);
classes_treino = classes2(1:n1);

TESTE = X2(n1+1:end, :);
classes_teste = classes2(n1+1:end);

%% c) Calcular probabilidades
numSpam = sum(classes_treino == 'SPAM');
numOk = sum(classes_treino == 'OK');
pSpam = numSpam / n1
pOk = numOk / n1

%% d) Calcular probabilidades condicionais para o Classificador Naïve Bayes

numFeatures = size(TREINO, 2);
pFeatureGivenSpam = zeros(1, numFeatures);
pFeatureGivenOk = zeros(1, numFeatures);
for i = 1:numFeatures
    pFeatureGivenSpam(i) = sum(TREINO(classes_treino == 'SPAM', i)) / numSpam;
    pFeatureGivenOk(i) = sum(TREINO(classes_treino == 'OK', i)) / numOk;
end

%% e) Classificar os dados de teste
Y_pred = categorical(repmat({'OK'}, size(classes_teste))); % Inicializar como 'OK'

for j = 1:length(classes_teste)
    pSpamEmail = pSpam;
    pOkEmail = pOk;
    for k = 1:numFeatures
        if TESTE(j, k) == 1
            pSpamEmail = pSpamEmail * pFeatureGivenSpam(k);
            pOkEmail = pOkEmail * pFeatureGivenOk(k);
        else
            pSpamEmail = pSpamEmail * (1 - pFeatureGivenSpam(k));
            pOkEmail = pOkEmail * (1 - pFeatureGivenOk(k));
        end
    end
    % Decidir a classe com base nas probabilidades
    if pSpamEmail > pOkEmail
        Y_pred(j) = 'SPAM';
    else
        Y_pred(j) = 'OK';
    end
end
Y_pred