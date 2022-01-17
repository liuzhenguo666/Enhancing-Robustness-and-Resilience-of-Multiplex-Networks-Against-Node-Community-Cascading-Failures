clc
clear
warning off

%开始计时
tic

%相关图片请于“图片包/附件模拟数据图”和“图片包/附件理论图”文件夹下获得

%此程序用以计算论文附件中的 ER-ER 网络的“理论值”曲线，网络A和网络B均为ER网络
%需要设置网络A和网络B的平均度 kA 和 kB，社区功能承受阈值 qc 以及导入生成的对应 ER 网络的节点社区信息
%当社区功能节点数低于 qc 比例后，社区失效，qc值越大,社区越脆弱，与附件参数 lambda 的关系是 qc = 1 - lambda
%当社区失效节点数超过 lambda 比例后，社区失效，lambda值越小，社区越脆弱

%文件中提供了已经生成的 ER-ER 网络(节点数 n=500 )在 kA=kB=4 和 kA=kB=6下的节点社区信息'k4community.mat'和'k6community.mat'
%'k4community.mat'和'k6community.mat'中记录了500个节点分别对应的社区标签

%在“图片包/附件模拟数据图”文件夹下，文件'k4community_qc..'和'k6community_qc..'系列分别为对应的 kA=kB=4 与 kA=kB=6
%下的ER-ER网络使用计算机模拟生成的模拟数据，用以验证理论值，具体数值可从figure中提取
%文件命名包含了相关参数信息，例如'k4community_qc07'表示 kA=kB=4,qc=0.7下的ER-ER 网络模拟结果

%直接运行此程序将会得到两条理论值曲线，一条是NCFs的理论值曲线，另一条是NCCFs的理论值曲线
%如果想和模拟值比对，设置好参数后，打开对应参数的'k4community_qc..'或'k6community_qc..'的figure文件，然后点击运行，理论值图像会叠绘在figure上

%相关 理论值曲线 和 计算机模拟数据 的叠绘图可在“图片包/附件理论图”文件夹下中以'theory'开头的figure文件中找到
%例如文件'theory_k6community_qc05'就是文件'k6community_qc05'和对应参数下两个理论值曲线的叠绘结果图

%如果想设置不同的 kA 和 kB 进行理论计算和模拟结果对照，则需要新生成对应的 ER-ER 网络并提取网络的节点社区信息用以计算理论值曲线
%而对应参数的计算机模拟数据则使用 模拟级联失效过程的程序 生成

%参数设置，kA为网络A的平均度，kB为网络B的平均度,qc为社区失效的临界保有率
kA = 6;
kB = 6;
qc = 0.4;

%导入节点的社区信息
%导入kA = kB = 4时的ER-ER网络的节点社区信息'k4community.mat'
%useless_Matrix = load('k4community.mat', 'nodCom');
%导入kA = kB = 6时的ER-ER网络的节点社区信息'k6community.mat'
useless_Matrix = load('k6community.mat', 'nodCom');
node_Community_Information = useless_Matrix.nodCom;

%获得网络的节点数numberOfNode
[useless ,numberOfNode] = size(node_Community_Information);

%计算当前网络的总社区数量numberOfCommunity
numberOfCommunity = max(node_Community_Information);

%构建矩阵Community_Size存储每个社区拥有的节点数量
Community_Size = zeros(1,numberOfCommunity);

%遍历一次节点的社区信息，为Community_Size赋值
for nodeIndex =1:numberOfNode 
    Community_Size(1,node_Community_Information(1,nodeIndex)) = Community_Size(1,node_Community_Information(1,nodeIndex)) + 1;
end

%获得Community_Size中最大的社区节点数，maxOriginNetworkCommunitySize是原始网络中最大社区的节点数量
maxOriginNetworkCommunitySize = max(Community_Size);

%获得原始网络的社区大小分布,初始化为全0矩阵
Q_originNetworkA = zeros(1,maxOriginNetworkCommunitySize);

%为矩阵Q_originNetworkA赋值
for originNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
    %对每一个特定大小，遍历Community_Size看看有没有社区是那个大小，每有一个就+1
    for communityIndex = 1:numberOfCommunity
        if Community_Size(1,communityIndex) == originNetworkCommunitySizeIndex
            Q_originNetworkA(1,originNetworkCommunitySizeIndex) = Q_originNetworkA(1,originNetworkCommunitySizeIndex) + 1;
        end
    end
