function cam = calibrate(X,x)
%INPUT:
%
% x : points in the image (2xN array)
% X : points in 3D (3xN array)
%
% OUTPUT:
%
% cam : estimated camera parameters
%

%%
%this sets up the A matrix
%       for Ac=0

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

end

