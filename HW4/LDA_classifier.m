function [U2,S2,V2,threshold,w,sortnum1,sortnum2]=LDA_classifier(num1,num2,labels,X,plotflag)
%choose 2 numbers to use LDA classification on
%would generate the classification result if plotflag is set to 1

%%
disp(['start LDA classification ',num2str(num1),' and ',num2str(num2)])

%use LDA to identify two number
feature=712;
%determined from previous plot of singular value


index1=find(labels==num1);
index2=find(labels==num2);
%seperate out data of two choosed numbers

X2=[X(:,index1) X(:,index2)];
[U2,S2,V2]=svd(X2,'econ');
n1=length(index1);
n2=length(index2);
Proj2PC=S2*V2';

n1m=Proj2PC(1:feature,1:n1);
n2m=Proj2PC(1:feature,n1+1:n1+n2);

mean1=mean(n1m,2);
mean2=mean(n2m,2);

Sw=0;%within class variance
for k=1:n1
    
    Sw=Sw+(n1m(:,k)-mean1)*(n1m(:,k)-mean1)';   
end
for k=1:n2    
    Sw=Sw+(n2m(:,k)-mean2)*(n2m(:,k)-mean2)';   
end

Sb=(mean1-mean2)*(mean1-mean2)';%between class variance
%%
% linear disciminant analysis
[Vlda,D]=eig(Sb,Sw);
[lambda, ind] = max(abs(diag(D)));
w = Vlda(:,ind);
w = w/norm(w,2);
vn1=w'*n1m;
vn2=w'*n2m;

if mean(vn1)>mean(vn2)
   w=-w;
   vn1=-vn1;
   vn2=-vn2;    
end
%make sure number 1 is always lower

if plotflag
    %only plot when plotflag is not 0
figure()
subplot(3,1,1)
plot(vn1,zeros(n1),'bo','Linewidth',2)
hold on 
plot(vn2,ones(n2),'ro','Linewidth',2)
title(['Classification of number ',num2str(num1),' and ',num2str(num2)])
end
%%
%find thresh hold
sortnum1=sort(vn1);
sortnum2=sort(vn2);

t1=n1;
t2=1;
while sortnum1(t1)>sortnum2(t2)
   t1=t1-1;
   t2=t2+1;
end
threshold= (sortnum1(t1) + sortnum2(t2))/2;

if plotflag

disp('plotting the result of LDA, this could take a while')
subplot(3,1,2)
histogram(sortnum1,30); hold on, 
plot([threshold threshold], [0 1200],'r')
% set(gca,'Xlim',[-10 10],'Ylim',[0 1200],'Fontsize',14)
title(num2str(num1))
subplot(3,1,3)
histogram(sortnum2,30); hold on,
plot([threshold threshold], [0 1200],'r')
% set(gca,'Xlim',[-10 10],'Ylim',[0 1200],'Fontsize',14)
title(num2str(num2))

end

disp(['finish analyzing ',num2str(num1),' and ',num2str(num2)])
end