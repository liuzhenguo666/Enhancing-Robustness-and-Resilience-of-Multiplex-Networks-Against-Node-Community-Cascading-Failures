clc;
clear;
% 计算四个多重网络的攻击/恢复鲁棒性
name{1,1} = 'ER_SF';
name{1,2} = 'ER_SW_SF';
name{1,3} = 'SF_SF';
name{1,4} = 'SW_SF';

% 多重网络的类型
numType = 4;
%节点规模 N
N = 500;
% 画图所用的数据 每一行表示一个网络 每一列表示不同的度 
RAtkMat = zeros(4,9);
% 用于实验的网络个数
numNet =  100;
% numNet =  1;
%开始平均度大小 startDegree
startDegree = 4;
%网络平均度 d 的变化幅度 deltaD
deltaD = 1;
%结束平均度大小 endDegree
endDegree = 4;
%存储度变化的的矩阵
DegreeChange = startDegree:deltaD:endDegree;
%平均度变化数量 numDegree
[~,numDegree] = size(DegreeChange);
% 每一层表示一个网络 每一行表示一个平均度
NodAtkMat = zeros(numDegree,N,numType);
% 社区失效的阈值，当社区失效阈值为1时，等价于不考虑社区结构
threshold = 0.7;
% 要保护的节点,初始为空，如果需要使用节点保护策略，则在此程序中使用SA_protectNode函数或ProtectCritialNodes函数
nodPro = [];

for i = 1 : numType
    % 度的变化
    %设置计数器
    counter = 1;
    for d = startDegree : deltaD : endDegree
        curRAtkSeq = zeros(1,numNet);
        curRAtkMat = zeros(numNet,N);
        for k = 1 : numNet
            fprintf('Current Network is %s, current degree is %d, current network is %d\n',name{1,i},d, k);
            % 1. 导入数据
            %从相应的文件夹中提取多重网络
            curFileName = strcat('Multi/',name{1,i},'/d=',num2str(d),'/',name{1,i},'_500_',num2str(d),'_',num2str(k),'.mat');
            adjMulti =  importdata(curFileName);
            % 2. 进行社区划分
            edgesAll = Adj2EdgesAll(adjMulti);
            %nodCom中提供了节点的社区信息
            [nodCom,Q] = ComDet(edgesAll);
            numCom = max(nodCom);
            % 3. 计算当前保护节点的网络的攻击鲁棒性,无保护节点的情况即 nodPro 为空
            [R,nodSeq] = ComAtkRob(adjMulti,nodCom,threshold,nodPro);
            %计算当前保护节点的网络的恢复鲁棒性,无保护节点的情况即 nodPro 为空
            %[R,nodSeq] = ComRecRob(adjMulti,nodCom,threshold,nodPro);
            % 4. 保存信息
            curRAtkSeq(k) = R;
            curRAtkMat(k,:) = nodSeq;
        end
        RAtkMat(i,counter) = mean(curRAtkSeq);
        NodAtkMat(counter,:,i) = mean(curRAtkMat);
        counter = counter + 1;
        
    end  
end
%可选择将生成结果保存下来
%save('RES_ATK');






