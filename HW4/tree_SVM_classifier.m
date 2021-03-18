function [treeModel,SVMModel]=tree_SVM_classifier(num1,num2)
% input number 1 and 2 choosed to classify
% num1,num2: number 1 and 2 choosed to classify
% output:
% trained models of SVM method and decision treemethod



[images, labels] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');
ind1=find(labels==num1);
ind2=find(labels==num2);
trainset1=images(:,:,ind1);
trainset2=images(:,:,ind2);
trainX=zeros(28*28,length(ind1)+length(ind2));
for i=1:length(ind1)
    I=reshape(trainset1(:,:,i),28*28,1);
    trainX(:,i)=I;  
    %reshape each image to a singul colume and merge them together
end
for i=1:length(ind2)
    I=reshape(trainset2(:,:,i),28*28,1);
    trainX(:,length(ind1)+i)=I;  
    %reshape each image to a singul colume and merge them together
end
truelabel=[labels(ind1)' labels(ind2)'];

%use SVM and decision tree classifiers
disp(['start SVM classification ',num2str(num1),' and ',num2str(num2),'this could take a while'])
SVMModel = fitcsvm(trainX',truelabel');
disp(['start decision tree classification ',num2str(num1),' and ',num2str(num2)])
treeModel = fitctree(trainX',truelabel','MaxNumSplits',3,'CrossVal','on');
% view(tree.Trained{1},'Mode','graph');

end

