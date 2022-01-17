function SW_Network = GenerateSWFunction(N,K,beta)
%生成小世界网络SW(Small World),N为节点数
% 平均度为2*K
for k = 1 : 30
    h = WattsStrogatz(N,K,beta);
    edges = table2array(h.Edges);
    adj = sparse(N,N);
    for i = 1 : length(edges)
        adj(edges(i,1),edges(i,2)) = 1;
        adj(edges(i,2),edges(i,1)) = 1;
    end
    SW_Network = adj;
end

end