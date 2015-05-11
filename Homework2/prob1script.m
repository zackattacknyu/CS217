

%%

imageName = 'squirtle';
image1 = strcat(imageName,'1.JPG');
image2 = strcat(imageName,'2.JPG');

%visualizes points
I1 = imread(image1);
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);

I2 = imread(image2);
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);

perm = randperm(size(f1,2)) ;
sel1 = perm(1:50) ;
perm = randperm(size(f2,2)) ;
sel2 = perm(1:50) ;

%does basic matching
[matches, scores] = vl_ubcmatch(d1, d2) ;

%%
image1matches = matches(1,:);
image2matches = matches(2,:);

numPoints = size(sel1,2);
image1Points = [];
image2Points = [];
for i = 1:numPoints
    matchingCol = find(image1matches==sel1(i));
    if(~isempty(matchingCol))
       colNum = matchingCol(1);
       image1index = matches(1,colNum);
       image1Points = [image1Points f1(1:2,image1index)];
       img2MatchingIndex = matches(2,colNum);
       image2Points = [image2Points f2(1:2,img2MatchingIndex)];
    end
end

numPoints = size(sel2,2);
for i = 1:numPoints
    matchingCol = find(image2matches==sel2(i));
    if(~isempty(matchingCol))
       colNum = matchingCol(1);
       image2index = matches(2,colNum);
       image2Points = [image2Points f2(1:2,image2index)];
       img1MatchingIndex = matches(1,colNum);
       image1Points = [image1Points f1(1:2,img1MatchingIndex)];
    end
end
%%
doubleImage = [I1 I2];
figure
imagesc(doubleImage);
colormap bone;

%plots the results for the left image
h1 = vl_plotframe(f1(:,sel1)) ;
h2 = vl_plotframe(f1(:,sel1)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d1(:,sel1),f1(:,sel1)) ;
set(h3,'color','g') ;

%plots the results for the right image
width = size(I1,2);
f2Original = f2(:,sel2);
f2Offset = repmat([width;0;0;0],1,50);
f2New = f2Original+f2Offset;
h1 = vl_plotframe(f2New) ;
h2 = vl_plotframe(f2New) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d2(:,sel2),f2New) ;
set(h3,'color','g') ;
%%
hold on
for i = 1:size(image1Points,2)
   Xvals = [image1Points(1,i) image2Points(1,i)+width];
   Yvals = [image1Points(2,i) image2Points(2,i)];
   plot(Xvals,Yvals);
end