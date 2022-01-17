function [adj_multi_new,node_state_matrix] = AtkNetWithCom(adj_multi,nodes_community,nodes_attack,threshold,nodes_protect)
%函数功能:  构建一个多重网络，对多重网络的社区级联失效过程进行模拟
%输入参数:  adj_multi: 多重网络的邻接矩阵,是三维数组  n×n×layers n是网络中的节点个数,layers是多重网络的层数
%           community:网络中节点的社区分布 1×n 如[1,1,2]表示节点1，2属于社区1，节点3属于社区2
%           nodes_attack:对第一层网络进行攻击的节点   1×m(m=1:num_nodes)
%           threshold:社区完全失效的阈值 0——1 如取0.8，表示当社区中百分之80节点失效时，这个社区失效
%           nodes_protect:要保护的节点序列  1×m(m=1:num_nodes) [2,3]表示节点2和节点3受到保护
%输出参数： adj_multi_new:更新后的多重网络的邻接矩阵
%           node_state_matrix:多重网络的节点状态矩阵
   
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
        %第一步:层内失效
        [adj_multi,node_state_matrix1]=lose_Effect_In_Layer(adj_multi,nodes_protect);
        %第二步:层间失效
        node_state_matrix2=lose_Effect_Between_Layers(node_state_matrix1,nodes_protect);
        %第二步:社区失效
        node_state_matrix3=lose_Effect_In_Communities(node_state_matrix2,nodes_community,threshold,nodes_protect);
        %node_state_matrix1==node_state_matrix3 系统稳定
        if isequal(node_state_matrix1,node_state_matrix3)==1 || isequal(adj_multi,zeros(num_nodes,num_nodes,num_layers))==1 ...
                || isequal(find(node_state_matrix1(1,:)==1),nodes_protect)==1 || num_loops == num_nodes
            break;
        else
            adj_multi=update_Adj(adj_multi,node_state_matrix3,nodes_protect);
        end%if end
    end%while ends
    %给输出参数赋值
    adj_multi_new=update_Adj(adj_multi,node_state_matrix3,nodes_protect);
    node_state_matrix=node_state_matrix3;
end%function  ends
function [adj_multi_new]=attack_Simple_Multiplex_Networks(adj_multi,nodes_attack,nodes_protect)
%函数功能:攻击复杂网络，暂不考虑层内失效和层间失效。 
%输入参数:adj_multi:多重网络的邻接矩阵的三维数组
%        nodes_attack:攻击的节点 如[1,2,3]表示攻击第一层中的1，2，3号节点
%        nodes_protect:保护的节点 如[2,3]表示2，3号节点受到保护
%输出参数:adj_multi_new:更新后的多重网络的邻接矩阵的三维数组
    adj_multi_new=adj_multi;
    nodes_attack_act=setdiff(nodes_attack,nodes_protect);
    %不为空，则令节点失效
    if isempty(nodes_attack_act)==0
        adj_multi_new(nodes_attack_act,:,:)=0;
        adj_multi_new(:,nodes_attack_act,:)=0;
    end

end%function ends
function [adj_multi_new,node_state_matrix]=lose_Effect_In_Layer(adj_multi,nodes_protect)
%函数功能: 对多重网络进行层内失效
%输入参数: adj_multi:多重网络邻接矩阵的三维数组
%          nodes_protect:要保护的节点 1×m (m=1:num_nodes)
%输出参数: adj_multi_new:层间隔失效后新的多重网络邻接矩阵的三维数组
%         node_state_matrix:多重网络的节点状态矩阵 num_layers×num_nodes的矩阵，
%         如[1,0,0;1,1,1]表示第一层中节点1有效，节点2节点3失效。第二层中节点1，节点2，节点3有效。
%
%层内失效:不在最大连通子图中的节点将失效

    [num_nodes,num_nodes,num_layers]=size(adj_multi);
    node_state_matrix=ones(num_layers,num_nodes);
    %计算每一层节点的最大连通图，不在最大连通图中的节点将失效
    for i=1:num_layers
        nodes=1:num_nodes;
        [ci sizes]=components(sparse(adj_multi(:,:,i)));
        %ci 表示矩阵的顶点分别属于哪一个连通分量的索引
        %size 每一个连通分量的大小
        %ci和size 都是列向量
        %mc_indices 是最大连通子图的在sizes中的索引
        mc_indices=find(sizes==max(sizes));
        if length(mc_indices)>1
            nodes_in_mc=find(ci==mc_indices(ceil(rand()*length(mc_indices))));
        else
            nodes_in_mc=find(ci==mc_indices);
        end
        nodes_in_mc=nodes_in_mc';
        %保护节点 并集
        nodes_in_mc=union(nodes_in_mc,nodes_protect);
        %得出节点的状态矩阵
        node_state_matrix(i,:)=ismember(nodes,nodes_in_mc);
    end%for ends
    %根据节点的状态矩阵更新节点的邻接矩阵
    adj_multi_new=update_Adj(adj_multi,node_state_matrix,nodes_protect);
