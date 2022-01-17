function equivalenMatrix = MatrixEquivalentTransformationFunction(matrix_test)
%函数功能：输入一个邻接矩阵，输出这个邻接矩阵的等价矩阵，等价矩阵不改变图形本身，只改变节点的标记
matrix_test = full(matrix_test);

%获取matrix_test的规模
[~,N] = size(matrix_test);

%设置交换次数
%totalChangeNumber = ceil((N*N)/10);
totalChangeNumber = 2 * N;%用于10000规模的网络交换

%开始交换
for changeNumberIndex = 1:totalChangeNumber
    
    %生成要交换的2个节点编号
    randomNode_1 = ceil(rand()*N);
    randomNode_2 = ceil(rand()*N);
    
    %1.行交换，第randomNode_1行和第randomNode_2行交换
    %先将randomNode_1行的内容保存在行临时矩阵rowTemporaryMatrix中
    rowTemporaryMatrix = matrix_test(randomNode_1,:);
    %将第randomNode_2行的内容填充到第randomNode_1行中
    matrix_test(randomNode_1,:) = matrix_test(randomNode_2,:);
    %再将临时行矩阵rowTemporaryMatrix的内容放到第randomNode_2行
    matrix_test(randomNode_2,:) = rowTemporaryMatrix;
    
    %2.列交换，第randomNode_1列和第randomNode_2列交换
    %先将randomNode_1列的内容保存在列临时矩阵columnTemporaryMatrix中
    columnTemporaryMatrix = matrix_test(:,randomNode_1);
    %将第randomNode_2列的内容填充到第randomNode_1列中
    matrix_test(:,randomNode_1) = matrix_test(:,randomNode_2);
    %再将例时列矩阵columnTemporaryMatrix的内容放到第randomNode_2列
    matrix_test(:,randomNode_2) = columnTemporaryMatrix;
    
end

%将结果保存到equivalenMatrix输出
equivalenMatrix = matrix_test;

end