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

Kmatrix = [fc(1) 0 cc(1);0 fc(2) cc(2);0 0 1];
invK = inv(Kmatrix);
newX13 = invK*x13;
newX14 = invK*x14;
%%
Xhom = [X;ones(1,size(X,2))];
Result = lsqnonlin(@(YY) part4function(YY,Xhom,newX13),[0 0 0 0 0 0]);

%%
%camEst13 = calibrate(X,newX13);
%camEst14 = calibrate(X,newX14);
x = newX13;
n = size(X,2);
Pmatrix = [X(:,1:n);ones(1,n)];
xVals = x(1,1:n);
yVals = x(2,1:n);

%assemble the A matrix as specified in the slides
A = zeros(2*n,12);
for i = 1:n
   PiT = transpose(Pmatrix(:,i));
   start = 2*i-1;
   A(start:start+1,:) = ...
       [0 0 0 0 -PiT PiT.*yVals(i);...
       PiT 0 0 0 0 PiT.*(-xVals(i))];
end

%calibration is the last column of V in the SVD
[U,S,V] = svd(A);
calib = V(:,end);
%%
%make the matrix have uniform scale
calib = calib./calib(12);
cam.C = (reshape(calib,[4 3]))';

translationCol = cam.C(:,4);
mainMat = cam.C(:,1:3);
[Kmat,Rinv] = rq(mainMat);

%normalizes by last entry
KmatNorm = Kmat./Kmat(9);
cam.K = KmatNorm;
cam.m = [KmatNorm(1,1);KmatNorm(2,2)];
cam.f = 1;
cam.c = [KmatNorm(1,3);KmatNorm(2,3)];

%gets rotation
Rmat = -inv(Rinv);
cam.R = Rmat;
cam.t = Rmat*inv(Kmat)*translationCol;