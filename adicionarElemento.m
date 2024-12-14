function BF = adicionarElemento(jogador,BF,k,R)
    n = length(BF);
    for i = 1:k
        hash_code = ip2hash(char(jogador),R,i);
        indice = mod(hash_code,n)+1;
        BF(indice) = 1;
    end
end
