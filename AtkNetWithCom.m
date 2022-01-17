function [adj_multi_new,node_state_matrix] = AtkNetWithCom(adj_multi,nodes_community,nodes_attack,threshold,nodes_protect)
%��������:  ����һ���������磬�Զ����������������ʧЧ���̽���ģ��
%�������:  adj_multi: ����������ڽӾ���,����ά����  n��n��layers n�������еĽڵ����,layers�Ƕ�������Ĳ���
%           community:�����нڵ�������ֲ� 1��n ��[1,1,2]��ʾ�ڵ�1��2��������1���ڵ�3��������2
%           nodes_attack:�Ե�һ��������й����Ľڵ�   1��m(m=1:num_nodes)
%           threshold:������ȫʧЧ����ֵ 0����1 ��ȡ0.8����ʾ�������аٷ�֮80�ڵ�ʧЧʱ���������ʧЧ
%           nodes_protect:Ҫ�����Ľڵ�����  1��m(m=1:num_nodes) [2,3]��ʾ�ڵ�2�ͽڵ�3�ܵ�����
%��������� adj_multi_new:���º�Ķ���������ڽӾ���
%           node_state_matrix:��������Ľڵ�״̬����
   
     [num_nodes,num_nodes,num_layers]=size(adj_multi);
     if isequal(adj_multi,zeros(num_nodes,num_nodes,num_layers))==1
        adj_multi_new=adj_multi;
        node_state_matrix=zeros(num_layers,num_nodes);
        return;
     end
     
     
    adj_multi=attack_Simple_Multiplex_Networks(adj_multi,nodes_attack,nodes_protect);
    num_loops=0;
    while 1
        num_loops = num_loops + 1;
        %��һ��:����ʧЧ
        [adj_multi,node_state_matrix1]=lose_Effect_In_Layer(adj_multi,nodes_protect);
        %�ڶ���:���ʧЧ
        node_state_matrix2=lose_Effect_Between_Layers(node_state_matrix1,nodes_protect);
        %�ڶ���:����ʧЧ
        node_state_matrix3=lose_Effect_In_Communities(node_state_matrix2,nodes_community,threshold,nodes_protect);
        %node_state_matrix1==node_state_matrix3 ϵͳ�ȶ�
        if isequal(node_state_matrix1,node_state_matrix3)==1 || isequal(adj_multi,zeros(num_nodes,num_nodes,num_layers))==1 ...
                || isequal(find(node_state_matrix1(1,:)==1),nodes_protect)==1 || num_loops == num_nodes
            break;
        else
            adj_multi=update_Adj(adj_multi,node_state_matrix3,nodes_protect);
        end%if end
    end%while ends
    %�����������ֵ
    adj_multi_new=update_Adj(adj_multi,node_state_matrix3,nodes_protect);
    node_state_matrix=node_state_matrix3;
end%function  ends
function [adj_multi_new]=attack_Simple_Multiplex_Networks(adj_multi,nodes_attack,nodes_protect)
%��������:�����������磬�ݲ����ǲ���ʧЧ�Ͳ��ʧЧ�� 
%�������:adj_multi:����������ڽӾ������ά����
%        nodes_attack:�����Ľڵ� ��[1,2,3]��ʾ������һ���е�1��2��3�Žڵ�
%        nodes_protect:�����Ľڵ� ��[2,3]��ʾ2��3�Žڵ��ܵ�����
%�������:adj_multi_new:���º�Ķ���������ڽӾ������ά����
    adj_multi_new=adj_multi;
    nodes_attack_act=setdiff(nodes_attack,nodes_protect);
    %��Ϊ�գ�����ڵ�ʧЧ
    if isempty(nodes_attack_act)==0
        adj_multi_new(nodes_attack_act,:,:)=0;
        adj_multi_new(:,nodes_attack_act,:)=0;
    end

end%function ends
function [adj_multi_new,node_state_matrix]=lose_Effect_In_Layer(adj_multi,nodes_protect)
%��������: �Զ���������в���ʧЧ
%�������: adj_multi:���������ڽӾ������ά����
%          nodes_protect:Ҫ�����Ľڵ� 1��m (m=1:num_nodes)
%�������: adj_multi_new:����ʧЧ���µĶ��������ڽӾ������ά����
%         node_state_matrix:��������Ľڵ�״̬���� num_layers��num_nodes�ľ���
%         ��[1,0,0;1,1,1]��ʾ��һ���нڵ�1��Ч���ڵ�2�ڵ�3ʧЧ���ڶ����нڵ�1���ڵ�2���ڵ�3��Ч��
%
%����ʧЧ:���������ͨ��ͼ�еĽڵ㽫ʧЧ

    [num_nodes,num_nodes,num_layers]=size(adj_multi);
    node_state_matrix=ones(num_layers,num_nodes);
    %����ÿһ��ڵ�������ͨͼ�����������ͨͼ�еĽڵ㽫ʧЧ
    for i=1:num_layers
        nodes=1:num_nodes;
        [ci sizes]=components(sparse(adj_multi(:,:,i)));
        %ci ��ʾ����Ķ���ֱ�������һ����ͨ����������
        %size ÿһ����ͨ�����Ĵ�С
        %ci��size ����������
        %mc_indices �������ͨ��ͼ����sizes�е�����
        mc_indices=find(sizes==max(sizes));
        if length(mc_indices)>1
            nodes_in_mc=find(ci==mc_indices(ceil(rand()*length(mc_indices))));
        else
            nodes_in_mc=find(ci==mc_indices);
        end
        nodes_in_mc=nodes_in_mc';
        %�����ڵ� ����
        nodes_in_mc=union(nodes_in_mc,nodes_protect);
        %�ó��ڵ��״̬����
        node_state_matrix(i,:)=ismember(nodes,nodes_in_mc);
    end%for ends
    %���ݽڵ��״̬������½ڵ���ڽӾ���
    adj_multi_new=update_Adj(adj_multi,node_state_matrix,nodes_protect);
