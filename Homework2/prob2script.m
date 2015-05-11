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

