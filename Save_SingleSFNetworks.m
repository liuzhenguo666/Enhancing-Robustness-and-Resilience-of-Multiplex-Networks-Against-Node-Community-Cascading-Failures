% 生成SF网络
clc;
clear;
%N = 500;         % 节点数为500
%设置节点数量 N
N = 200;
%设置在相同参数下生成的单层 SF 网络数量
numNet = 100;
% numNet = 1;
% Alpha = -2.9;    %  度大约为2
% Alpha = -2.3;    %  度大约为4
% Alpha = -2.084;  %  度大约为6
% Alpha = -1.957;  %  度大约为8.5
% Alpha = -1.81;
% Alpha = -1.8;    %  度大约为10
% Alpha = -1.7;
% Alpha = -1.6;    %  度大约为12
% Alpha = -1.58;    

%注意，不同的 Alpha 设置下，matlab库函数生成的 SF 网络可能和设置的节点数 N 有差距，生成之后记得要验证网络规模
%Alpha = -1.59465;   
Alpha = -2.2;
% Alpha = -1.5;    %  度大约为14
% Alpha = -1.42;   %  度大约为16
% Alpha = -1.35;   %  度大约为18

for i = 1 : numNet
    %打印进度信息
    %fprintf('Current Network is %d\n',i);
    
    XAxis  = unique(round(logspace(0,log10(N),25)));
    YAxis  = unique(round(logspace(0,log10(N),25))).^(Alpha+1);
    %YAxis  = unique(round(logspace(0,log10(N),25)));
    Graph = mexGraphCreateRandomGraph(N,XAxis,YAxis,1);
    
    adj = sparse(Graph.Data(:,1),Graph.Data(:,2),Graph.Data(:,3));
    %可以选择对adj进行等价变化确保生成的 SF 网络是不同的
    adj = MatrixEquivalentTransformationFunction(adj);
    %可以根据需要修改 path 名称将自定义参数的单层 SF 网络存储在相应 path 路径下
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



