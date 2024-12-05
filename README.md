O classificador nayve bayes nós já sabiamos que ia ser para classificar jogadores como legitimos ou suspeitos através de alguma métricas

-Accuracy
-Tempo de reação
-Ações por minuto
-Taxa de erros
-IPs repetidos
-Se já foi suspeito

Depois o bloom filter ele vai servir para rastrear os IPs repetidos ou ips de pessoal que já tenha sido taxado como suspeito. Este vai dar essa informação ao naive bayes para ele pôr na tabela

O minhash basicamente vai identificar bots apartir de ações repetitivas, por exemplo

Mover atacar defender mover
Mover atacar usarhabilidade mover

São mt similares ent é um bot potencial
