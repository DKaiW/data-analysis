
function [x,y]=findmloc(testnum,cameranum,regionselect,tol)


casenum=num2str(testnum);
vi=cameranum;

filename=[{['cam1_',casenum,'.mat']},{['cam2_',casenum,'.mat']},{['cam3_',casenum,'.mat']}];
framename=[{['vidFrames1_',casenum,'']},{['vidFrames2_',casenum,'']},{['vidFrames3_',casenum,'']}];
load(string(filename(vi)))
name=char(framename(vi));

% eval(['implay(',name,')'])
%%

eval(['numFrames = size(',name,',4)']);
figure('Position', [100 200 1600 800])
t=[];
x=[];
y=[];

for j = 1:1:numFrames

eval(['X = ',char(framename(vi)),'(:,:,:,j);'])

Xg=rgb2gray(X);

% imshow(Xg); drawnow
Xg=Xg.*uint8(regionselect);


       thresh=double(max(max(Xg))-tol)/255;
       %choose most light area
       I=im2bw(Xg,thresh);
       %transfer the grayscle image to binary image where light part is 1
       %and dark part is 0
       
       se=strel('disk',20);
       se2=strel('disk',40);
       I = imdilate(I,se);
       I = imerode(I,se);
       I = imdilate(I,se);
       I = imdilate(I,se);
       %some morphology processing here to gathering highlight area
       
       subplot(1,2,1)
       imshow(Xg); drawnow
       title('selected origin video')
       subplot(1,2,2)
       imshow(I); drawnow
       title('selected highlight')
       hold on
       %plot here for visual illustration
       
       [l,m] = bwlabel(I);
       %lable all the highlight region
       cxy=regionprops(l,'Centroid');
       if m>0
       xlist=[];
       ylist=[];
       for i=1:m
           xlist=[xlist cxy(i).Centroid(1)];
           ylist=[ylist cxy(i).Centroid(2)];
       end
       end
       
       index=find(ylist==max(ylist));
       %set find the lowest light area in frame 
       selecx=cxy(index).Centroid(1);
       selecy=cxy(index).Centroid(2); 
       x=[x selecx];
       y=[y selecy];
       disp([num2str(j),'/',num2str(numFrames),'compeleted'])
       %print precedure
       scatter(selecx,selecy,100,'rx')
end
title(['mass location detection of file:  ',name])
disp(j)
pause(0.001)

end




