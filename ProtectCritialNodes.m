function [Auto_A, Auto_B, seq] = ProtectCritialNodes(A, B, Label)
%A 
%B
%程序使用最新日期：2020.12.22
%Label: 
N1=length(A);
N2=length(B);
alphaA=0.05;                               %the ratio of autonomous nodes in A
alphaB=0.05;                                %the ratio of autonomous nodes in A
switch Label
    case 1 %random   
       Auto_A=zeros(1,N1); seq=[]; seq=randperm(N1); Auto_A(seq(1:N1*alphaA))=1;   seq=seq';   %the autonomous nodes in A  
       Auto_B=zeros(1,N2); seq1=[]; seq1=randperm(N2); Auto_B(seq1(1:N2*alphaB))=1;     %the autonomous nodes in B
       
    case 2 %degree
       Auto_A=zeros(1,N1); seq=[]; D=[]; D=sum(A); [cc seq]=sort(D,'descend'); Auto_A(seq(1:N1*alphaA))=1; seq=seq';                     
       Auto_B=zeros(1,N2); seq1=[]; D=[]; D=sum(B); [cc seq1]=sort(D,'descend'); Auto_B(seq1(1:N2*alphaB))=1;
       
    case 3 %Betweeness
       Auto_A=zeros(1,N1); seq=[]; D=[]; A=sparse(A); D = betweenness_centrality(A);[cc seq]=sort(D,'descend'); Auto_A(seq(1:N1*alphaA))=1; 
       Auto_B=zeros(1,N1); seq1=[]; D=[]; B=sparse(B); D = betweenness_centrality(B);[cc seq1]=sort(D,'descend'); Auto_B(seq1(1:N2*alphaB))=1;
       
    case 4 %LeaderPlosone
       Auto_A=zeros(1,N1); seq=[]; D=[];  D = LeadersPlosone(A); seq=D(:,1); Auto_A(seq(1:N1*alphaA))=1; 
       Auto_B=zeros(1,N1); seq1=[]; D=[];  D = LeadersPlosone(B); seq1=D(:,1); Auto_B(seq1(1:N2*alphaB))=1;
       
   case 5 %Local centrity Physical A Identifying influential nodes in complex networks
       Auto_A=zeros(1,N1); seq=[]; D=[];  D = LocalCentrality(A); [cc seq]=sort(D,'descend'); Auto_A(seq(1:N1*alphaA))=1; seq=seq';
       Auto_B=zeros(1,N1); seq1=[]; D=[];  D = LocalCentrality(B); [cc seq1]=sort(D,'descend'); Auto_B(seq1(1:N2*alphaB))=1;
       
    case 6 %PageRank
       Auto_A=zeros(1,N1); seq=[]; D=[];  D = PageRank(A); [cc seq]=sort(D,'descend'); Auto_A(seq(1:N1*alphaA))=1; 
       Auto_B=zeros(1,N1); seq1=[]; D=[];  D = PageRank(B); [cc seq1]=sort(D,'descend'); Auto_B(seq1(1:N2*alphaB))=1;
       
       
    otherwise
    disp(sprintf('please set the value of Label from 1 to 6'));
    return;
end
end

        
