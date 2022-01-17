function [R,nodSeq] = ComAtkRob(adjMulti,nodCom,threshold,nodPro)
    %��������:������������³����R
    %�������: adjMulti: n��n��layers,����������ڽӾ���,�Ǹ���ά����,n�Ƕ�������Ľڵ���,layers�Ƕ�������Ĳ���
    %         nodCom:  �ڵ�������ֲ�,��[1,1,1,2]��ʾ�ڵ�1��2��3��������1���ڵ�4��������2.
    %         threshold: ������ȫʧЧ����ֵ,[0,1],�ڱ�ʵ����ȡ0.7.��Ϊ1ʱ���ȼ��ڲ���������ʧЧ
    %         nodPro:   Ҫ�����Ľڵ�����,1��numCom.
    %�������: R:����õ��Ķ�������Ĺ���³����,�����ϵ����ֵ��0.5.
    %         nodSeq: 1��numNode,ÿ�ι������������ͨͼ�еĽڵ����.
    [numNod,numNod,numLayer] = size(adjMulti);
    nodSeq = zeros(1,numNod);
    adjMultiTmp = adjMulti;
    nodStateMat = ones(numNod,numNod);
    %��������Ľڵ�����
    nodAtkSeq = randperm(numNod);
    for i = 1 : numNod
        %�����ʾ��Ϣ
        %fprintf('Current Network is ER_ER, current node is %d\n', i);
        % ��ǰ�����ڵ�
        nodAtkCur = nodAtkSeq(i);
        % ��ǰ�����ڵ��ڱ����ڵ�������
        if ismember(nodAtkCur,nodPro)== 1 && i > 1
            nodSeq(i) = nodSeq(i-1);
        else
             [adjMultiTmp,nodStateMat] = AtkNetWithCom(adjMultiTmp,nodCom,nodAtkCur,threshold,nodPro);
             nodSeq(i) = sum(nodStateMat(1,:));
        end
    end
    nodSeq = nodSeq / numNod;
    R = sum(nodSeq) / numNod;
end%function ends