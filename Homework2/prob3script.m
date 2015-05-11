%{
Calibration results
from running the calibration toolbox
%}
%-- Focal length:
fc = [ 1661.869788486886800 ; 1661.878228311368000 ];
%-- Principal point:
cc = [ 836.558147655548620 ; 607.339755380394990 ];
%-- Image size:
nx = 1600;
ny = 1200;

%generates instrinsic matrix from these results
K = [nx*fc(1) 0 cc(1);0 ny*fc(2) cc(2); 0 0 1];

%{
This is the script used for problem 1. 

Much of the code was inspired by the tutorial here:
http://www.vlfeat.org/overview/sift.html
%}

image1 = 'sfm/IMG_1434.JPG';
image2 = 'sfm/IMG_1435.JPG';

%run SIFT on image1 and image2
I1 = imread(image1);
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);
I2 = imread(image2);
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);

%does basic matching
[matches, scores] = vl_ubcmatch(d1, d2) ;
%%
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

%plots the left and right image side-by-side
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

%plots the matches for the visualized points in each image
hold on
for i = 1:size(image1Points,2)
   Xvals = [image1Points(1,i) image2Points(1,i)+width];
   Yvals = [image1Points(2,i) image2Points(2,i)];
   plot(Xvals,Yvals);
end

%%

image1Matrix = [image1Points;ones(1,size(image1Points,2))];
image2Matrix = [image2Points;ones(1,size(image2Points,2))];
newImg1Mat = inv(K)*image1Matrix;
newImg2Mat = inv(K)*image2Matrix;


