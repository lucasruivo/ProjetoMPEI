function Assinaturas = Calcular_Assinaturas_Inv(Set, Nb, k, R, p)
    % Inicializa matriz de assinaturas
    Assinaturas = zeros(k, Nb);

    for hf = 1:k
        for c = 1:Nb
            conjunto = Set{c};
            hc = zeros(length(conjunto), 1);
            for el = 1:length(conjunto)
                elemento = conjunto{el};
                hc(el) = hash_function_shingles(elemento, hf, R, p);
            end
            Assinaturas(hf, c) = min(hc);
        end
    end
end
