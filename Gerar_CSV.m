% Configuração do número de jogadores
numJogadores = 2000;

% Limites das métricas
accuracy_limit = 80;
reaction_limit = 300;
apm_low = 40;
apm_high = 100;
error_limit = 15;

% Pesos das métricas
pesos = struct(...
    'IPRepetido', 2.0, ...
    'JaFoiSuspeito', 2.0, ...
    'Acuracia', 1.5, ...
    'TempoReacao', 1.0, ...
    'APM', 1.5, ...
    'TaxaErros', 1.0, ...
    'AcoesBots', 2.0); % Nova coluna adicionada

% Lista de 20 itens de inventário (certifique-se de que não há espaços extras)
itens_inventario = { ...
    'Espada', 'Escudo', 'Poção', 'Arco', 'Flecha', 'Elmo', ...
    'Armadura', 'Martelo', 'Anel', 'Adaga', 'Botas', ...
    'Luvas', 'Cristal', 'Tomo', 'Colar', 'Chave', ...
    'Mapa', 'Joia', 'Lança', 'Foco' ...
};

% Gerar dados contínuos
rng(42); % Para reprodutibilidade
IPs = arrayfun(@(x) sprintf('192.168.%d.%d', randi(255), randi(255)), 1:numJogadores, 'UniformOutput', false);
Acuracia = randi([50, 100], numJogadores, 1); % Acurácia entre 50% e 100%
TempoReacao = randi([200, 500], numJogadores, 1); % Tempo de reação entre 200ms e 500ms
APM = randi([30, 150], numJogadores, 1); % Ações por minuto
TaxaErros = randi([0, 50], numJogadores, 1); % Taxa de erros entre 0% e 50%
IPRepetido = randi([0, 1], numJogadores, 1); % Binário
JaFoiSuspeito = randi([0, 1], numJogadores, 1); % Binário
AcoesBots = randi([0, 1], numJogadores, 1); % Nova coluna binária para ações de bots

% Gerar inventário aleatório para cada jogador
Inventarios = cell(numJogadores, 1);
for i = 1:numJogadores
    itens = itens_inventario(randperm(length(itens_inventario), 4)); % 4 itens aleatórios
    Inventarios{i} = strjoin(itens, ', '); % Converter para string
end

% Calcular score ponderado e definir classes
Classes = strings(numJogadores, 1);
 s=0;
        l=0;
for i = 1:numJogadores
    score = 0;

    % Adicionar contribuições ponderadas das métricas
    score = score + pesos.IPRepetido * IPRepetido(i);
    score = score + pesos.JaFoiSuspeito * JaFoiSuspeito(i);
    score = score + pesos.Acuracia * (Acuracia(i) < accuracy_limit);
    score = score + pesos.TempoReacao * (TempoReacao(i) > reaction_limit);
    score = score + pesos.APM * ((APM(i) < apm_low) + (APM(i) > apm_high));
    score = score + pesos.TaxaErros * (TaxaErros(i) > error_limit);
    score = score + pesos.AcoesBots * AcoesBots(i); % Ações de bots adicionadas ao cálculo
       
    % Classificar como "Suspeito" ou "Legítimo" com base no score
    if score > 3.5  % Limiar arbitrário (ajustável)
        Classes(i) = "Suspeito";
        s=s+1;
    else
        Classes(i) = "Legítimo";
        l = l+1;
    end
end

% Criar tabela final
Tabela = table(IPs', Acuracia, TempoReacao, APM, TaxaErros, IPRepetido, ...
    JaFoiSuspeito, Inventarios, AcoesBots, Classes, ...
    'VariableNames', {'IP', 'Acuracia', 'TempoReacao', 'APM', ...
                      'TaxaErros', 'IPRepetido', 'JaFoiSuspeito', ...
                      'Inventario', 'AcoesBots', 'Classe'});
l
s
% Salvar em CSV
writetable(Tabela, 'Tabela_Dados_Jogadores.csv');
disp('Tabela gerada e salva como "Tabela_Jogadores_Completa.csv".');
