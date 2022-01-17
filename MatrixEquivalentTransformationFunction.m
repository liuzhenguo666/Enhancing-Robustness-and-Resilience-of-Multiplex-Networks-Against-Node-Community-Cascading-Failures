function equivalenMatrix = MatrixEquivalentTransformationFunction(matrix_test)
%�������ܣ�����һ���ڽӾ����������ڽӾ���ĵȼ۾��󣬵ȼ۾��󲻸ı�ͼ�α���ֻ�ı�ڵ�ı��
matrix_test = full(matrix_test);

%��ȡmatrix_test�Ĺ�ģ
[~,N] = size(matrix_test);

%���ý�������
%totalChangeNumber = ceil((N*N)/10);
totalChangeNumber = 2 * N;%����10000��ģ�����罻��

%��ʼ����
for changeNumberIndex = 1:totalChangeNumber
    
    %����Ҫ������2���ڵ���
    randomNode_1 = ceil(rand()*N);
    randomNode_2 = ceil(rand()*N);
    
    %1.�н�������randomNode_1�к͵�randomNode_2�н���
    %�Ƚ�randomNode_1�е����ݱ���������ʱ����rowTemporaryMatrix��
    rowTemporaryMatrix = matrix_test(randomNode_1,:);
    %����randomNode_2�е�������䵽��randomNode_1����
    matrix_test(randomNode_1,:) = matrix_test(randomNode_2,:);
    %�ٽ���ʱ�о���rowTemporaryMatrix�����ݷŵ���randomNode_2��
    matrix_test(randomNode_2,:) = rowTemporaryMatrix;
    
    %2.�н�������randomNode_1�к͵�randomNode_2�н���
    %�Ƚ�randomNode_1�е����ݱ���������ʱ����columnTemporaryMatrix��
    columnTemporaryMatrix = matrix_test(:,randomNode_1);
    %����randomNode_2�е�������䵽��randomNode_1����
    matrix_test(:,randomNode_1) = matrix_test(:,randomNode_2);
    %�ٽ���ʱ�о���columnTemporaryMatrix�����ݷŵ���randomNode_2��
    matrix_test(:,randomNode_2) = columnTemporaryMatrix;
    
end

%��������浽equivalenMatrix���
equivalenMatrix = matrix_test;

end