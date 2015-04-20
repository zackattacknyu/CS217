%gets the 3D checkerboard point values
[yy,xx] = meshgrid(linspace(0,25.2,10),linspace(0,19.55,8));
zz = zeros(size(xx(:)));
X = [xx(:) yy(:) zz(:)]';

%gets x values for image 13
%obtained using paint and visually recording the pixel location
origin = [739;1081];
vectorInYdir = [677;983]-origin;
vectorInXdir = [843;1015]-origin;
x13 = ones(3,80);
index = 1;
for i = 0:7
   for j=0:9
       x13(1:2,index) = origin+vectorInXdir*j+vectorInYdir*i;
       index = index+1;
   end
end

%gets x values for image 14
%obtained using paint and visually recording the pixel location
origin = [344;657];
vectorInYdir = [433;689]-origin;
vectorInXdir = [399;583]-origin;
x14 = ones(3,80);
index = 1;
for i = 0:7
   for j=0:9
       x14(1:2,index) = origin+vectorInXdir*j+vectorInYdir*i;
       index = index+1;
   end
end

%-- Focal length from previous problem
fc = [ 1602.728199544142200 ; 1627.132891974834400 ];
cam13.m = fc; cam14.m = fc;
cam13.f = 1; cam14.f = 1;

%-- Principal point from previous problem
cc = [ 830.782186100948930 ; 563.592745345227400 ];
cam13.c = cc; cam14.c = cc;

%gets the modified points after considering instrinic matrix
Kmatrix = [fc(1) 0 cc(1);0 fc(2) cc(2);0 0 1];
invK = inv(Kmatrix);
newX13 = invK*x13;
newX14 = invK*x14;

%uses non-linear least squares to obtain extrinsic matrix
%   parameters are theta_1,theta_2,theta_3 as well as x,y,z
%   the first set are the angles for the rotation matrices
%   the second set is the translation vector
Xhom = [X;ones(1,size(X,2))];
Result13 = lsqnonlin(@(YY) part4function(YY,Xhom,newX13),[0 0 0 0 0 0]);
Result14 = lsqnonlin(@(YY) part4function(YY,Xhom,newX14),[0 0 0 0 0 0]);

%gets the R,t result for camera 13
[Rinv,tResult] = part4Input(Result13);
Rmatrix13 = inv(Rinv);
tVector13 = -Rmatrix13*tResult;
cam13.R = Rmatrix13; cam13.t = tVector13;

%gets the R,t result for camera 14
[Rinv,tResult] = part4Input(Result14);
Rmatrix14 = inv(Rinv);
tVector14 = -Rmatrix14*tResult;
cam14.R = Rmatrix14; cam14.t = tVector14;

%points are in order A,B,C,D,E,F as shown in my diagram
pts13=[792 794 1066 1091 1060 793;564 692 690 564 335 337];
pts14=[673 688 822 820 1068 909;401 520 682 566 433 286];
boxCoords = triangulate(pts13,pts14,cam13,cam14);
Acoord = boxCoords(:,1);
Bcoord = boxCoords(:,2);
Ccoord = boxCoords(:,3);
Dcoord = boxCoords(:,4);
Ecoord = boxCoords(:,5);
Fcoord = boxCoords(:,6);

%two possible heights (how much the box rises from the checkerboard)
height1 = norm(Acoord-Bcoord);
height2 = norm(Ccoord-Dcoord);
height = mean([height1 height2]);

%two possible widths (the letters travel along the width dimension)
width1 = norm(Acoord-Dcoord);
width2 = norm(Bcoord-Ccoord);
width = mean([width1 width2]);

%two possible lengths (final dimension that is neither of the above)
length1 = norm(Acoord-Fcoord);
length2 = norm(Dcoord-Ecoord);
length = mean([length1 length2]);

length
width
height
