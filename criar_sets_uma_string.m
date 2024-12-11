function [Set2] = criar_sets_uma_string(inventario,ksh)


Set2 = cell(1, 1);
inventario = strjoin(inventario(1,:), '');
num_shingle = length(inventario)-ksh+1;
shingles= cell(1,num_shingle);
for sh = 1:num_shingle
    shingles{sh}= inventario(sh:sh+ksh-1);
end
Set2{1,1}=shingles;

end