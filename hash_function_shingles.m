function hc = hash_function_shingles(shingle,hf,R,p)

% linha com ks valores random
r= R(hf,:);
ascii = double(shingle);
hc = mod(ascii * r',p);

end