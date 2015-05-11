%{

For this problem, estimate the fundamental matrix
    x'Fx
by solving that linear equation

Use RANSAC algorithm to find an inital F and then update it

Code for RANSAC:
http://www.cb.uu.se/~aht/code.html


%}

%{

%gets image points
imageName = 'squirtle';
image1 = strcat(imageName,'1.JPG');
image2 = strcat(imageName,'2.JPG');
I1 = imread(image2);
I1 = single(rgb2gray(I1));
figure(1)
curImg = imagesc(I1)
colormap bone;
[X Y] = getpts(1);

%}

%%
save('squirtlePts.mat','X1','X2','Y1','Y2','-v7.3');
%%
load('squirtlePts.mat');
%%

numIter=3;

%gets an initial randomly sampled set
numInitPts = 8;
randIndices = randperm(size(X1,1));
eightPtsIndices = randIndices(1:numInitPts);
equMatrix = getAmatrix(X1,X2,Y1,Y2,eightPtsIndices);
vecs = null(equMatrix);
ff = vecs./norm(vecs);
fMatrix = reshape(ff,[3 3]);

%performs iterations of RANSAC
threshold = 0.45;
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


