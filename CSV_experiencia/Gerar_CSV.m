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

% Gerar valores aleatórios para JaFoiSuspeito
JaFoiSuspeito = randi([0, 1], numJogadores, 1); % Valores binários aleatórios

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

% Criar tabela inicial
Tabela = table(IPs', Inventarios, Acuracia, TempoReacao, APM, TaxaHeadshots, ...
    JaFoiSuspeito, 'VariableNames', {'IP', 'Inventario', 'Precisao', 'TempoReacao', ...
                                     'APM', 'TaxaHeadshots', 'JaFoiSuspeito'});

% Configurar inventários suspeitos
inventariosBots = {
    {'Sniper', 'Silenciador', 'Mira', 'Colete'},
    {'Drone', 'Explosivo', 'Espingarda', 'Capacete'},
    {'Submetralhadora', 'Faca', 'GranadaFumo', 'Silenciador'},
    {'Pistola', 'Torreta', 'Colete', 'Capacete'},
    {'Espingarda', 'Silenciador', 'GranadaFumo', 'Colete'}
};

% Ajustar valores de SusInv
Tabela.SusInv = zeros(numJogadores, 1);
for i = 1:height(Tabela)
    inventarioJogador = strsplit(Tabela.Inventario{i}, ', ');
    for j = 1:length(inventariosBots)
        if sum(ismember(inventarioJogador, inventariosBots{j})) >= 3
            Tabela.SusInv(i) = 1;
            break;
        end
    end
end

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
writetable(Tabela, 'Experiencia.csv');
disp('Tabela gerada e salva como "Experiencia.csv".');
