function [U3,S3,V3,threshold1,threshold2,w,sortnum1,sortnum2]=LDA_classifier3(num1,num2,num3,labels,X,plotflag)
%choose 3 numbers to use LDA classification on
%would generate the classification result if plotflag is set to 1

%%
disp(['start LDA classification 3 numbers',num2str(num1),' , ',num2str(num2) ,' and ',num2str(num3)])
%use LDA to identify two number
feature=712;
%determined from previous plot of singular value


index1=find(labels==num1);
index2=find(labels==num2);
index3=find(labels==num3);
%seperate out data of two choosed numbers

X3=[X(:,index1) X(:,index2) X(:,index3)];
[U3,S3,V3]=svd(X3,'econ');
n1=length(index1);
n2=length(index2);
n3=length(index3);
Proj2PC=S3*V3';

n1m=Proj2PC(1:feature,1:n1);
n2m=Proj2PC(1:feature,n1+1:n1+n2);
n3m=Proj2PC(1:feature,n1+n2+1:n1+n2+n3);

mean1=mean(n1m,2);
mean2=mean(n2m,2);
mean3=mean(n3m,2);

Sw=0;%within class variance
for k=1:n1
    
    Sw=Sw+(n1m(:,k)-mean1)*(n1m(:,k)-mean1)';   
end
for k=1:n2    
    Sw=Sw+(n2m(:,k)-mean2)*(n2m(:,k)-mean2)';   
end
for k=1:n3    
    Sw=Sw+(n3m(:,k)-mean3)*(n3m(:,k)-mean3)';   
end

Sb=(mean1-mean2)*(mean1-mean2)'+(mean3-mean2)*(mean3-mean2)'+(mean1-mean3)*(mean1-mean3)';
%between class variance
%%
% linear disciminant analysis
[Vlda,D]=eig(Sb,Sw);
[lambda, ind] = max(abs(diag(D)));
w = Vlda(:,ind);
w = w/norm(w,2);
vn1=w'*n1m;
vn2=w'*n2m;
vn3=w'*n3m;
pvn1=vn1(1:100:n1);
pvn2=vn2(1:100:n2);
pvn3=vn3(1:100:n3);
pn1=length(pvn1);
pn2=length(pvn2);
pn3=length(pvn3);

figure()
subplot(4,1,1)
plot(pvn1,zeros(pn1),'bo','Linewidth',2)
hold on 
plot(pvn2,ones(pn2),'ro','Linewidth',2)
hold on 
plot(pvn3,ones(pn3,1)*2,'yo','Linewidth',2)
title(['Classification of number ',num2str(num1),' and ',num2str(num2)])
% 
% if plotflag
%     %only plot when plotflag is not 0
% figure()
% subplot(4,1,1)
% plot(vn1,zeros(n1),'bo','Linewidth',2)
% hold on 
% plot(vn2,ones(n2),'ro','Linewidth',2)
% hold on 
% plot(vn3,ones(n3,1)*2,'yo','Linewidth',2)
% title(['Classification of number ',num2str(num1),' and ',num2str(num2)])
% end
%%
%find thresh hold
sortnum1=sort(vn1);
sortnum2=sort(vn2);
sortnum3=sort(vn3);
vmeans=[mean(vn1) mean(vn2) mean(vn3)];
[meanmax,ind1]=max(vmeans);
[meanmin,ind2]=min(vmeans);
for i=1:3
   if i~=ind1&& i~=ind2
      meanmid=vmeans(i); 
   end
end
threshold2=(meanmax+meanmid)/2;
threshold1=(meanmin+meanmid)/2;


if plotflag

disp('plotting the result of LDA, this could take a while')
subplot(4,1,2)
histogram(sortnum1,30); hold on, 
plot([threshold1 threshold1], [0 1200],'r')
hold on,
plot([threshold2 threshold2], [0 1200],'r')
% set(gca,'Xlim',[-10 10],'Ylim',[0 1200],'Fontsize',14)
title(num2str(num1))
subplot(4,1,3)
histogram(sortnum2,30);
hold on, 
plot([threshold1 threshold1], [0 1200],'r')
hold on,
plot([threshold2 threshold2], [0 1200],'r')
% set(gca,'Xlim',[-10 10],'Ylim',[0 1200],'Fontsize',14)
title(num2str(num2))

subplot(4,1,4)
histogram(sortnum3,30); 
hold on,
plot([threshold1 threshold1], [0 1200],'r')
hold on,
plot([threshold2 threshold2], [0 1200],'r')
% set(gca,'Xlim',[-10 10],'Ylim',[0 1200],'Fontsize',14)
title(num2str(num3))
end

disp(['finish analyzing 3 numbers',num2str(num1),',  ',num2str(num2) ,' and ',num2str(num3)])
end