clc
clear
warning off

%��ʼ��ʱ
tic

%���ͼƬ���ڡ�ͼƬ��/����ģ������ͼ���͡�ͼƬ��/��������ͼ���ļ����»��

%�˳������Լ������ĸ����е� ER-ER ����ġ�����ֵ�����ߣ�����A������B��ΪER����
%��Ҫ��������A������B��ƽ���� kA �� kB���������ܳ�����ֵ qc �Լ��������ɵĶ�Ӧ ER ����Ľڵ�������Ϣ
%���������ܽڵ������� qc ����������ʧЧ��qcֵԽ��,����Խ�������븽������ lambda �Ĺ�ϵ�� qc = 1 - lambda
%������ʧЧ�ڵ������� lambda ����������ʧЧ��lambdaֵԽС������Խ����

%�ļ����ṩ���Ѿ����ɵ� ER-ER ����(�ڵ��� n=500 )�� kA=kB=4 �� kA=kB=6�µĽڵ�������Ϣ'k4community.mat'��'k6community.mat'
%'k4community.mat'��'k6community.mat'�м�¼��500���ڵ�ֱ��Ӧ��������ǩ

%�ڡ�ͼƬ��/����ģ������ͼ���ļ����£��ļ�'k4community_qc..'��'k6community_qc..'ϵ�зֱ�Ϊ��Ӧ�� kA=kB=4 �� kA=kB=6
%�µ�ER-ER����ʹ�ü����ģ�����ɵ�ģ�����ݣ�������֤����ֵ��������ֵ�ɴ�figure����ȡ
%�ļ�������������ز�����Ϣ������'k4community_qc07'��ʾ kA=kB=4,qc=0.7�µ�ER-ER ����ģ����

%ֱ�����д˳��򽫻�õ���������ֵ���ߣ�һ����NCFs������ֵ���ߣ���һ����NCCFs������ֵ����
%������ģ��ֵ�ȶԣ����úò����󣬴򿪶�Ӧ������'k4community_qc..'��'k6community_qc..'��figure�ļ���Ȼ�������У�����ֵͼ��������figure��

%��� ����ֵ���� �� �����ģ������ �ĵ���ͼ���ڡ�ͼƬ��/��������ͼ���ļ���������'theory'��ͷ��figure�ļ����ҵ�
%�����ļ�'theory_k6community_qc05'�����ļ�'k6community_qc05'�Ͷ�Ӧ��������������ֵ���ߵĵ�����ͼ

%��������ò�ͬ�� kA �� kB �������ۼ����ģ�������գ�����Ҫ�����ɶ�Ӧ�� ER-ER ���粢��ȡ����Ľڵ�������Ϣ���Լ�������ֵ����
%����Ӧ�����ļ����ģ��������ʹ�� ģ�⼶��ʧЧ���̵ĳ��� ����

%�������ã�kAΪ����A��ƽ���ȣ�kBΪ����B��ƽ����,qcΪ����ʧЧ���ٽ籣����
kA = 6;
kB = 6;
qc = 0.4;

%����ڵ��������Ϣ
%����kA = kB = 4ʱ��ER-ER����Ľڵ�������Ϣ'k4community.mat'
%useless_Matrix = load('k4community.mat', 'nodCom');
%����kA = kB = 6ʱ��ER-ER����Ľڵ�������Ϣ'k6community.mat'
useless_Matrix = load('k6community.mat', 'nodCom');
node_Community_Information = useless_Matrix.nodCom;

%�������Ľڵ���numberOfNode
[useless ,numberOfNode] = size(node_Community_Information);

%���㵱ǰ���������������numberOfCommunity
numberOfCommunity = max(node_Community_Information);

%��������Community_Size�洢ÿ������ӵ�еĽڵ�����
Community_Size = zeros(1,numberOfCommunity);

%����һ�νڵ��������Ϣ��ΪCommunity_Size��ֵ
for nodeIndex =1:numberOfNode 
    Community_Size(1,node_Community_Information(1,nodeIndex)) = Community_Size(1,node_Community_Information(1,nodeIndex)) + 1;
end

%���Community_Size�����������ڵ�����maxOriginNetworkCommunitySize��ԭʼ��������������Ľڵ�����
maxOriginNetworkCommunitySize = max(Community_Size);

