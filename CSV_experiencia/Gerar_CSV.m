% Configuração do número de jogadores
numJogadores = 10000;

% Limites das métricas
accuracy_limit = 80;
reaction_limit = 200;
apm_low = 40;
apm_high = 100;
headshot_limit = 50; % Limite para taxa de headshots considerada estranha (%)

% Pesos das métricas
pesos = struct(...
    'IPRepetido', 2.0, ...
    'JaFoiSuspeito', 2.0, ...
    'Acuracia', 1.5, ...
    'TempoReacao', 1.0, ...
    'APM', 1.0, ...
    'TaxaHeadshots', 1.5, ...
    'AcoesBots', 1.0);

% Gerar dados contínuos
rng('shuffle'); % Para reprodutibilidade variável
IPs = arrayfun(@(x) sprintf('192.168.%d.%d', randi(255), randi(255)), 1:numJogadores, 'UniformOutput', false);
Acuracia = randi([50, 100], numJogadores, 1);
TempoReacao = randi([50, 400], numJogadores, 1);
APM = randi([30, 150], numJogadores, 1);
TaxaHeadshots = randi([0, 100], numJogadores, 1);
IPRepetido = randi([0, 1], numJogadores, 1); % Binário gerado aleatoriamente
AcoesBots = randi([0, 1], numJogadores, 1);

% Gerar lista de IPs reportados (5% dos jogadores, por exemplo)
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
    'Colete', 'GranadaInc', 'MediKit', 'Lança-granadas', 'GranadaFumo' ...
};
Inventarios = cell(numJogadores, 1);
for i = 1:numJogadores
    itens = itens_inventario(randperm(length(itens_inventario), 4));
    Inventarios{i} = strjoin(itens, ', ');
end

% Calcular score ponderado e definir classes
Classes = strings(numJogadores, 1);
for i = 1:numJogadores
    score = 0;
    score = score + pesos.IPRepetido * IPRepetido(i);
    score = score + pesos.JaFoiSuspeito * JaFoiSuspeito(i);
    score = score + pesos.Acuracia * (Acuracia(i) < accuracy_limit);
    score = score + pesos.TempoReacao * (TempoReacao(i) > reaction_limit);
    score = score + pesos.APM * ((APM(i) < apm_low) + (APM(i) > apm_high));
    score = score + pesos.TaxaHeadshots * (TaxaHeadshots(i) > headshot_limit);
    score = score + pesos.AcoesBots * AcoesBots(i);

    if score > 4.5
        Classes(i) = "Suspeito";
    else
        Classes(i) = "Legítimo";
    end
end

% Criar tabela final
Tabela = table(IPs', Inventarios, Acuracia, TempoReacao, APM, TaxaHeadshots, IPRepetido, ...
    JaFoiSuspeito, AcoesBots, Classes, ...
    'VariableNames', {'IP', 'Inventario', 'Acuracia', 'TempoReacao', 'APM', ...
                      'TaxaHeadshots', 'IPRepetido', 'JaFoiSuspeito', ...
                      'SusInv', 'Classe'});

% Salvar em CSV
writetable(Tabela, 'Experiencia.csv');
disp('Tabela gerada e salva como "Tabela_Dados_Jogadores_Sem_BloomFilter.csv".');

disp(IPsReportados);