% ����SF����
clc;
clear;
%N = 500;         % �ڵ���Ϊ500
%���ýڵ����� N
N = 200;
%��������ͬ���������ɵĵ��� SF ��������
numNet = 100;
% numNet = 1;
% Alpha = -2.9;    %  �ȴ�ԼΪ2
% Alpha = -2.3;    %  �ȴ�ԼΪ4
% Alpha = -2.084;  %  �ȴ�ԼΪ6
% Alpha = -1.957;  %  �ȴ�ԼΪ8.5
% Alpha = -1.81;
% Alpha = -1.8;    %  �ȴ�ԼΪ10
% Alpha = -1.7;
% Alpha = -1.6;    %  �ȴ�ԼΪ12
% Alpha = -1.58;    

%ע�⣬��ͬ�� Alpha �����£�matlab�⺯�����ɵ� SF ������ܺ����õĽڵ��� N �в�࣬����֮��ǵ�Ҫ��֤�����ģ
%Alpha = -1.59465;   
Alpha = -2.2;
% Alpha = -1.5;    %  �ȴ�ԼΪ14
% Alpha = -1.42;   %  �ȴ�ԼΪ16
% Alpha = -1.35;   %  �ȴ�ԼΪ18

for i = 1 : numNet
    %��ӡ������Ϣ
    %fprintf('Current Network is %d\n',i);
    
    XAxis  = unique(round(logspace(0,log10(N),25)));
    YAxis  = unique(round(logspace(0,log10(N),25))).^(Alpha+1);
    %YAxis  = unique(round(logspace(0,log10(N),25)));
    Graph = mexGraphCreateRandomGraph(N,XAxis,YAxis,1);
    
    adj = sparse(Graph.Data(:,1),Graph.Data(:,2),Graph.Data(:,3));
    %����ѡ���adj���еȼ۱仯ȷ�����ɵ� SF �����ǲ�ͬ��
    adj = MatrixEquivalentTransformationFunction(adj);
    %���Ը�����Ҫ�޸� path ���ƽ��Զ�������ĵ��� SF ����洢����Ӧ path ·����
    path = strcat('Single/SF/n=200/SF_200_',num2str(i),'.mat');
    
    
%     path = strcat('SF_500_2_',num2str(i),'.mat');
%     path = strcat('SF/d=4/SF_500_4_',num2str(i),'.mat');
%       path = strcat('SF/d=6/SF_500_6_',num2str(i),'.mat');
%     path = strcat('SF/d=10/SF_500_10_',num2str(i),'.mat');
%    path = strcat('SF/d=12/SF_500_12_',num2str(i),'.mat');
%     path = strcat('SF/d=14/SF_500_14_',num2str(i),'.mat');
%      path = strcat('Single/SF/n=500_layer=1/SF_500_',num2str(i),'.mat');
%       path = strcat('SF/d=18/SF_500_18_',num2str(i),'.mat');
%     path = strcat('SF/Test/SF_500_',num2str(i),'.mat');
    save(path,'adj');
end



