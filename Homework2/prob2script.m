%This code was used to select image points to use
%   through direct selection to see if they 
%   will end up corresponding when running RANSAC

%imageName = 'coffeeCan';
%imageName = 'squirtle';
imageName = 'book';
image1 = strcat(imageName,'1.JPG');
image2 = strcat(imageName,'2.JPG');
%%
I1 = imread(image2);
%I1 = imread(image1);
I1 = single(rgb2gray(I1));
figure(1)
curImg = imagesc(I1)
colormap bone;
%[X1 Y1] = getpts(1);
%[X2 Y2] = getpts(1);

%%
save('coffeeCanPts.mat','X1','X2','Y1','Y2','-v7.3');
%%
%loads points found using direct selection
load('squirtlePts.mat');
%%
load('bookPts.mat');
%%
load('coffeeCanPts.mat');
%%

%pick points using SIFT
%run SIFT on image1 and image2
I1 = imread(image1);
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);
I2 = imread(image2);
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);

%%
%for squirtle using SIFT, make sure points where y<400 is not included
%       this is bc we don't care about the gradient there
f1a = zeros(size(f1)); d1a = zeros(size(d1)); 
f2a = zeros(size(f2)); d2a = zeros(size(d2));
index = 1;
N1 = size(f1,2); N2 = size(f2,2);
for i = 1:N1
    if(f1(2,i)>400)
        f1a(:,index)=f1(:,i);
        d1a(:,index)=d1(:,i);
        index = index + 1;
    end
    
end
index = index-1;
f1 = f1a(:,1:index);d1 = d1a(:,1:index);
index = 1;
for i = 1:N2
    if(f2(2,i)>400)
        f2a(:,index)=f2(:,i);
        d2a(:,index)=d2(:,i);
        index = index + 1;
    end
end
index = index-1;
f2 = f2a(:,1:index);d2 = d2a(:,1:index);
%%
%does basic matching
[matches, scores] = vl_ubcmatch(d1, d2) ;
[bestScores,bestScoreInds] = sort(scores);
sel1 = matches(1,bestScoreInds);
sel1 = sel1(1:50);
sel2 = matches(2,bestScoreInds);
sel2 = sel2(1:50);
%%
%gets X1,X2,Y1,Y2
X1 = f1(1,sel1)';
Y1 = f1(2,sel1)';
X2 = f2(1,sel2)';
Y2 = f2(2,sel2)';
%%

%number of iterations of RANSAC
numIter=5;

%gets an initial randomly sampled set
numInitPts = 8;
randIndices = randperm(size(X1,1));
eightPtsIndices = randIndices(1:numInitPts);
equMatrix = getAmatrix(X1,X2,Y1,Y2,eightPtsIndices);
vecs = null(equMatrix);
ff = vecs./norm(vecs);
fMatrix = reshape(ff,[3 3]);

%performs iterations of RANSAC
%threshold = 0.45; %for squirtle
%threshold = 0.6; %for book
threshold = 0.55; %for coffee can
for iter=1:numIter
    
    %figures out the inlier and outlier indices
    inlierIndices = [];
    outlierIndices = [];
    for index = 1:size(X1,1)
        img1Vec = [X1(index) Y1(index) 1];
        img2Vec = [X2(index);Y2(index);1];
        value = abs(img1Vec*fMatrix*img2Vec);
        if(value<threshold)
            inlierIndices = [inlierIndices index];
        else
            outlierIndices = [outlierIndices index];
        end
    end
    
    %recompute F based on Inlier Indices
    equMatrix = getAmatrix(X1,X2,Y1,Y2,inlierIndices);
    [U,S,V] = svd(equMatrix);
    calib = V(:,end);
    ff2 = calib./norm(calib);
    fMatrix = reshape(ff2,[3 3]);
end

%%

%imageName = 'squirtle';
%imageName = 'coffeeCan';
imageName = 'book';
image1 = strcat(imageName,'1.JPG');
image2 = strcat(imageName,'2.JPG');
I1 = imread(image1);
I2 = imread(image2);
I1 = single(rgb2gray(I1));
I2 = single(rgb2gray(I2));
width = size(I1,2);

%plots the left and right image side-by-side
doubleImage = [I1 I2];
figure
imagesc(doubleImage);
colormap bone;

%plots the matches for the visualized points in each image for Part A
hold on
for i = 1:size(inlierIndices,2)
    index = inlierIndices(i);
   Xvals = [X1(index) X2(index)+width];
   Yvals = [Y1(index) Y2(index)];
   plot(Xvals,Yvals);
end

%%

%Plots the Epipolar lines for Part B
randInds = randperm(size(inlierIndices,2));
randInds = inlierIndices(randInds);

doubleImage = [I1 I2];
figure
imagesc(doubleImage);
colormap bone;

x = linspace(0,width,100);

%plots the matches for the visualized points in each image
hold on
colors = 'bgrcmbgrcmbgrcmbgrcm';
for i = 1:20
    index = randInds(i);
    
    %gets the point in image 2 and its line in image 1
    abcVector = fMatrix*[X2(index);Y2(index);1];
    A = abcVector(1); B = abcVector(2); C = abcVector(3);
    curY = -(A.*x + C)./B;
    
    %gets the point in image 1 and its line in image 2
    abcVector2 = [X1(index) Y1(index) 1]*fMatrix;
    A2 = abcVector2(1); B2 = abcVector2(2); C2 = abcVector2(3);
    curY2 = -(A2.*x + C2)./B2;
    
    %plots the lines found above
    plot(x,curY,strcat(colors(i),'-'));
    plot(x+width,curY2,strcat(colors(i),'-'));
    
    %plots the points found above
    plot(X1(index),Y1(index),strcat(colors(i),'x'));
    plot(X2(index)+width,Y2(index),strcat(colors(i),'x'));
end

%%

%This records good fMatrices for use in part C
fMatInd = 0;
%%
fMatInd = fMatInd+1;
fMatrices(fMatInd,:,:) = fMatrix;

%%

%calculates STD to get sense of stability
stdMat = std(fMatrices,1);
sumStd = sum(sum(stdMat));

%for squirtle, sumStd is near zero and 4 computations of fMatrix were done
%for book, sumStd was 0.9567 and 6 computations of fMatrix were done
%for coffee can, sumStd was 1.0140 and 6 computations of fMatrix were done



