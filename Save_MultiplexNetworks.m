% ���ɶ�������
%�˳����������ɶ������磬˼·�����ѡ��֮ǰ���ɵĵ�������ƴ�ӳɶ������磬Ȼ�������ɵĶ�������洢�� path ������·����
%�ļ��С�Multi�����Դ洢���ɵĶ�������
%ע�⣬��ͬ���͵�������ϳ�ʱ������ͬ�ļ�����ȡ����������Ҫ�������ȡ����ϳ�SF-SF��ER-ER����ʱ
%��Ҫ����3�㡢4�����������Ķ�������ֻ��Ҫ������������е��߼���д��������Ӧ���ļ��м���
clc;
clear;
%��������ͬ���������ɵ��������� numNet
numNet = 100;
% numNet = 1;
%���ýڵ�����
numNod = 500;
%���ò���
numLayer = 2;
%%  ER-SF
%�����ƽ���ȱ仯 d
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
        
        %��ͬ���͵�������ϳ�ʱ������ͬ�ļ�����ȡ����������Ҫ�������ȡ
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
        
        %��ͬ���͵�������ϳ�ʱ������ͬ�ļ�����ȡ����������Ҫ�������ȡ
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


