% 生成多重网络
%此程序用以生成多重网络，思路是随机选择之前生成的单层网络拼接成多重网络，然后将新生成的多重网络存储在 path 命名的路径下
%文件夹“Multi”用以存储生成的多重网络
%注意，相同类型单层网络合成时，从相同文件夹下取单层网络需要随机化抽取，如合成SF-SF，ER-ER网络时
%需要生成3层、4层甚至更多层的多重网络只需要按照下面程序中的逻辑编写，建好相应的文件夹即可
clc;
clear;
%设置在相同参数下生成的网络数量 numNet
numNet = 100;
% numNet = 1;
%设置节点数量
numNod = 500;
%设置层数
numLayer = 2;
%%  ER-SF
%网络的平均度变化 d
for d =  4 : 1 : 4
    
    for i = 1 : numNet
        
        adjMulti =  zeros(numNod,numNod,numLayer);
        
        filePath1 =  strcat('Single/ER/d=',num2str(d),'/','ER_500_',num2str(d),'_',num2str(i),'.mat');
        filePath2 =  strcat('Single/SF/d=',num2str(d),'/','SF_500_',num2str(d),'_',num2str(i),'.mat');
        
        adj1 = importdata(filePath1);
        adj2 = importdata(filePath2);
        
        adj1 = full(adj1);
        adj2 = full(adj2);
        
        adjMult(:,:,1) = adj1;
        adjMult(:,:,2) = adj2;
        
        path = strcat('Multi/ER_SF/d=',num2str(d),'/','ER_SF_500_',num2str(d),'_',num2str(i),'.mat');
        save(path,'adjMult');
    end
end

%% ER-SW-SF
for d =  4 : 1 : 4
    
    for i = 1 : numNet
        
        adjMulti =  zeros(numNod,numNod,numLayer);
        
        filePath1 =  strcat('Single/ER/d=',num2str(d),'/','ER_500_',num2str(d),'_',num2str(i),'.mat');
        filePath2 =  strcat('Single/SW/d=',num2str(d),'/','SW_500_',num2str(d),'_',num2str(i),'.mat');
        filePath3 =  strcat('Single/SF/d=',num2str(d),'/','SF_500_',num2str(d),'_',num2str(i),'.mat');
        
        adj1 = importdata(filePath1);
        adj2 = importdata(filePath2);
        adj3 = importdata(filePath3);
        
        adj1 = full(adj1);
        adj2 = full(adj2);
        adj3 = full(adj3);
        
        adjMult(:,:,1) = adj1;
        adjMult(:,:,2) = adj2;
        adjMult(:,:,3) = adj3;
        
        path = strcat('Multi/ER_SW_SF/d=',num2str(d),'/','ER_SW_SF_500_',num2str(d),'_',num2str(i),'.mat');
        save(path,'adjMult');
    end
    
end


%% SF-SF
for d =  4 : 1 : 4
    
    for i = 1 : numNet
        
        adjMulti =  zeros(numNod,numNod,numLayer);
        
        %相同类型单层网络合成时，从相同文件夹下取单层网络需要随机化抽取
        randVal1 =  ceil(100 * rand());
        randVal2 =  ceil(100 * rand());
        
        filePath1 =  strcat('Single/SF/d=',num2str(d),'/','SF_500_',num2str(d),'_',num2str(randVal1),'.mat');
        filePath2 =  strcat('Single/SF/d=',num2str(d),'/','SF_500_',num2str(d),'_',num2str(randVal2),'.mat');
        
        adj1 = importdata(filePath1);
        adj2 = importdata(filePath2);
        
        adj1 = full(adj1);
        adj2 = full(adj2);
        
        adjMult(:,:,1) = adj1;
        adjMult(:,:,2) = adj2;
        
        path = strcat('Multi/SF_SF/d=',num2str(d),'/','SF_SF_500_',num2str(d),'_',num2str(i),'.mat');
        save(path,'adjMult');
    end
    
end
%% SW-SF
for d =  4 : 1 : 4
    
    for i = 1 : numNet
        
        adjMulti =  zeros(numNod,numNod,numLayer);

        filePath1 =  strcat('Single/SW/d=',num2str(d),'/','SW_500_',num2str(d),'_',num2str(i),'.mat');
        filePath2 =  strcat('Single/SF/d=',num2str(d),'/','SF_500_',num2str(d),'_',num2str(i),'.mat');
        
        adj1 = importdata(filePath1);
        adj2 = importdata(filePath2);
        
        adj1 = full(adj1);
        adj2 = full(adj2);
        
        adjMult(:,:,1) = adj1;
        adjMult(:,:,2) = adj2;
        
        path = strcat('Multi/SW_SF/d=',num2str(d),'/','SW_SF_500_',num2str(d),'_',num2str(i),'.mat');
        save(path,'adjMult');
    end
    
end

%% ER-ER
for d =  4 : 1 : 4
    
    for i = 1 : numNet
        
        adjMulti =  zeros(numNod,numNod,numLayer);
        
        %相同类型单层网络合成时，从相同文件夹下取单层网络需要随机化抽取
        randVal1 =  ceil(100 * rand());
        randVal2 =  ceil(100 * rand());
        
        filePath1 =  strcat('Single/ER/d=',num2str(d),'/','ER_500_',num2str(d),'_',num2str(randVal1),'.mat');
        filePath2 =  strcat('Single/ER/d=',num2str(d),'/','ER_500_',num2str(d),'_',num2str(randVal2),'.mat');
        
        adj1 = importdata(filePath1);
        adj2 = importdata(filePath2);
        
        adj1 = full(adj1);
        adj2 = full(adj2);
        
        adjMult(:,:,1) = adj1;
        adjMult(:,:,2) = adj2;
        
        path = strcat('Multi/ER_ER/d=',num2str(d),'/','ER_ER_500_',num2str(d),'_',num2str(i),'.mat');
        save(path,'adjMult');
    end
    
end