end

Q_originNetworkA = Q_originNetworkA / numberOfCommunity;

%新网络社区大小分布,只需要求到第maxNumberOfCommunity个
Q_newNetworkA = zeros(1,maxOriginNetworkCommunitySize);

%sita为一个取0阈值，如果左右相对相差小于sita，那么就认为相等
sita=0.001;

%构造理论保有率矩阵，保有率由0变化到1，numberOfP存储理论保有率的变化数量
p_Matrix = 0:0.0001:1;
[one,numberOfP] = size(p_Matrix);

%构造P_infinite_Matrix矩阵用以存储初始随机攻击1-p部分节点后，巨片比例
P_infinite_Matrix = zeros(1,numberOfP);

%构造giant_component_Matrix矩阵用以存储最终的巨片比例
giant_component_Matrix = zeros(1,numberOfP);

%先计算初始随机攻击1-p部分节点下正常巨片比例变化
for pIndex = 1:numberOfP
    for nonPinfinite = 0:0.001:1
        %让P_infinite从1变化到0搜索碰到的第一个解
        P_infinite = 1 - nonPinfinite;
        
        %构造第一隐式方程的左值leftValue,右值rightValue
        leftValue = P_infinite;
        rightValue = p_Matrix(pIndex) * (1 - exp(-kA * P_infinite) ) * (1 - exp(-kB * P_infinite) );
        
        %如果左值右值的相对差小于sita，认为他们相等，将对应的解P_infinite存储到P_infinite_Matrix里
        if (abs(leftValue - rightValue) / max(leftValue,rightValue)) < sita 
            P_infinite_Matrix(1,pIndex) = P_infinite;
            break; 
        end  
    end
end

%绘制 NCFs 的理论值曲线
temp_P_infinite_Matrix = sort(P_infinite_Matrix,2,'descend');
values = spcrv([[p_Matrix(1) p_Matrix p_Matrix(end)];[temp_P_infinite_Matrix(1) temp_P_infinite_Matrix temp_P_infinite_Matrix(end)]],3);
plot(values(1,:),values(2,:),'-k','linewidth',3);hold on;

%初始化“社区节点”的保有率矩阵r_Matrix，每一个P_infinite都对应一个保有率
r_Matrix = zeros(1,numberOfP);

%设置一个计数器，方便观测程序运行进度
Index = 0;

%构造“社区节点”的保有率矩阵r_Matrix
for pIndex = 1:numberOfP
    %初始化社区的失效概率矩阵（与社区大小有关）community_Failure_Probability
    community_Failure_Probability = zeros(1,maxOriginNetworkCommunitySize);
    
    %利用qc与P_infinite_Matrix构造community_Failure_Probability矩阵
    for originNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize   
        %设置变化上界
        upperBound = originNetworkCommunitySizeIndex * qc;
        for NumberOfRemainingNodesIndex = 1:upperBound    
            temp = nchoosek(originNetworkCommunitySizeIndex,NumberOfRemainingNodesIndex) * power(P_infinite_Matrix(1,pIndex),NumberOfRemainingNodesIndex) * power(1-P_infinite_Matrix(1,pIndex),originNetworkCommunitySizeIndex - NumberOfRemainingNodesIndex);
            community_Failure_Probability(1,originNetworkCommunitySizeIndex) = community_Failure_Probability(1,originNetworkCommunitySizeIndex) + temp; 
        end
    end
    
    %计算sum（Q(m1)*q(m1)）作为中介值intermediary，初始为0
    intermediary = 0;
    for originNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
        intermediary = intermediary + community_Failure_Probability(1,originNetworkCommunitySizeIndex) * Q_originNetworkA(1,originNetworkCommunitySizeIndex);
    end
    
    %计算对应当前P_infinite的“社区节点”保有率r(每一个p对应一个P_infinite，P_infinite与qc对应一个r)
    r_Matrix(1,pIndex) = 1 - intermediary;
end

Temp_Matrix = r_Matrix;

for pIndex = 1:numberOfP
    r_Matrix(1,pIndex) = Temp_Matrix(1,numberOfP + 1 - pIndex); 
end

Temp_Matrix = P_infinite_Matrix;

for pIndex = 1:numberOfP
    P_infinite_Matrix(1,pIndex) = Temp_Matrix(1,numberOfP + 1 - pIndex);
end

testLine = zeros(1,numberOfP);

