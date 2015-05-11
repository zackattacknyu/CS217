

%%

image1 = 'squirtle1.JPG';
image2 = 'squirtle2.JPG';

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

%does basic matching
Ia = imread('squirtle1.JPG');
Ia = single(rgb2gray(Ia));
Ib = imread('squirtle2.JPG');
Ib = single(rgb2gray(Ib));
[fa, da] = vl_sift(Ia) ;
[fb, db] = vl_sift(Ib) ;
[matches, scores] = vl_ubcmatch(da, db) ;