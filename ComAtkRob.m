function [R,nodSeq] = ComAtkRob(adjMulti,nodCom,threshold,nodPro)
    %函数功能:计算多重网络的鲁棒性R
    %输入参数: adjMulti: n×n×layers,多重网络的邻接矩阵,是个三维数组,n是多重网络的节点数,layers是多重网络的层数
    %         nodCom:  节点的社区分布,如[1,1,1,2]表示节点1，2，3属于社区1，节点4属于社区2.
    %         threshold: 社区完全失效的阈值,[0,1],在本实验中取0.7.当为1时，等价于不考虑社区失效
    %         nodPro:   要保护的节点序列,1×numCom.
    %输出参数: R:计算得到的多重网络的攻击鲁棒性,理论上的最大值是0.5.
    %         nodSeq: 1×numNode,每次攻击后在最大连通图中的节点比例.
    [numNod,numNod,numLayer] = size(adjMulti);
    nodSeq = zeros(1,numNod);
    adjMultiTmp = adjMulti;
    nodStateMat = ones(numNod,numNod);
    %随机攻击的节点序列
    nodAtkSeq = randperm(numNod);
    for i = 1 : numNod
        %输出提示信息
        %fprintf('Current Network is ER_ER, current node is %d\n', i);
        % 当前攻击节点
        nodAtkCur = nodAtkSeq(i);
        % 当前攻击节点在保护节点序列中
        if ismember(nodAtkCur,nodPro)== 1 && i > 1
            nodSeq(i) = nodSeq(i-1);
        else
             [adjMultiTmp,nodStateMat] = AtkNetWithCom(adjMultiTmp,nodCom,nodAtkCur,threshold,nodPro);
             nodSeq(i) = sum(nodStateMat(1,:));
        end
    end
    nodSeq = nodSeq / numNod;
    R = sum(nodSeq) / numNod;
end%function ends