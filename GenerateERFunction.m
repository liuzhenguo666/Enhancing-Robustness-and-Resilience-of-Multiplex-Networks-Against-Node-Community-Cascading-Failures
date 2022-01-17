function ER_Network = GenerateERFunction(numNod,p)
    %函数功能:生成ER网络，并且克服重复生成相同的ER网络的困难
    %输入参数: numNod: ER网络的节点数量
    %         p:  ER网络节点之间有连边的概率
    %输出参数: ER_Network:生成的一个ER网络.

%产生一个随机概率矩阵
Rand_Number_Matrix = rand(numNod,numNod);

%ER网络预分配空间
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


