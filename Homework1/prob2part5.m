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

%I am assuming that world coordinates are in meters

numVals = 50;

%Section A
error = zeros(1,numVals);
variation = 0.2; %number of pixels in 2 mm
cLorig = camL.c;
cRorig = camR.c;
for i = 1:numVals
    camL.c = cLorig + randn(2,1)*variation - [variation/2;variation/2];
    camR.c = cRorig + randn(2,1)*variation - [variation/2;variation/2];
    Xrecov = triangulate(xL,xR,camL,camR);
    %this gives sum of squared errors
    error(i) = sum(sum((Xrecov-X).^2,1));
end
errorA = mean(error);

%recover original location of camera center
camL.c = cLorig;
camR.c = cRorig;

%Section B
error = zeros(1,numVals);
variation = 0.01; %number of meters in 10 mm
for i = 1:numVals
    camL.f = 1 + 2*randn(1,1)*variation - variation;
    camR.f = 1 + 2*randn(1,1)*variation - variation;
    Xrecov = triangulate(xL,xR,camL,camR);
    %this gives sum of squared errors
    error(i) = sum(sum((Xrecov-X).^2,1));
end
errorB = mean(error);

%recover original focal length
camL.f = 1;
camR.f = 1;

%Section C
error = zeros(1,numVals);
variation = 0.1; %number of meters in 100 mm
tLorig = camL.t;
tRorig = camR.t;
for i = 1:numVals
    camL.t = tLorig + 2*randn(3,1)*variation - repmat(variation,3,1);
    camR.t = tRorig + 2*randn(3,1)*variation - repmat(variation,3,1);
    Xrecov = triangulate(xL,xR,camL,camR);
    %this gives sum of squared errors
    error(i) = sum(sum((Xrecov-X).^2,1));
end
errorC = mean(error);

%recover original translation vectors
camL.t= tLorig;
camR.t= tRorig;

%Section D
error = zeros(1,numVals);
variation = 5*pi/180; %5 degrees in radians

thyLorig = atan2(camL.t(1),10); 
thyRorig = atan2(camR.t(1),10); 

for i = 1:numVals
    thyL = thyLorig + 2*randn(1,1)*variation - variation;
    camL.R = [  cos(thyL)   0  -sin(thyL) ; ...
              0    1         0 ; ...
         sin(thyL)   0  cos(thyL) ];
    
    thyR = thyRorig + 2*randn(1,1)*variation - variation;
    camR.R = [  cos(thyR)   0  -sin(thyR) ; ...
              0    1         0 ; ...
         sin(thyR)   0  cos(thyR) ];
    
    Xrecov = triangulate(xL,xR,camL,camR);
    %this gives sum of squared errors
    error(i) = sum(sum((Xrecov-X).^2,1));
end
errorD = mean(error);

%recover original matrices
thy = atan2(camL.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
camL.R = Ry;

thy = atan2(camR.t(1),10); 
Ry = [  cos(thy)   0  -sin(thy) ; ...
              0    1         0 ; ...
       sin(thy)   0  cos(thy) ];
camR.R = Ry;