end%function ends
function [adj_multi_new]=update_Adj(adj_multi,node_state_matrix,nodes_protect)
%函数功能：根据多重网络的状态矩阵，更新多重网络的邻接矩阵结构体
%输入参数：adj_multi:多重网络的邻接矩阵的三维数组
%          node_state_matrix:多重网络的状态矩阵 num_layers×num_nodes的矩阵，只包含0和1，0表示在该层中对应节点失效，1表示对应节点还有效
%          node_state_matrix(1,1)=0  第一层网络中的第一个节点失效
%输出参数：adj_multi_new 更新后的多重网络的邻接矩阵结构体
    adj_multi_new = adj_multi;
    [num_layers,num_nodes]=size(node_state_matrix);
     %保护节点
    node_state_matrix(:,nodes_protect)=1;
    for i=1:num_layers
        %在一层中失效的节点
        nodes_lose_effect=find(node_state_matrix(i,:)==0);
        nodes_lose_effect_act = setdiff(nodes_lose_effect,nodes_protect);
        adj_multi_new(nodes_lose_effect_act,:,i)=0;
        adj_multi_new(:,nodes_lose_effect_act,i)=0;
    end
end%function end
function [node_state_matrix_new]=lose_Effect_Between_Layers(node_state_matrix,nodes_protect,nodeAuto)
%函数功能:对多重网络进行层间失效
%输入参数: node_state_matrix 多重网络的节点状态矩阵 num_layers×num_nodes的矩阵
%          nodes_protect 要保护的节点序列
%输出参数:  node_state_matrix 多重网络的节点状态矩阵 num_layers×num_nodes的矩阵
    [num_layers,num_nodes]=size(node_state_matrix); 
    node_state_matrix_new = node_state_matrix;
    %节点保护
    node_state_matrix_new(:,nodes_protect)=1;
    nodes_fail=[];
    for i=1:num_layers
        nodes_fail_in_layer=find(node_state_matrix_new(i,:)==0);
        nodes_fail=union(nodes_fail,nodes_fail_in_layer);
        % union([],[1,2])==[1;2]，所以后要转置
        if i==1
            nodes_fail=nodes_fail';
        end
    end%for ends
    %节点保护
    nodes_fail_act=setdiff(nodes_fail,nodes_protect);
    node_state_matrix_new(:,nodes_fail_act)=0;
end%function ends
function [node_state_matrix_new]=lose_Effect_In_Communities(node_state_matrix,nodes_community,threshold,nodes_protect)
%函数功能:对多重网络进行社区失效
%输入参数:
%         node_state_matrix: 多重网络的节点状态矩阵 num_layers×num_nodes
%         nodes_community:多重网络中节点的社区分布，这里认为多重网络每一层的社区分布都是相同的 1×num_nodes
%         threshold:社区完全失效的阈值
%         nodes_protect:要保护的节点序列，这里默认都是保护第一层中的节点

%输出参数: 
%         node_state_matrix_new:多重网络的节点状态矩阵
%网络中的社区分布
    node_state_matrix_new = node_state_matrix;
    coms=unique(nodes_community);
%网络中的社区数目
    num_com=length(coms);

    for i=1:num_com
        %在同个社区中的节点
        nodes_same_com=find(nodes_community==coms(i));
        if ~isempty(nodes_same_com)
            %计算在多重网络的第1层中的第i个社区中没有失效的节点
            nodes_sum=sum(node_state_matrix(1,nodes_same_com));
            %在多重网络的第1层中的第i个社区中失效的节点大于设定的阈值，则令整个社区进行失效
            %threshold表示的是失效的节点阈值,nodes_sum表示的是没有失效的节点数，所以这里要用1-threshold
            if nodes_sum/length(nodes_same_com)<1-threshold
                %令整个社区进行失效
                node_state_matrix_new(:,nodes_same_com)=0;
                %保护节点
                node_state_matrix_new(:,nodes_protect)=1;
            end%if ends          
       end%if ends
    end%for ends
    %节点保护
    node_state_matrix_new(:,nodes_protect)=1;
end%function ends
