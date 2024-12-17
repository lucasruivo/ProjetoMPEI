function J = distanciasMinHash(MA,MA2,Nb,Nj,k)
% Calcular estimativa de distância usando MinHash

J = zeros(Nb,Nj);
%h = waitbar(0, 'Calculando distâncias...');

for b= 1:Nb
    %waitbar(b / Nb, h, sprintf('Calculando distâncias (%d/%d)...', b, Nb));
    for j = 1:Nj
        %Assinaturas
        assinatura1 = MA(:,b);
        assinatura2 = MA2(:,j);

        %simil = Njmeros iguais na mesma posição / k
        simil = sum(assinatura1 == assinatura2)/k;
        J(b,j) = 1-simil;
    end
end
 %delete(h)
end