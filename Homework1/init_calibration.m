%
% This script tests the project and triangulate functions.
% You may want to modify it to try other tests and/or cut
% and paste bits into your interactive MATLAB session as 
% you are debugging.
%


%
% first generate our test figure in 3D
%
X = generate_hemisphere(2,[0;0;10],1000);

%
% set intrinsic parameters shared by both camers
%

%focal length
camL.f = 1;
camR.f = 1;

%pixel magnification factor
camL.m = [100;100];
camR.m = [100;100];

%location of camera center
camL.c = [50;50];
camR.c = [50;50];

camL.K = generateIntrinsic(camL);
camR.K = generateIntrinsic(camR);

%
% extrinsic params for left camera
%
camL.t= [-0.2;0;0];
thy = atan2(camL.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
camL.R = Ry;

%
%extrinsic params for right camera
%
camR.t= [0.2;0;0];
thy = atan2(camR.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
camR.R = Ry;

%
% now compute the two projections
%
xL= project(X,camL);
xR = project(X,camR);

camL.Ext = generateExtrinsic(camL);
camR.Ext = generateExtrinsic(camR);

camL.C = camL.K*camL.Ext;
camL.C = camL.C./camL.C(3,4);
camR.C = camR.K*camR.Ext;
camR.C = camR.C./camR.C(3,4);

%%
%this sets up the A matrix
%       for Ac=0

n = size(X,2);
x = xL;

pMat = [x(:,1:n);ones(1,n)];
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
calibMatrix = (reshape(calib,[4 3]))';

[Qmat,Rmat] = qr(calibMatrix);

%used for verification
CP = calibMatrix*Pmatrix;
CP(1,:)=CP(1,:)./CP(3,:);
CP(2,:)=CP(2,:)./CP(3,:);
CP(3,:)=CP(3,:)./CP(3,:);
diff = sum(sum(abs(CP-pMat)));
calibDiff = sum(sum(abs(camL.C-calibMatrix)));

%%

%
% now try to recover the 3D locations from the 2D views
% add some noise to make the process more realistic.
%
xLnoisy = xL + 0.01*randn(size(xL)); 
xRnoisy = xR + 0.01*randn(size(xR));
Xrecov = triangulate(xLnoisy,xRnoisy,camL,camR);

%
% display results as a cloud of points
%
figure(3); clf;
plot3(X(1,:),X(2,:),X(3,:),'.');
hold on;
plot3(Xrecov(1,:),Xrecov(2,:),Xrecov(3,:),'ro');
axis image;
axis vis3d;
grid on;
legend('original points','recovered points')

%
%display results as a surface
%
figure(4);
subplot(2,1,1);
tri = delaunay(X(1,:),X(2,:));
trisurf(tri,X(1,:),X(2,:),X(3,:));
axis equal; axis vis3d; grid on;
title('original shape');
subplot(2,1,2);
tri = delaunay(Xrecov(1,:),Xrecov(2,:));
trisurf(tri,Xrecov(1,:),Xrecov(2,:),Xrecov(3,:));
axis equal; axis vis3d; grid on;
title('recovered shape');

