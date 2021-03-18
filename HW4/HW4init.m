%%
%runSVD analysis on the train set
[X,labels]=SVD_analysis();
%%
%LDA_clssifier 2 choosed number
[U2,S2,V2,threshold,w,sortnum1,sortnum2]=LDA_classifier(4,2,labels,X,1);

%%
%LDA_clssifier 3 choosed number
[U3,S3,V3,threshold1,threshold2,w,sortnum1,sortnum2]=LDA_classifier3(0,8,9,labels,X,1);

%%
%load test set and iterately run LDA on all combination of two numbers between 0-9
%the accuracy result is stored in accuracy matrix
clc
[testimages, testlabels] = mnist_parse('t10k-images.idx3-ubyte', 't10k-labels.idx1-ubyte');
accuracyrecord_LDA=zeros(10,10);
% accuracyrecord_SVM=zeros(10,10);
% accuracyrecord_dtree=zeros(10,10);
%could run the SVM and decision tree classification result on all pairs of
%numbers and stored in these matrix if needed


for num1=0:9
    for num2=num1+1:9

[U2,S2,V2,threshold,w,sortnum1,sortnum2]=LDA_classifier(num1,num2,labels,X,0);

ind1=find(testlabels==num1);
ind2=find(testlabels==num2);
testset1=testimages(:,:,ind1);
testset2=testimages(:,:,ind2);


testX=zeros(28*28,length(ind1)+length(ind2));
for i=1:length(ind1)
    I=reshape(testset1(:,:,i),28*28,1);
    testX(:,i)=I;  
    %reshape each image to a singul colume and merge them together
end
for i=1:length(ind2)
    I=reshape(testset2(:,:,i),28*28,1);
    testX(:,length(ind1)+i)=I;  
    %reshape each image to a singul colume and merge them together
end

truelabel=[testlabels(ind1)' testlabels(ind2)'];
projec2pca=U2'*testX;% PCA projection
pval=w'*projec2pca(1:length(w),:);
resvect=zeros(size(pval));
for i=1:length(pval)
   if pval(i)>threshold
      resvect(i)=num2;
   else
       resvect(i)=num1;
   end
end
err=abs(truelabel-resvect);
errnum=sum(err);

accuracy=1-errnum/length(pval);

disp([' LDA classification of ',num2str(num1),' and ',num2str(num2),' has accuracy of ',num2str(accuracy),'in test set',newline])
accuracyrecord_LDA(num1+1,num2+1)=accuracy;



    end
end
accuracyrecord_LDA


%%
%%use SVM and decision tree classifiers
num1=8
num2=9
%choose the number pairs here, the most easy pair is 8&9, 
%hardest pair is3&9 accoording to result from LDA

[treeModel,SVMModel]=tree_SVM_classifier(num1,num2);

ind1=find(testlabels==num1);
ind2=find(testlabels==num2);
testset1=testimages(:,:,ind1);
testset2=testimages(:,:,ind2);
testX=zeros(28*28,length(ind1)+length(ind2));
for i=1:length(ind1)
    I=reshape(testset1(:,:,i),28*28,1);
    testX(:,i)=I;  
    %reshape each image to a singul colume and merge them together
end
for i=1:length(ind2)
    I=reshape(testset2(:,:,i),28*28,1);
    testX(:,length(ind1)+i)=I;  
    %reshape each image to a singul colume and merge them together
end
truelabel=[testlabels(ind1)' testlabels(ind2)'];
SVMresult=predict(SVMModel,testX');
%testX is loaded from test set

err=(truelabel~=SVMresult');
errnum=sum(sum(err));
accuracy=1-errnum/length(SVMresult);
disp([' LDA classification of ',num2str(num1),' and ',num2str(num2),' has accuracy of ',num2str(accuracyrecord_LDA(num1+1,num2+1)),' in test set'])
disp([' SVM classification of ',num2str(num1),' and ',num2str(num2),' has accuracy of ',num2str(accuracy),' in test set'])
classError = kfoldLoss(treeModel);

disp([' Decision tree classification of ',num2str(num1),' and ',num2str(num2),' has accuracy of ',num2str(1-classError),' in train set',newline])