%���ԭʼ�����������С�ֲ�,��ʼ��Ϊȫ0����
Q_originNetworkA = zeros(1,maxOriginNetworkCommunitySize);

%Ϊ����Q_originNetworkA��ֵ
for originNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
    %��ÿһ���ض���С������Community_Size������û���������Ǹ���С��ÿ��һ����+1
    for communityIndex = 1:numberOfCommunity
        if Community_Size(1,communityIndex) == originNetworkCommunitySizeIndex
            Q_originNetworkA(1,originNetworkCommunitySizeIndex) = Q_originNetworkA(1,originNetworkCommunitySizeIndex) + 1;
        end
    end
end

Q_originNetworkA = Q_originNetworkA / numberOfCommunity;

%������������С�ֲ�,ֻ��Ҫ�󵽵�maxNumberOfCommunity��
Q_newNetworkA = zeros(1,maxOriginNetworkCommunitySize);

%sitaΪһ��ȡ0��ֵ���������������С��sita����ô����Ϊ���
sita=0.001;

%�������۱����ʾ��󣬱�������0�仯��1��numberOfP�洢���۱����ʵı仯����
p_Matrix = 0:0.0001:1;
[one,numberOfP] = size(p_Matrix);

%����P_infinite_Matrix�������Դ洢��ʼ�������1-p���ֽڵ�󣬾�Ƭ����
P_infinite_Matrix = zeros(1,numberOfP);

%����giant_component_Matrix�������Դ洢���յľ�Ƭ����
giant_component_Matrix = zeros(1,numberOfP);

%�ȼ����ʼ�������1-p���ֽڵ���������Ƭ�����仯
for pIndex = 1:numberOfP
    for nonPinfinite = 0:0.001:1
        %��P_infinite��1�仯��0���������ĵ�һ����
        P_infinite = 1 - nonPinfinite;
        
        %�����һ��ʽ���̵���ֵleftValue,��ֵrightValue
        leftValue = P_infinite;
        rightValue = p_Matrix(pIndex) * (1 - exp(-kA * P_infinite) ) * (1 - exp(-kB * P_infinite) );
        
        %�����ֵ��ֵ����Բ�С��sita����Ϊ������ȣ�����Ӧ�Ľ�P_infinite�洢��P_infinite_Matrix��
        if (abs(leftValue - rightValue) / max(leftValue,rightValue)) < sita 
            P_infinite_Matrix(1,pIndex) = P_infinite;
            break; 
        end  
    end
end

%���� NCFs ������ֵ����
temp_P_infinite_Matrix = sort(P_infinite_Matrix,2,'descend');
values = spcrv([[p_Matrix(1) p_Matrix p_Matrix(end)];[temp_P_infinite_Matrix(1) temp_P_infinite_Matrix temp_P_infinite_Matrix(end)]],3);
plot(values(1,:),values(2,:),'-k','linewidth',3);hold on;

%��ʼ���������ڵ㡱�ı����ʾ���r_Matrix��ÿһ��P_infinite����Ӧһ��������
r_Matrix = zeros(1,numberOfP);

%����һ��������������۲�������н���
Index = 0;

%���조�����ڵ㡱�ı����ʾ���r_Matrix
for pIndex = 1:numberOfP
    %��ʼ��������ʧЧ���ʾ�����������С�йأ�community_Failure_Probability
    community_Failure_Probability = zeros(1,maxOriginNetworkCommunitySize);
    
    %����qc��P_infinite_Matrix����community_Failure_Probability����
    for originNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize   
        %���ñ仯�Ͻ�
        upperBound = originNetworkCommunitySizeIndex * qc;
        for NumberOfRemainingNodesIndex = 1:upperBound    
            temp = nchoosek(originNetworkCommunitySizeIndex,NumberOfRemainingNodesIndex) * power(P_infinite_Matrix(1,pIndex),NumberOfRemainingNodesIndex) * power(1-P_infinite_Matrix(1,pIndex),originNetworkCommunitySizeIndex - NumberOfRemainingNodesIndex);
            community_Failure_Probability(1,originNetworkCommunitySizeIndex) = community_Failure_Probability(1,originNetworkCommunitySizeIndex) + temp; 
        end
    end
    
    %����sum��Q(m1)*q(m1)����Ϊ�н�ֵintermediary����ʼΪ0
    intermediary = 0;
    for originNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
        intermediary = intermediary + community_Failure_Probability(1,originNetworkCommunitySizeIndex) * Q_originNetworkA(1,originNetworkCommunitySizeIndex);
    end
    
    %�����Ӧ��ǰP_infinite�ġ������ڵ㡱������r(ÿһ��p��Ӧһ��P_infinite��P_infinite��qc��Ӧһ��r)
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

