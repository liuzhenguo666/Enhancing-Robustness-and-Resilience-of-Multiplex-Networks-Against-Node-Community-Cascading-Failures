clc;
clear;
% Generate Small World Network
%此程序将生成的单层 SW 网络保存在 path 名字下的文件夹中，可根据需要修改path
%生成的单层 SW 网络可用于合成 多重网络

% 平均度为 2*K
K = 4;
beta = 0.3;

%N = 200;
%生成规模为200的Single Small World Network
%for k = 1 : 30
%    name =  strcat('SW_200_',num2str(k));
%    h = WattsStrogatz(N,K,beta);
%    edges = table2array(h.Edges);
%    adj = sparse(200,200);
%    for i = 1 : length(edges)
%        adj(edges(i,1),edges(i,2)) = 1;
%        adj(edges(i,2),edges(i,1)) = 1;
%    end
%    path = strcat('Single/SW/n=200','/','SW_200_',num2str(k),'.mat');
%    save(path,'adj');
%end

N = 500;
%生成规模为500的Single Small World Network
for k = 1 : 100
    %name =  strcat('SW_500_',num2str(k));
    h = WattsStrogatz(N,K,beta);
    edges = table2array(h.Edges);
    adj = sparse(500,500);
    for i = 1 : length(edges)
        adj(edges(i,1),edges(i,2)) = 1;
        adj(edges(i,2),edges(i,1)) = 1;
    end
    path = strcat('Single/SW/n=500','/','SW_500_',num2str(k),'.mat');
    save(path,'adj');
end


       