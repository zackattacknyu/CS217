

%%

%visualizes points
I1 = imread('squirtle1.JPG');
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1);

I2 = imread('squirtle2.JPG');
I2 = single(rgb2gray(I2));
[f2,d2] = vl_sift(I2);

perm = randperm(size(f1,2)) ;
sel1 = perm(1:50) ;
perm = randperm(size(f2,2)) ;
sel2 = perm(1:50) ;

figure
subplot(1,2,1)
imagesc(I1);
colormap bone;
h1 = vl_plotframe(f1(:,sel1)) ;
h2 = vl_plotframe(f1(:,sel1)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d1(:,sel1),f1(:,sel1)) ;
set(h3,'color','g') ;

subplot(1,2,2)
imagesc(I2);
colormap bone;
h1 = vl_plotframe(f2(:,sel1)) ;
h2 = vl_plotframe(f2(:,sel1)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d2(:,sel1),f2(:,sel1)) ;
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