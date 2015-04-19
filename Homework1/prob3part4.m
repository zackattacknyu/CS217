[yy,xx] = meshgrid(linspace(0,25.2,10),linspace(0,19.55,8));
zz = zeros(size(xx(:)));
X = [xx(:) yy(:) zz(:)]';

%gets the x values

%for image 13
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

%for image 14
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

%-- Focal length:
fc = [ 1602.728199544142200 ; 1627.132891974834400 ];

%-- Principal point:
cc = [ 830.782186100948930 ; 563.592745345227400 ];

%gets the modified points after considering instrinic matrix
Kmatrix = [fc(1) 0 cc(1);0 fc(2) cc(2);0 0 1];
invK = inv(Kmatrix);
newX13 = invK*x13;
newX14 = invK*x14;
%%

%uses non-linear least squares to obtain extrinsic matrix
%   parameters are theta_1,theta_2,theta_3 as well as x,y,z
%   the first set are the angles for the rotation matrices
%   the second set is the translation vector
Xhom = [X;ones(1,size(X,2))];
Result13 = lsqnonlin(@(YY) part4function(YY,Xhom,newX13),[0 0 0 0 0 0]);
Result14 = lsqnonlin(@(YY) part4function(YY,Xhom,newX14),[0 0 0 0 0 0]);

[Rinv,tResult] = part4Input(Result13);
Rmatrix13 = inv(Rinv);
tVector13 = -Rmatrix13*tResult;

[Rinv,tResult] = part4Input(Result14);
Rmatrix14 = inv(Rinv);
tVector14 = -Rmatrix14*tResult;
