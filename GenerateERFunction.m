function ER_Network = GenerateERFunction(numNod,p)
    %��������:����ER���磬���ҿ˷��ظ�������ͬ��ER���������
    %�������: numNod: ER����Ľڵ�����
    %         p:  ER����ڵ�֮�������ߵĸ���
    %�������: ER_Network:���ɵ�һ��ER����.

%����һ��������ʾ���
Rand_Number_Matrix = rand(numNod,numNod);

%ER����Ԥ����ռ�
ER_Network = zeros(numNod,numNod);

for i = 1:numNod
    for j = i+1 : numNod
        
        if Rand_Number_Matrix(i,j) <= p
            
            ER_Network(i,j)=1;
            ER_Network(j,i)=1;
        end
    end
end

end


