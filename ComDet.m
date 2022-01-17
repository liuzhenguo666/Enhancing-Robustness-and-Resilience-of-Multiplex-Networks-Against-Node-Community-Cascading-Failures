function [nodes_com,Q]=ComDet(edges_all)
%函数功能:社区划分函数，并返回节点的社区信息以及模块度
%输入    :edges_all 网络链接的边表达形式，例如某行[1,2,3,1]表示在第一层网络中，节点2和节点3有一条边，权重为1
%输出    :nodes_com 节点的社区信息，矩阵内容数值为对应序号节点的社区编号
%        Q  模块度
    global V network
    rand('seed',sum(100*clock));  % generate random value
    M=1;
    clu_assignment_real=1:V;
    ADJ_MAT=[]; ADJ_MAT(V,V)=0; network=[];
    edges=[]; Multiplex_edges=[]; degree=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% undirected
    %社区划分提示
    %fprintf('Communities are being divided\n');
    Multilayer_edges=[];
    if min(min(edges_all(:,2)),min(edges_all(:,2)))==0
        for i=1:max(edges_all(:,1))
            pos=[]; pos=find(i==edges_all(:,1));
            Multilayer_edges(i).edges=edges_all(pos,2:3)+1;
            Multilayer_edges(i).edges(:,3)=edges_all(pos,4);
        end

        V=max(max(edges_all(:,2))+1,max(edges_all(:,3))+1);
    else
        for i=1:max(edges_all(:,1))
            pos=[]; pos=find(i==edges_all(:,1));
            Multilayer_edges(i).edges=edges_all(pos,2:3);
            Multilayer_edges(i).edges(:,3)=edges_all(pos,4);
        end
        V=max(max(edges_all(:,2)),max(edges_all(:,3)));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A=cell(length(Multilayer_edges),1); Multilayer_adj_mat=[];
    edges=[];
    for i=1:length(Multilayer_edges)
        edges=[]; edges=Multilayer_edges(i).edges; edges=[edges; [edges(:,2) edges(:,1) edges(:,3)]; V V 0];
        Multilayer_adj_mat(i).adj_org=[]; Multilayer_adj_mat(i).adj_org=sparse(edges(:,1),edges(:,2),edges(:,3));
        A{i,1}=Multilayer_adj_mat(i).adj_org;
        r=0; h=0; [r h]=size([Multilayer_edges(i).edges]);
        network=[network; Multilayer_edges(i).edges(:,1:3) i*ones(r,1)];
    end


    N=length(A{1});
    T=length(A);
    B=spalloc(N*T,N*T,(N+T)*N*T);
    twomu=0;
    gamma=1; omega=1;
    for s=1:T
        k=sum(A{s});
        twom=sum(k);
        twomu=twomu+twom;
        indx=[1:N]+(s-1)*N;
        B(indx,indx)=A{s}-gamma*k'*k/twom;
    end
    twomu=twomu+T*omega*N*(T-1);
    all2all = N*[(-T+1):-1,1:(T-1)];
    B = B + omega*spdiags(ones(N*T,2*T-2),all2all,N*T,N*T);
    [S,Q] = genlouvain(B,0,0,0);
    Q = Q/twomu;
    S = reshape(S,N,T);

    clu_assignment = decode_mod(S(:,1));
    modularity_projection=0; modularity_projection = Multiplex_modularity(network, clu_assignment);
    redundancy_projection=0; redundancy_projection = Redundancy(network, clu_assignment);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nodes_com=clu_assignment;
    Q;
end