I = imread('squirtle1.JPG');
I = single(rgb2gray(I));
[f,d] = vl_sift(I);
%%
perm = randperm(size(f,2)) ;
sel = perm(1:50) ;

%%

%visualizes points
figure
imagesc(I);
colormap bone;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
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