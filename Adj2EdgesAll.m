function [edges_all] = Adj2EdgesAll(adj_multi)
%��������:������������ڽӾ���ת��Ϊedges_all����ʽ 
%         ��[1,2,3,1]��ʾ�ڵ�һ�������У��ڵ�2�ͽڵ�3��һ���ߣ�Ȩ��Ϊ1
%�������:adj_multi ����������ڽӾ���
%�������:edges_all 

    %��Ϣ��ʾ
    %fprintf('Adj2EdgesAll is running\n');
    [num_nodes,num_nodes,num_layers]=size(adj_multi);
    % edges_all�洢ÿһ��������ĵıߺ�Ȩ�أ���[1,2,3,1]��ʾ�ڵ�һ�������У��ڵ�2�ͽڵ�3��һ���ߣ�Ȩ��Ϊ1
     edges_all = [];
     for i = 1:num_layers
        %���������ÿһ��
        for j = 1:num_nodes
            edges = find(adj_multi(j,:,i)==1);
            %��Ϊ��
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