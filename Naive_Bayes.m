clear all
%% Ler o ficheiro CSV

M = readcell("Dados_Jogadores.csv");
size(M);

% Classes
classes = categorical(M(2:end, end))'; 
X = M(2:end, 3:end-1); 
X = cell2mat(X);
