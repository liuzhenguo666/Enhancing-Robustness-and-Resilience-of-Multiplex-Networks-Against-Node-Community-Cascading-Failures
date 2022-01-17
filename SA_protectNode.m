function [nodPro] = SA_protectNode(adj_str_arr,threshold,nodCom,num_nodes_protect)
%�������ܣ�
%��������� adj_str_arr n��n��layers  ԭ���������ڽӾ���
%          threshold������ʧЧ����ֵ����
%          nodCom���������ֺ�Ľ������ʶÿ���ڵ����������
%          num_nodes_protect����Ҫ�����Ľڵ�����
%
%�����������Ҫ�����ڵ����ž���nodPro��һά����


%ʹ��ģ���˻��㷨�������Ĺ���³���ԣ���������ʧЧ
%�㷨��������
%1.��ʼѡȡ������ǰ�ٷ�֮��ڵ㱣�����У�ʣ�µİٷ�֮��ʮ��Ϊ��ѡ�ڵ����С�
%2.��������ڵ㱣�����кʹ�ѡ�ڵ������е�һ�Խڵ㣬���³������ߣ�����ܣ�
%  ���³���Բ���ߣ���һ�����ʽ��ܡ�
%3.ѭ����ָ�������˳���
%������Ϣ
%%3�㣬����279���ڵ�

adj_multi = adj_str_arr;
[~,num_nodes,num_layers]=size(adj_multi);

%����ѭ������
num_loops = 30;
%ģ���˻��㷨��ѭ������
num_loops_sa = 1000;
%��Ҫ�ܱ����Ľڵ�����
nodes_protect = [];

%����ԭʼ³����
R_sum = 0 ;
sq_seq_sum = zeros(1 ,num_nodes);
for i=1 : num_loops
    %��������Ļָ�³����
    %[R_org ,sq_seq_org] = ComRecRob(adj_multi,nodCom,threshold,nodes_protect);
    %��������Ĺ���³����
    [R_org ,sq_seq_org] = ComAtkRob(adj_multi,nodCom,threshold,nodes_protect);
    R_sum = R_sum + R_org;
    sq_seq_sum = sq_seq_sum + sq_seq_org;
end
R_org = R_sum / num_loops;
sq_seq_org = sq_seq_sum / num_loops;

% �����������еĽڵ㰴�նȽ�������
degree_of_nodes_all = sum( sum(adj_str_arr(:,:,1)),1);
% nodes_seq_sorted ��Ϊ���ݶ������Ľڵ�����
[~,nodes_seq_sorted] = sort(degree_of_nodes_all,'descend');

%δ�ܵ������ڵ����Ŀ
num_nodes_unprotect = num_nodes - num_nodes_protect ;
%�ܵ������Ľڵ�
nodes_protect = nodes_seq_sorted(1:num_nodes_protect);
%ʵ����δ�ܵ������Ľڵ�
nodes_unprotect = nodes_seq_sorted(num_nodes_protect+1 : end);

t = 1;
while t < num_loops_sa
    nodes_protect_temp = nodes_protect;
    nodes_unprotect_temp = nodes_unprotect;
    %���������нڵ������
    node_a_index = ceil(rand()*num_nodes_protect);
    %���������еĽڵ�
    node_a = nodes_protect(node_a_index);
    %��ѡ�����еĽڵ������
    node_b_index = ceil(rand()*num_nodes_unprotect);
    %��ѡ�����еĽڵ�
    node_b = nodes_unprotect(node_b_index);
    %�����ڵ�
    node_temp = nodes_protect_temp(node_a_index);
    nodes_protect_temp(node_a_index) = nodes_unprotect_temp(node_b_index);
    nodes_unprotect_temp(node_b_index) = node_temp;
    nodes_protect_temp;
    %���㱣���ڵ��³����
    R_sum =  0;
    sq_seq_sum = zeros( 1 , num_nodes);
    
    %�����洢����³����
    R_max =  0;
    sq_seq_max = zeros(1,num_nodes);
    
    for i = 1 : num_loops
        %��������Ļָ�³����
        %[R_pr ,sq_seq_pr] = ComRecRob(adj_multi,nodCom,threshold,nodes_protect_temp);
        %��������Ĺ���³����
        [R_pr ,sq_seq_pr] = ComAtkRob(adj_multi,nodCom,threshold,nodes_protect_temp);
        R_sum = R_sum + R_pr;
        sq_seq_sum = sq_seq_sum + sq_seq_pr;
    end
    R_pr = R_sum / num_loops;
    sq_seq_pr = sq_seq_sum / num_loops;
    
    if R_pr > R_org
        %³�����������ܸı�
        nodes_protect = nodes_protect_temp;
        R_org = R_pr;
        sq_seq_org = sq_seq_pr;
    elseif rand() < exp( (R_pr - R_org) / (1e-5) )
        %³����û���������һ�����ʽ��ܸı�
        nodes_protect = nodes_protect_temp;
        R_org = R_pr;
        sq_seq_org = sq_seq_pr;
    end
    
    %��������³����
    if  R_org > R_max
        R_max =  R_org;
        sq_seq_max = sq_seq_org;
    end
    fprintf('t:%d, R_org:%f, R_pr:%f\n',t,R_org,R_pr);
    t = t + 1;
end

nodPro = nodes_protect;

end %function ends