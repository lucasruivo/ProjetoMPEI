function hc = hash_function(item,hf,R)

% linha com ks valores random
item = char(item);
ascii = string2hash(item,'djb2');

r1 = R.a(hf);
r2 = R.b(hf);

hc = mod(r1 * ascii + r2, R.p);

end