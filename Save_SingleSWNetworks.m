clc;
clear;
% Generate Small World Network
%�˳������ɵĵ��� SW ���籣���� path �����µ��ļ����У��ɸ�����Ҫ�޸�path
%���ɵĵ��� SW ��������ںϳ� ��������

% ƽ����Ϊ 2*K
K = 4;
beta = 0.3;

%N = 200;
%���ɹ�ģΪ200��Single Small World Network
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
%���ɹ�ģΪ500��Single Small World Network
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


       