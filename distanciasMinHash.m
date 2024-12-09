function J = distanciasMinHash(Set,Nj,k,R)
% Calcular estimativa de distância usando MinHash

J = zeros(Nj);
h= waitbar(0,'Calculating...');

% 1. Calcular matriz assinatura

    %inicializa matriz
    Assinaturas = zeros(k,Nj);
    
    %iterar pelas k funções de hash
    for hf= 1:k
        waitbar(hf/k,h);
        %iterar pelos conjuntos
        for c = 1:Nj
            conjunto = Set{c};
             hc = zeros(length(conjunto), 1);
            %iterar pelos elementos do conjunto
            for el = 1:length(conjunto)
                elemento = conjunto(el);

                %aplicar função de hash aos elementos
                hc(el) = hash_function(elemento,hf,R);
            end
            %fazer o minimo
            minhash = min(hc);

            % guardar
            Assinaturas(hf,c)= minhash;
        end
    end
    delete(h)

% 2. calcular distancias

h= waitbar(0,'Calculating...');

for n1= 1:Nj
    waitbar(n1/Nj,h);
    for n2 = n1+1:Nj
        %Assinaturas
        assinatura1 = Assinaturas(:,n1);
        assinatura2 = Assinaturas(:,n2);

        %simil = Njmeros iguais na mesma posição / k
        simil = sum(assinatura1 == assinatura2)/k;
        J(n1,n2) = 1-simil;
    end
end
 delete(h)
end