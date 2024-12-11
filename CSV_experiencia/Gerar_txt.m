% Configuração do número de jogadores
numJogadores = 10000;

% Limites das métricas
accuracy_limit = 80;
reaction_limit = 200;
apm_low = 40;
apm_high = 100;
headshot_limit = 70; % Limite para taxa de headshots considerada estranha (%)

% Pesos das métricas
pesos = struct(...
    'JaFoiSuspeito', 2.0, ...
    'Acuracia', 1.5, ...
    'TempoReacao', 1.5, ...
    'APM', 1.0, ...
    'TaxaHeadshots', 1.5, ...
    'AcoesBots', 1.5);

% Gerar dados contínuos
rng('shuffle'); % Para reprodutibilidade variável
IPs = arrayfun(@(x) sprintf('192.168.%d.%d', randi(255), randi(255)), 1:numJogadores, 'UniformOutput', false);
Acuracia = randi([40, 100], numJogadores, 1);
TempoReacao = randi([50, 400], numJogadores, 1);
APM = randi([20, 150], numJogadores, 1);
TaxaHeadshots = randi([0, 100], numJogadores, 1);

% Gerar lista de IPs reportados (5% dos jogadores)
percent_reportados = 0.05;
numReportados = floor(numJogadores * percent_reportados);
IPsReportados = IPs(randperm(numJogadores, numReportados));

% Verificar se cada IP já foi reportado diretamente na lista
JaFoiSuspeito = false(numJogadores, 1);
for i = 1:numJogadores
    JaFoiSuspeito(i) = ismember(IPs{i}, IPsReportados);
end

% Gerar inventário aleatório para cada jogador
itens_inventario = { ...
    'Pistola', 'Revólver', 'Fuzil', 'Espingarda', 'Sniper', ...
    'GranadaFrag', 'Submetralhadora', 'Metralhadora', 'Faca', 'Silenciador', ...
    'Mira', 'Drone', 'Explosivo', 'Torreta', 'Capacete', ...
    'Colete', 'GranadaInc', 'MedKit', 'Lança-granadas', 'GranadaFumo' ...
};
Inventarios = cell(numJogadores, 1);
for i = 1:numJogadores
    itens = itens_inventario(randperm(length(itens_inventario), 4));
    Inventarios{i} = strjoin(itens, ', ');
end

% Gerar valores aleatórios para SusInv
SusInv = randi([0, 1], numJogadores, 1);

% Criar tabela inicial
Tabela = table(IPs', Inventarios, Acuracia, TempoReacao, APM, TaxaHeadshots, ...
    JaFoiSuspeito, SusInv, 'VariableNames', {'IP', 'Inventario', 'Precisao', 'TempoReacao', ...
                                     'APM', 'TaxaHeadshots', 'JaFoiSuspeito', 'SusInv'});

% Calcular a classe com base nas colunas ajustadas
Classes = strings(numJogadores, 1);
for i = 1:numJogadores
    score = 0;
    score = score + pesos.JaFoiSuspeito * Tabela.JaFoiSuspeito(i);
    score = score + pesos.Acuracia * (Tabela.Precisao(i) > accuracy_limit);
    score = score + pesos.TempoReacao * (Tabela.TempoReacao(i) < reaction_limit);
    score = score + pesos.APM * ((Tabela.APM(i) < apm_low) + (Tabela.APM(i) > apm_high));
    score = score + pesos.TaxaHeadshots * (Tabela.TaxaHeadshots(i) > headshot_limit);
    score = score + pesos.AcoesBots * Tabela.SusInv(i);

    if score > 3.5
        Classes(i) = "Suspeito";
    else
        Classes(i) = "Legítimo";
    end
end

% Adicionar classes à tabela
Tabela.Classe = Classes;

% Salvar tabela em CSV
writetable(Tabela, 'Experiencia.txt');
disp('Tabela gerada e salva como "Experiencia.txt".');

% Criar 2000 inventários diferentes para Bots
numBots = 2000;
InventariosBots = cell(numBots, 1);
uniqueCombinations = nchoosek(itens_inventario, 4); % Gerar todas as combinações de 4 itens
idx = randperm(size(uniqueCombinations, 1), numBots); % Selecionar combinações aleatórias

for i = 1:numBots
    InventariosBots{i} = strjoin(uniqueCombinations(idx(i), :), ', ');
end

% Salvar InventariosBots em um arquivo txt
fileID = fopen('InventariosBots.txt', 'w');
for i = 1:numBots
    fprintf(fileID, '%s\n', InventariosBots{i});
end
fclose(fileID);
disp('Inventários Bots gerados e salvos como "InventariosBots.txt".');
