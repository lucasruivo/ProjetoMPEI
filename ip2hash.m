function hash = ip2hash(ip,R,k)

    partes = string(strsplit(ip,'.'));
    x = double(partes(3)) * 256 + double(partes(4)); 
    hash = mod(R.a(k) .* double(x) + R.b(k), R.p);
end