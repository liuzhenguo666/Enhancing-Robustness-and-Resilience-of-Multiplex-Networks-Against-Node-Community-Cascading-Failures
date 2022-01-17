function [Rrc,sq_seq_rc] = ComRecRob(adj_multi,nodes_community,threshold,nodes_protect)
%����:�����������Ļָ�³����Rrc
%�������: adj_multi n��n��layers ����������ڽӾ����Ǹ���ά����  n�Ƕ�������Ľڵ�����layers�Ƕ�������Ĳ���
%         nodes_community �ڵ�������ֲ� ��[1,1,1,2]��ʾ�ڵ�1��2��3��������1���ڵ�4��������2
%         threshold ������ȫʧЧ����ֵ
%         nodes_protect  Ҫ�����Ľڵ�����  1��m (m=1:num_nodes)
%�������: Rrc ����õ���³���� �����ϵ����ֵ��0.5
%         sq_seq 1��num_nodes �����еĵ�n��ֵ��ʾ�ڵ�n�ι����������е������ͨͼռ�ܽڵ�ı���
    [num_nodes,num_nodes,num_layers] = size(adj_multi);
    Rrc_sum = 0;
    sq_seq_rc = zeros(1,num_nodes);
    %ԭʼ����
%     adj_multi_ori = adj_multi;
%     degree_of_nodes_all = sum(sum(adj_multi_ori),3);
%     [val_sorted,nodes_seq_sorted] = sort(degree_of_nodes_all,'descend');
     adj_multi_ori = adj_multi;
    %����ָ�
    nodes_seq_recover = randperm(num_nodes);
    nodes_attack = [];
    for i = 1:num_nodes
        nodes_recover = nodes_seq_recover(1:i);
        %���ָ��ľ���Ϊȫ��ʧЧ�ľ���
        adj_multi_rec = zeros(num_nodes,num_nodes,num_layers);
        %����
        nodes_protect_exact = intersect(nodes_recover,nodes_protect);
        %nodes_protect_exact = nodes_protect;
        adj_multi_recovered = recover_Simple_Multiplex_Networks(adj_multi_ori,adj_multi_rec,nodes_recover);
        [adj_multi_recovered,node_state_matrix] = AtkNetWithCom(adj_multi_recovered,...
                                                   nodes_community,nodes_attack,threshold,nodes_protect_exact);
        %node_state_matrix(1,:)��ʾ���Ƕ�������е�һ���״̬
        Rrc_sum = Rrc_sum + sum( node_state_matrix(1,:) );
        sq_seq_rc(i) = sum( node_state_matrix(1,:) );
    end
    Rrc = Rrc_sum / (num_nodes * num_nodes);
    sq_seq_rc = sq_seq_rc / num_nodes;
end%function ends

function [adj_multi_recovered] = recover_Simple_Multiplex_Networks(adj_multi_ori,adj_multi_rec,nodes_recover)
%�������ܣ���������ԭ���������ڽӾ��󡢴��ָ��Ķ��������ڽӾ���Ҫ�ָ��Ľڵ����ȼ򵥻ָ�����
%��������� adj_multi_ori n��n��layers  ԭ���������ڽӾ���
%          adj_multi_rec n��n��layers  ���ָ��Ķ��������ڽӾ���
%          nodes_recover 1��m          Ҫ�ָ��Ľڵ� ����ָ���ǵ�һ���еĽڵ�
%���������adj_multi_recovered  n��n��layers  �ָ���Ķ���������ڽӾ���
    if isempty(nodes_recover)==1 || length(nodes_recover)==1
        %û�нڵ�ָ�
        adj_multi_recovered = adj_multi_rec;
    elseif  length(nodes_recover)>1
        adj_multi_rec(nodes_recover,nodes_recover,:)=adj_multi_ori(nodes_recover,nodes_recover,:);
        adj_multi_recovered=adj_multi_rec;
    end% if ends
 
end %function ends