% Nome do arquivo CSV
filename = 'Experiencia.csv';

% Leitura do arquivo CSV
data = readtable(filename, 'TextType', 'string');

% Supondo que os IPs estejam na primeira coluna
ip_column = data{:, 1};

% Contar a frequência de cada IP
[ip_counts, unique_ips] = groupcounts(ip_column);

% Exibir o número de vezes que cada IP aparece
disp('Frequência de cada IP:');
disp(table(unique_ips, ip_counts, 'VariableNames', {'IP', 'Count'}));

% Contar quantos IPs aparecem mais de uma vez
duplicated_ips_count = sum(ip_counts > 1);

% Exibir o número de IPs duplicados
fprintf('Número de IPs duplicados: %d\n', duplicated_ips_count);

% Criar uma nova coluna chamada 'IPRepetido' com valores iniciais em 0
data.IPRepetido = zeros(height(data), 1);

% Iterar por cada linha para verificar se o IP já apareceu antes
for i = 1:height(data)
    % Extrair o IP atual
    ipAtual = data.IP{i};
    
    % Verificar se o IP já apareceu antes na tabela
    if sum(strcmp(data.IP(1:i-1), ipAtual)) > 0
        % Se o IP já apareceu, marcar como 1
        data.IPRepetido(i) = 1;
    end
end

% Configuração dos inventários suspeitos
inventariosBots = {
    {'Sniper', 'Silenciador', 'Mira', 'Colete'},
    {'Drone', 'Explosivo', 'Espingarda', 'Capacete'},
    {'Submetralhadora', 'Faca', 'GranadaFumo', 'Silenciador'},
    {'Pistola', 'Torreta', 'Colete', 'Capacete'},
    {'Espingarda', 'Silenciador', 'GranadaFumo', 'Colete'}
};

% Inicializar coluna SusInv
data.SusInv = zeros(height(data), 1);

% Verificar inventários
for i = 1:height(data)
    % Separar itens do inventário do jogador
    inventarioJogador = strsplit(data.Inventario{i}, ', ');
    
    % Comparar com inventários suspeitos
    for j = 1:length(inventariosBots)
        % Contar número de itens iguais
        itensIguais = sum(ismember(inventarioJogador, inventariosBots{j}));
        if itensIguais >= 3
            data.SusInv(i) = 1; % Marca como suspeito
            break; % Não precisa verificar mais
        end
    end
end

% Contar o número de valores "1" na coluna SusInv
numSuspeitos = sum(data.SusInv);

% Exibir o número de jogadores com inventários suspeitos
fprintf('Número de jogadores com inventários suspeitos: %d\n', numSuspeitos);

% Salvar tabela atualizada em CSV
writetable(data, 'Experiencia.csv');
disp('Tabela atualizada e salva como "Tabela_Dados_Jogadores_Com_Analise.csv".');
