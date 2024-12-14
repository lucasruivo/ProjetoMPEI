clear;
n= 40000;
k=7;

ficheiro = 'Dados_Jogadores.txt';
data = readcell(ficheiro,'Delimiter',',');

jogadores= string(data(2:end,1));
classes= string(data(2:end,9));

BF = zeros(1,n,'uint8');

R.a = randi(123457,1,k);
R.b = randi(123457,1,k);
R.p = 123453;
while ~ isprime(R.p)
    R.p = R.p+2;
end

for nj = 1:length(jogadores)
    j = jogadores(nj);
    if classes(nj)=='Suspeito'
        BF = adicionarElemento(j,BF,k,R);
    end
end
%%

teste='192.168.124.246';
r= verificarElemento(teste,BF,k,R)
