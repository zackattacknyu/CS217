%%
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

%%
noise = [0.01 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24];
numVals = length(noise);
error = zeros(1,numVals);
for i = 1:numVals
    
    xLnoisy = xL + noise(i)*randn(size(xL)); 
    xRnoisy = xR + noise(i)*randn(size(xR));
    Xrecov = triangulate(xLnoisy,xRnoisy,camL,camR);

    %this gives sum of squared errors
    error(i) = sum(sum((Xrecov-X).^2,1));

end

plot(noise,error);
