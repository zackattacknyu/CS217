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


numInitPts = 8;
randIndices = randperm(size(X1,1));
eightPtsIndices = randIndices(1:numInitPts);


%taken from paper "In Defense of the Eight Point Algorithm"
%   section 2.2
equMatrix = ones(numInitPts,9);
for j = 1:numInitPts
    
    i = eightPtsIndices(j);
    %If (u,v,1) and (u',v',1) are the pts, then this row should be:
    %(uu', uv', u, vu', vv', v, u', v', 1)
    equMatrix(j,:) = [X1(i)*X2(i) X1(i)*Y2(i) X1(i) ...
        Y1(i)*X2(i) Y1(i)*Y2(i) Y1(i)...
        X2(i) Y2(i) 1]; 
end

vecs = null(equMatrix);
ff = vecs./norm(vecs);

[U,S,V] = svd(equMatrix);
calib = V(:,end);
ff2 = calib./norm(calib);

%%
fMatrix = reshape(ff,[3 3]);

%%
otherIndices = randIndices(9:size(X1,1));
numOthers = length(otherIndices);
vals = zeros(1,numOthers);
for k = 1:numOthers
    index = otherIndices(k);
    img1Vec = [X1(index) Y1(index) 1];
    img2Vec = [X2(index);Y2(index);1];
    vals(k) = img1Vec*fMatrix*img2Vec;
end

