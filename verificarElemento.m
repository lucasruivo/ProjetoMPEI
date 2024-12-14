function res = verificarElemento(teste,BF,k,R)
    n = length(BF);
    bits = zeros(1, k);
    for i = 1:k
        hash_code = ip2hash(teste,R,i);
        indice = mod(hash_code,n)+1;
        
        bits(i)= BF(indice);
    end
    res= (all(bits));
end