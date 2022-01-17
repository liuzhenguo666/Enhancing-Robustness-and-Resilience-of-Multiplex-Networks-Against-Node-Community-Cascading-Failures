function [Rrc,sq_seq_rc] = ComRecRob(adj_multi,nodes_community,threshold,nodes_protect)
%功能:计算多重网络的恢复鲁棒性Rrc
%输入参数: adj_multi n×n×layers 多重网络的邻接矩阵，是个三维数组  n是多重网络的节点数，layers是多重网络的层数
%         nodes_community 节点的社区分布 如[1,1,1,2]表示节点1，2，3属于社区1，节点4属于社区2
%         threshold 社区完全失效的阈值
%         nodes_protect  要保护的节点序列  1×m (m=1:num_nodes)
%输出参数: Rrc 计算得到的鲁棒性 理论上的最大值是0.5
%         sq_seq 1×num_nodes 序列中的第n个值表示在第n次攻击后，网络中的最大连通图占总节点的比例
    [num_nodes,num_nodes,num_layers] = size(adj_multi);
    Rrc_sum = 0;
    sq_seq_rc = zeros(1,num_nodes);
    %原始矩阵
%     adj_multi_ori = adj_multi;
%     degree_of_nodes_all = sum(sum(adj_multi_ori),3);
%     [val_sorted,nodes_seq_sorted] = sort(degree_of_nodes_all,'descend');
     adj_multi_ori = adj_multi;
    %随机恢复
    nodes_seq_recover = randperm(num_nodes);
    nodes_attack = [];
    for i = 1:num_nodes
        nodes_recover = nodes_seq_recover(1:i);
        %待恢复的矩阵为全部失效的矩阵
        adj_multi_rec = zeros(num_nodes,num_nodes,num_layers);
        %交集
        nodes_protect_exact = intersect(nodes_recover,nodes_protect);
        %nodes_protect_exact = nodes_protect;
        adj_multi_recovered = recover_Simple_Multiplex_Networks(adj_multi_ori,adj_multi_rec,nodes_recover);
        [adj_multi_recovered,node_state_matrix] = AtkNetWithCom(adj_multi_recovered,...
                                                   nodes_community,nodes_attack,threshold,nodes_protect_exact);
        %node_state_matrix(1,:)表示的是多层网络中第一层的状态
        Rrc_sum = Rrc_sum + sum( node_state_matrix(1,:) );
        sq_seq_rc(i) = sum( node_state_matrix(1,:) );
    end
    Rrc = Rrc_sum / (num_nodes * num_nodes);
    sq_seq_rc = sq_seq_rc / num_nodes;
end%function ends

function [adj_multi_recovered] = recover_Simple_Multiplex_Networks(adj_multi_ori,adj_multi_rec,nodes_recover)
%函数功能：根据输入原多重网络邻接矩阵、待恢复的多重网络邻接矩阵、要恢复的节点来先简单恢复网络
%输入参数： adj_multi_ori n×n×layers  原多重网络邻接矩阵
%          adj_multi_rec n×n×layers  待恢复的多重网络邻接矩阵
%          nodes_recover 1×m          要恢复的节点 这里指的是第一层中的节点
%输出参数：adj_multi_recovered  n×n×layers  恢复后的多重网络的邻接矩阵
    if isempty(nodes_recover)==1 || length(nodes_recover)==1
        %没有节点恢复
        adj_multi_recovered = adj_multi_rec;
    elseif  length(nodes_recover)>1
        adj_multi_rec(nodes_recover,nodes_recover,:)=adj_multi_ori(nodes_recover,nodes_recover,:);
        adj_multi_recovered=adj_multi_rec;
    end% if ends
 
end %function ends