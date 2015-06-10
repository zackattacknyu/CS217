%This does the SIFT matching using VLFeat
%   It is quite similar to the code I used
%       in Homework 2

imageName = 'sfmPics1J2/shot';
image1 = strcat(imageName,'4.jpg');
image2 = strcat(imageName,'26.jpg');
image1Mask = strcat(imageName,'4mask.png');

%run SIFT on image1 and image2
I1 = imread(image1);
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);
I2 = imread(image2);
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);

%gets the mask
I1mask = imread(image1Mask);
I1mask = single(rgb2gray(I1mask));

%%

%Make sure points I1mask > 128 are included
%    when selecting ones for image 1

f1a = zeros(size(f1)); d1a = zeros(size(d1)); 
index = 1;
N1 = size(f1,2); N2 = size(f2,2);
for i = 1:N1
    rr = floor(f1(2,i)); cc = floor(f1(1,i));
    if(I1mask(rr,cc) > 128) %in the mask region
        f1a(:,index)=f1(:,i);
        d1a(:,index)=d1(:,i);
        index = index + 1;
    end
    
end
index = index-1;
f1 = f1a(:,1:index);d1 = d1a(:,1:index);

%When selecting ones for image 2, we do not need to be
%   as strict, so we select most of the points
f2a = zeros(size(f2)); d2a = zeros(size(d2));
index = 1;
for i = 1:N2
    if(f2(2,i)>150 && f2(2,i)<700) %will def be in mask region
        f2a(:,index)=f2(:,i);
        d2a(:,index)=d2(:,i);
        index = index + 1;
    end
end
index = index-1;
f2 = f2a(:,1:index);d2 = d2a(:,1:index);


%%

%computes the matching scores and selects the best 50 matches
[matches, scores] = vl_ubcmatch(d1, d2) ;
[bestScores,bestScoreInds] = sort(scores);
sel1 = matches(1,bestScoreInds);
sel1 = sel1(1:50);
sel2 = matches(2,bestScoreInds);
sel2 = sel2(1:50);

%%

%goes through the points visualized in sel1 and sel2
%   and finds their corresponding matches in the other images
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

doubleImage = [I1 I2];
figure
imagesc(doubleImage);
colormap bone;


%plots the SIFT points for left image
h1 = vl_plotframe(f1(:,sel1)) ;
h2 = vl_plotframe(f1(:,sel1)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d1(:,sel1),f1(:,sel1)) ;
set(h3,'color','g') ;

%plots the SIFT points for the right image
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

hold on
for i = 1:size(image1Points,2)
   Xvals = [image1Points(1,i) image2Points(1,i)+width];
   Yvals = [image1Points(2,i) image2Points(2,i)];
   plot(Xvals,Yvals);
end