function [edges_all] = Adj2EdgesAll(adj_multi)
%函数功能:将多重网络的邻接矩阵转化为edges_all的形式 
%         如[1,2,3,1]表示在第一层网络中，节点2和节点3有一条边，权重为1
%输入参数:adj_multi 多重网络的邻接矩阵
%输出参数:edges_all 

    %信息提示
    %fprintf('Adj2EdgesAll is running\n');
    [num_nodes,num_nodes,num_layers]=size(adj_multi);
    % edges_all存储每一多重网络的的边和权重，如[1,2,3,1]表示在第一层网络中，节点2和节点3有一条边，权重为1
     edges_all = [];
     for i = 1:num_layers
        %多重网络的每一层
        for j = 1:num_nodes
            edges = find(adj_multi(j,:,i)==1);
            %不为空
            if isempty(edges)==0
                for k=1:length(edges)
                    edge_single=zeros(1,4);
                    %layer
                    edge_single(1)=i;
                    %node
                    edge_single(2)=j;
                    %node
                    edge_single(3)=edges(k);
                    %weight 
                    edge_single(4)=1;
                    edges_all=[edges_all;edge_single];
                end
            end       
        end     
    end

end