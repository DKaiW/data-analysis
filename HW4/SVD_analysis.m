

function [X,labels]=SVD_analysis()
%SVD analysis,return complied matrix X with each image as a row and
%original labels variable from train set
%3 plots will be generated
%figure1 as a reformed U matrix rows
%figure2 singular values spectrum
%figure3 projection in V matrix modes


clc
clear
close all
% load('mnist_parse.m')
[images, labels] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');


%%
% X: the merged matrix of all picture with each one as a colume
% U S V:the result of SVD analysis


X=zeros(28*28,60000);
for i=1:60000
    I=reshape(images(:,:,i),28*28,1);
    X(:,i)=I;  
    %reshape each image to a singul colume and merge them together
end

[U,S,V] = svd(X,'econ');
%%
%plot of SVD result
%plot of rows in U matrix by reshaping them back to 28X28
figure(1)
for k = 1:12
 
subplot(3,4,k)
ut1 = reshape(U(:,k),28,28);
ut2 = rescale(ut1);
imshow(ut2)
end
text(-80,-85,'the plot of first 12 principal components')


% plot the singular values,
figure(2)
subplot(2,1,1)
plot(diag(S),'ko','Linewidth',2)
title('Singular values')
grid on
subplot(2,1,2)
semilogy(diag(S),'ko','Linewidth',2)
title('Singular values in log')
grid on

%%
%plot of V-modes
% v1 v2 v3 : the selected colums of V
% colors: randomly generated 10 colors

figure(3)
v1=V(:,2);
v2=V(:,3);
v3=V(:,5);
colors=rand(10,3);
for i=0:9
index=find(labels==i);
plot3(v1(index),v2(index),v3(index),'.','Color',colors(i+1,:))
hold on 
end
xlabel('colume 2 V-mode')
ylabel('colume 3 V-mode')
zlabel('colume 5 V-mode')
title('3D projection onto three selected V-modes')
grid on
legend('0','1','2','3','4','5','6','7','8','9')




end