for pIndex = 1:numberOfP
    testLine(1,pIndex) = r_Matrix(1,pIndex) * P_infinite_Matrix(1,pIndex);
end

%开始计算giant_component_Matrix
for pIndex = 1:numberOfP
    
    %对于每一个p，对应一个P_infinite；每一个P_infinite对应一个新的社区大小分布
    %计算在当前保有率p的情况下，新社区大小的分布,每次开始之前先初始化
    Q_newNetworkA = zeros(1,maxOriginNetworkCommunitySize);
    
    %新网络社区大小newNetworkCommunitySizeIndex
    for newNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
        for originNetworkCommunitySizeIndex = newNetworkCommunitySizeIndex:maxOriginNetworkCommunitySize 
            temp = Q_originNetworkA(1,originNetworkCommunitySizeIndex) * nchoosek(originNetworkCommunitySizeIndex,newNetworkCommunitySizeIndex) * power(P_infinite_Matrix(1,pIndex),newNetworkCommunitySizeIndex) * power(1-P_infinite_Matrix(1,pIndex),originNetworkCommunitySizeIndex - newNetworkCommunitySizeIndex);
            Q_newNetworkA(1,newNetworkCommunitySizeIndex) = Q_newNetworkA(1,newNetworkCommunitySizeIndex) + temp ;
        end
    end
    %测试如果社区大小不变的情况
    %Q_newNetworkA = Q_originNetworkA;
    %计算新网络的社区大小期望E_newCommunitySize
    E_newCommunitySize = 0;
    for newNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
        E_newCommunitySize = E_newCommunitySize + newNetworkCommunitySizeIndex * Q_newNetworkA(1,newNetworkCommunitySizeIndex);
    end
    
    %开始计算这种情况下的巨片比例
    %计算等价的超节点网络中随机去除“社区节点”的比例1-r,即计算保有率r
    r = testLine(1,pIndex) ;
    
    for nonPinfiniteA = 0:0.001:1
        %让PinfiniteA从1向0搜索解
        PinfiniteA = 1 - nonPinfiniteA;
        
        %leftValue为方程左边数值，rightValue为方程右边数值
        leftValue = PinfiniteA;
        I = 0;
        for newNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
            E = exp(-1 * kA * P_infinite_Matrix(1,pIndex) * newNetworkCommunitySizeIndex * PinfiniteA) + exp(-1 * kB * P_infinite_Matrix(1,pIndex) * newNetworkCommunitySizeIndex * PinfiniteA) + exp(-1 * (kA + kB) * P_infinite_Matrix(1,pIndex) * newNetworkCommunitySizeIndex * PinfiniteA);
            I = I + newNetworkCommunitySizeIndex * Q_newNetworkA(1,newNetworkCommunitySizeIndex) * E;
        end
        
        rightValue = r * (1-(I / E_newCommunitySize));
        
        if (abs(leftValue - rightValue) / max(leftValue,rightValue)) < sita
            giant_component_Matrix(1,pIndex) = PinfiniteA  ;
            break;
        end
    end
    
    %让计数器 +1
    Index = Index + 1;
    %输出当前计数，以及总共需要的计数numberOfqc
    fprintf('current Index is : %d.========total number is : %d  \n',Index,numberOfP);
    
end

giant_component_Matrix = sort(giant_component_Matrix,2,'descend');

%toy3的专属部分，利用P无穷和之前的giant_component_Matrix线调整社区失效线
%构造差值矩阵Difference
Difference = zeros(1,numberOfP);
Difference = abs(P_infinite_Matrix - giant_component_Matrix);

%plot(p_Matrix,Difference,'-bo');hold on;
giant_component_Matrix = giant_component_Matrix - Difference;
%消灭负数
for pIndex = 1:numberOfP
    if giant_component_Matrix(1,pIndex) < 0
        giant_component_Matrix(1,pIndex) = 0;
    end
end

%绘制 NCCFs 的理论值曲线
values2 = spcrv([[p_Matrix(1) p_Matrix p_Matrix(end)];[giant_component_Matrix(1) giant_component_Matrix giant_component_Matrix(end)]],5);
plot(values2(1,:),values2(2,:),'-b','linewidth',3);hold on;
set(gca,'linewidth',2);
%如果使用叠绘，则使用下面这行
%legend({'Simulated results(NCFs)','Simulated results(NCCFs)','Theoretical results (NCFs)','Theoretical results (NCCFs)'});

toc

