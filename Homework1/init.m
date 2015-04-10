n = 7;

%generates points
X = floor(rand(3,n)*100);
x = floor(rand(2,n)*10);

%this sets up the A matrix
%       for Ac=0

Pmatrix = [X;ones(1,n)];
PmatrixT = transpose(Pmatrix);
xVals = x(1,:);
yVals = x(2,:);

%assemble the A matrix as specified in the slides
A = zeros(2*n,12);
for i = 1:n
   PiT = PmatrixT(i,:);
   start = 2*i-1;
   A(start:start+1,:) = ...
       [0 0 0 0 -PiT PiT.*yVals(i);...
       PiT 0 0 0 0 PiT.*(-xVals(i))];
end

%calibration is the last column of V in the SVD
[U,E,V] = svd(A);
calib = V(:,end);

%make the matrix have uniform scale
calibMatrix = reshape(calib./(calib(12)),[3 4]);

%%
[Qmat,Rmat] = qr(calibMatrix);


