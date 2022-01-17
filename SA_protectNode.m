function [nodPro] = SA_protectNode(adj_str_arr,threshold,nodCom,num_nodes_protect)
%函数功能：
%输入参数： adj_str_arr n×n×layers  原多重网络邻接矩阵
%          threshold是社区失效的阈值比例
%          nodCom是社区划分后的结果，标识每个节点的所属社区
%          num_nodes_protect是需要保护的节点数量
%
%输出参数：需要保护节点的序号矩阵nodPro，一维矩阵


%使用模拟退火算法提高网络的攻击鲁棒性，考虑社区失效
%算法流程如下
%1.初始选取度最大的前百分之五节点保护序列，剩下的百分之九十五为待选节点序列。
%2.随机交换节点保护序列和待选节点序列中的一对节点，如果鲁棒性提高，则接受；
%  如果鲁棒性不提高，以一定概率接受。
%3.循环到指定次数退出。
%网络信息
%%3层，单层279个节点

adj_multi = adj_str_arr;
[~,num_nodes,num_layers]=size(adj_multi);

%设置循环次数
num_loops = 30;
%模拟退火算法的循环次数
num_loops_sa = 1000;
%需要受保护的节点序列
nodes_protect = [];

%计算原始鲁棒性
R_sum = 0 ;
sq_seq_sum = zeros(1 ,num_nodes);
for i=1 : num_loops
    %计算网络的恢复鲁棒性
    %[R_org ,sq_seq_org] = ComRecRob(adj_multi,nodCom,threshold,nodes_protect);
    %计算网络的攻击鲁棒性
    [R_org ,sq_seq_org] = ComAtkRob(adj_multi,nodCom,threshold,nodes_protect);
    R_sum = R_sum + R_org;
    sq_seq_sum = sq_seq_sum + sq_seq_org;
end
R_org = R_sum / num_loops;
sq_seq_org = sq_seq_sum / num_loops;

% 将多重网络中的节点按照度进行排序
degree_of_nodes_all = sum( sum(adj_str_arr(:,:,1)),1);
% nodes_seq_sorted 即为根据度排序后的节点序列
[~,nodes_seq_sorted] = sort(degree_of_nodes_all,'descend');

%未受到保护节点的数目
num_nodes_unprotect = num_nodes - num_nodes_protect ;
%受到保护的节点
nodes_protect = nodes_seq_sorted(1:num_nodes_protect);
%实际上未受到保护的节点
nodes_unprotect = nodes_seq_sorted(num_nodes_protect+1 : end);

t = 1;
while t < num_loops_sa
    nodes_protect_temp = nodes_protect;
    nodes_unprotect_temp = nodes_unprotect;
    %保护序列中节点的索引
    node_a_index = ceil(rand()*num_nodes_protect);
    %保护序列中的节点
    node_a = nodes_protect(node_a_index);
    %待选序列中的节点的索引
    node_b_index = ceil(rand()*num_nodes_unprotect);
    %待选序列中的节点
    node_b = nodes_unprotect(node_b_index);
    %交换节点
    node_temp = nodes_protect_temp(node_a_index);
    nodes_protect_temp(node_a_index) = nodes_unprotect_temp(node_b_index);
    nodes_unprotect_temp(node_b_index) = node_temp;
    nodes_protect_temp;
    %计算保护节点的鲁棒性
    R_sum =  0;
    sq_seq_sum = zeros( 1 , num_nodes);
    
    %用来存储最大的鲁棒性
    R_max =  0;
    sq_seq_max = zeros(1,num_nodes);
    
    for i = 1 : num_loops
        %计算网络的恢复鲁棒性
        %[R_pr ,sq_seq_pr] = ComRecRob(adj_multi,nodCom,threshold,nodes_protect_temp);
        %计算网络的攻击鲁棒性
        [R_pr ,sq_seq_pr] = ComAtkRob(adj_multi,nodCom,threshold,nodes_protect_temp);
        R_sum = R_sum + R_pr;
        sq_seq_sum = sq_seq_sum + sq_seq_pr;
    end
    R_pr = R_sum / num_loops;
    sq_seq_pr = sq_seq_sum / num_loops;
    
    if R_pr > R_org
        %鲁棒性提高则接受改变
        nodes_protect = nodes_protect_temp;
        R_org = R_pr;
        sq_seq_org = sq_seq_pr;
    elseif rand() < exp( (R_pr - R_org) / (1e-5) )
        %鲁棒性没有提高则以一定概率接受改变
        nodes_protect = nodes_protect_temp;
        R_org = R_pr;
        sq_seq_org = sq_seq_pr;
    end
    
    %更新最大的鲁棒性
    if  R_org > R_max
        R_max =  R_org;
        sq_seq_max = sq_seq_org;
    end
    fprintf('t:%d, R_org:%f, R_pr:%f\n',t,R_org,R_pr);
    t = t + 1;
end

nodPro = nodes_protect;

end %function ends