%��ʼ����giant_component_Matrix
for pIndex = 1:numberOfP
    
    %����ÿһ��p����Ӧһ��P_infinite��ÿһ��P_infinite��Ӧһ���µ�������С�ֲ�
    %�����ڵ�ǰ������p������£���������С�ķֲ�,ÿ�ο�ʼ֮ǰ�ȳ�ʼ��
    Q_newNetworkA = zeros(1,maxOriginNetworkCommunitySize);
    
    %������������СnewNetworkCommunitySizeIndex
    for newNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
        for originNetworkCommunitySizeIndex = newNetworkCommunitySizeIndex:maxOriginNetworkCommunitySize 
            temp = Q_originNetworkA(1,originNetworkCommunitySizeIndex) * nchoosek(originNetworkCommunitySizeIndex,newNetworkCommunitySizeIndex) * power(P_infinite_Matrix(1,pIndex),newNetworkCommunitySizeIndex) * power(1-P_infinite_Matrix(1,pIndex),originNetworkCommunitySizeIndex - newNetworkCommunitySizeIndex);
            Q_newNetworkA(1,newNetworkCommunitySizeIndex) = Q_newNetworkA(1,newNetworkCommunitySizeIndex) + temp ;
        end
    end
    %�������������С��������
    %Q_newNetworkA = Q_originNetworkA;
    %�����������������С����E_newCommunitySize
    E_newCommunitySize = 0;
    for newNetworkCommunitySizeIndex = 1:maxOriginNetworkCommunitySize
        E_newCommunitySize = E_newCommunitySize + newNetworkCommunitySizeIndex * Q_newNetworkA(1,newNetworkCommunitySizeIndex);
    end
    
    %��ʼ������������µľ�Ƭ����
    %����ȼ۵ĳ��ڵ����������ȥ���������ڵ㡱�ı���1-r,�����㱣����r
    r = testLine(1,pIndex) ;
    
    for nonPinfiniteA = 0:0.001:1
        %��PinfiniteA��1��0������
        PinfiniteA = 1 - nonPinfiniteA;
        
        %leftValueΪ���������ֵ��rightValueΪ�����ұ���ֵ
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
    
    %�ü����� +1
    Index = Index + 1;
    %�����ǰ�������Լ��ܹ���Ҫ�ļ���numberOfqc
    fprintf('current Index is : %d.========total number is : %d  \n',Index,numberOfP);
    
end

giant_component_Matrix = sort(giant_component_Matrix,2,'descend');

%toy3��ר�����֣�����P�����֮ǰ��giant_component_Matrix�ߵ�������ʧЧ��
%�����ֵ����Difference
Difference = zeros(1,numberOfP);
Difference = abs(P_infinite_Matrix - giant_component_Matrix);

%plot(p_Matrix,Difference,'-bo');hold on;
giant_component_Matrix = giant_component_Matrix - Difference;
%������
for pIndex = 1:numberOfP
    if giant_component_Matrix(1,pIndex) < 0
        giant_component_Matrix(1,pIndex) = 0;
    end
end

%���� NCCFs ������ֵ����
values2 = spcrv([[p_Matrix(1) p_Matrix p_Matrix(end)];[giant_component_Matrix(1) giant_component_Matrix giant_component_Matrix(end)]],5);
plot(values2(1,:),values2(2,:),'-b','linewidth',3);hold on;
set(gca,'linewidth',2);
%���ʹ�õ��棬��ʹ����������
%legend({'Simulated results(NCFs)','Simulated results(NCCFs)','Theoretical results (NCFs)','Theoretical results (NCCFs)'});

toc

