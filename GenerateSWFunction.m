function SW_Network = GenerateSWFunction(N,K,beta)
%����С��������SW(Small World),NΪ�ڵ���
% ƽ����Ϊ2*K
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