end%function ends
function [adj_multi_new]=update_Adj(adj_multi,node_state_matrix,nodes_protect)
%�������ܣ����ݶ��������״̬���󣬸��¶���������ڽӾ���ṹ��
%���������adj_multi:����������ڽӾ������ά����
%          node_state_matrix:���������״̬���� num_layers��num_nodes�ľ���ֻ����0��1��0��ʾ�ڸò��ж�Ӧ�ڵ�ʧЧ��1��ʾ��Ӧ�ڵ㻹��Ч
%          node_state_matrix(1,1)=0  ��һ�������еĵ�һ���ڵ�ʧЧ
%���������adj_multi_new ���º�Ķ���������ڽӾ���ṹ��
    adj_multi_new = adj_multi;
    [num_layers,num_nodes]=size(node_state_matrix);
     %�����ڵ�
    node_state_matrix(:,nodes_protect)=1;
    for i=1:num_layers
        %��һ����ʧЧ�Ľڵ�
        nodes_lose_effect=find(node_state_matrix(i,:)==0);
        nodes_lose_effect_act = setdiff(nodes_lose_effect,nodes_protect);
        adj_multi_new(nodes_lose_effect_act,:,i)=0;
        adj_multi_new(:,nodes_lose_effect_act,i)=0;
    end
end%function end
function [node_state_matrix_new]=lose_Effect_Between_Layers(node_state_matrix,nodes_protect,nodeAuto)
%��������:�Զ���������в��ʧЧ
%�������: node_state_matrix ��������Ľڵ�״̬���� num_layers��num_nodes�ľ���
%          nodes_protect Ҫ�����Ľڵ�����
%�������:  node_state_matrix ��������Ľڵ�״̬���� num_layers��num_nodes�ľ���
    [num_layers,num_nodes]=size(node_state_matrix); 
    node_state_matrix_new = node_state_matrix;
    %�ڵ㱣��
    node_state_matrix_new(:,nodes_protect)=1;
    nodes_fail=[];
    for i=1:num_layers
        nodes_fail_in_layer=find(node_state_matrix_new(i,:)==0);
        nodes_fail=union(nodes_fail,nodes_fail_in_layer);
        % union([],[1,2])==[1;2]�����Ժ�Ҫת��
        if i==1
            nodes_fail=nodes_fail';
        end
    end%for ends
    %�ڵ㱣��
    nodes_fail_act=setdiff(nodes_fail,nodes_protect);
    node_state_matrix_new(:,nodes_fail_act)=0;
end%function ends
function [node_state_matrix_new]=lose_Effect_In_Communities(node_state_matrix,nodes_community,threshold,nodes_protect)
%��������:�Զ��������������ʧЧ
%�������:
%         node_state_matrix: ��������Ľڵ�״̬���� num_layers��num_nodes
%         nodes_community:���������нڵ�������ֲ���������Ϊ��������ÿһ��������ֲ�������ͬ�� 1��num_nodes
%         threshold:������ȫʧЧ����ֵ
%         nodes_protect:Ҫ�����Ľڵ����У�����Ĭ�϶��Ǳ�����һ���еĽڵ�

%�������: 
%         node_state_matrix_new:��������Ľڵ�״̬����
%�����е������ֲ�
    node_state_matrix_new = node_state_matrix;
    coms=unique(nodes_community);
%�����е�������Ŀ
    num_com=length(coms);

    for i=1:num_com
        %��ͬ�������еĽڵ�
        nodes_same_com=find(nodes_community==coms(i));
        if ~isempty(nodes_same_com)
            %�����ڶ�������ĵ�1���еĵ�i��������û��ʧЧ�Ľڵ�
            nodes_sum=sum(node_state_matrix(1,nodes_same_com));
            %�ڶ�������ĵ�1���еĵ�i��������ʧЧ�Ľڵ�����趨����ֵ������������������ʧЧ
            %threshold��ʾ����ʧЧ�Ľڵ���ֵ,nodes_sum��ʾ����û��ʧЧ�Ľڵ�������������Ҫ��1-threshold
            if nodes_sum/length(nodes_same_com)<1-threshold
                %��������������ʧЧ
                node_state_matrix_new(:,nodes_same_com)=0;
                %�����ڵ�
                node_state_matrix_new(:,nodes_protect)=1;
            end%if ends          
       end%if ends
    end%for ends
    %�ڵ㱣��
    node_state_matrix_new(:,nodes_protect)=1;
end%function ends
