function X = triangulate(xL,xR,camL,camR)
%
% INPUT:
%
% xL,xR : points in left and right images (2xN arrays)
% camL,camR : left and right camera parameters
%
%
% OUTPUT:
%
% X : 3D coordinate of points in world coordinates (3xN array)
%
%

%{
ray shooting out from left camera is (x_l,y_l,1)*z + t_l
ray shooting out from right camera is R*(x_r,y_r,1)*z_r + t_r
R is equal to inv(R_l)*R_r
We need to minimize Au - t where 
    A = [(x_l,y_l,1) -R*(x_r,y_r,1)]
    u = [z,z_r] and t = t_r-t_l
%}

N = size(xL,2);
X = zeros(3,N);

tVec = camR.t-camL.t;

for curNum = 1:N

    xLcur = (xL(:,curNum)-camL.c)./camL.m;
    xRcur = (xR(:,curNum)-camR.c)./camR.m;
    pixelLocL = [xLcur(1)/camL.f;xLcur(2)/camL.f;1];
    pixelLocR = [xRcur(1)/camL.f;xRcur(2)/camR.f;1];
    AmatL = pixelLocL;
    AmatR = inv(camL.R)*camR.R*pixelLocR;
    Amat = [AmatL -AmatR];

    %finally, u vector is pinv(A)*t
    u = pinv(Amat)*tVec;

    %averages the two locations together
    locL = AmatL*u(1)+camL.t; locR = AmatR*u(2)+camR.t;
    meanLoc = mean([locL locR],2);
    
    %rotate it back to get the final location
    finalLoc = camL.R*meanLoc;
    
    X(:,curNum) = finalLoc;
    
end


end