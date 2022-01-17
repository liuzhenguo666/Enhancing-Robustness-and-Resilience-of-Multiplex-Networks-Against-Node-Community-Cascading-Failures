clc;
clear;
% �����ĸ���������Ĺ���/�ָ�³����
name{1,1} = 'ER_SF';
name{1,2} = 'ER_SW_SF';
name{1,3} = 'SF_SF';
name{1,4} = 'SW_SF';

% �������������
numType = 4;
%�ڵ��ģ N
N = 500;
% ��ͼ���õ����� ÿһ�б�ʾһ������ ÿһ�б�ʾ��ͬ�Ķ� 
RAtkMat = zeros(4,9);
% ����ʵ����������
numNet =  100;
% numNet =  1;
%��ʼƽ���ȴ�С startDegree
startDegree = 4;
%����ƽ���� d �ı仯���� deltaD
deltaD = 1;
%����ƽ���ȴ�С endDegree
endDegree = 4;
%�洢�ȱ仯�ĵľ���
DegreeChange = startDegree:deltaD:endDegree;
%ƽ���ȱ仯���� numDegree
[~,numDegree] = size(DegreeChange);
% ÿһ���ʾһ������ ÿһ�б�ʾһ��ƽ����
NodAtkMat = zeros(numDegree,N,numType);
% ����ʧЧ����ֵ��������ʧЧ��ֵΪ1ʱ���ȼ��ڲ����������ṹ
threshold = 0.7;
% Ҫ�����Ľڵ�,��ʼΪ�գ������Ҫʹ�ýڵ㱣�����ԣ����ڴ˳�����ʹ��SA_protectNode������ProtectCritialNodes����
nodPro = [];

for i = 1 : numType
    % �ȵı仯
    %���ü�����
    counter = 1;
    for d = startDegree : deltaD : endDegree
        curRAtkSeq = zeros(1,numNet);
        curRAtkMat = zeros(numNet,N);
        for k = 1 : numNet
            fprintf('Current Network is %s, current degree is %d, current network is %d\n',name{1,i},d, k);
            % 1. ��������
            %����Ӧ���ļ�������ȡ��������
            curFileName = strcat('Multi/',name{1,i},'/d=',num2str(d),'/',name{1,i},'_500_',num2str(d),'_',num2str(k),'.mat');
            adjMulti =  importdata(curFileName);
            % 2. ������������
            edgesAll = Adj2EdgesAll(adjMulti);
            %nodCom���ṩ�˽ڵ��������Ϣ
            [nodCom,Q] = ComDet(edgesAll);
            numCom = max(nodCom);
            % 3. ���㵱ǰ�����ڵ������Ĺ���³����,�ޱ����ڵ������� nodPro Ϊ��
            [R,nodSeq] = ComAtkRob(adjMulti,nodCom,threshold,nodPro);
            %���㵱ǰ�����ڵ������Ļָ�³����,�ޱ����ڵ������� nodPro Ϊ��
            %[R,nodSeq] = ComRecRob(adjMulti,nodCom,threshold,nodPro);
            % 4. ������Ϣ
            curRAtkSeq(k) = R;
            curRAtkMat(k,:) = nodSeq;
        end
        RAtkMat(i,counter) = mean(curRAtkSeq);
        NodAtkMat(counter,:,i) = mean(curRAtkMat);
        counter = counter + 1;
        
    end  
end
%��ѡ�����ɽ����������
%save('RES_ATK');






