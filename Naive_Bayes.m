clear all
%% Ler o ficheiro CSV

M = readcell("Dados_Jogadores.csv");
size(M);

% Classes
classes = categorical(M(2:end, end))'; 
X = M(2:end, 3:end-1); 
TREINO = cell2mat(X);

%% Calcular probabilidades

numLeg = sum(classes == 'Legítimo');
numSus = sum(classes == 'Suspeito');
pLeg = numLeg / length(classes)
pSus = numSus / length(classes)

%%

