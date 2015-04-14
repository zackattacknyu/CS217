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
ray shooting out from left camera is R_l*(x_l,y_l,1)*z_l + t_l
ray shooting out from right camera is R_r*(x_r,y_r,1)*z_r + t_r
We need to minimize Au - t where 
    A = [R_l*(x_l,y_l,1) -R_r*(x_r,y_r,1)]
    u = [z_l,z_r] and t = t_r-t_l
%}

N = size(xL,2);
X = zeros(3,N);

tVec = camR.t-camL.t;

for curNum = 1:N

    xLcur = xL(:,curNum);
    xRcur = xR(:,curNum);
    pixelLocL = [xLcur(1)/camL.f;xLcur(2)/camL.f;1];
    pixelLocR = [xRcur(1)/camL.f;xRcur(2)/camR.f;1];
    AmatL = camL.R*pixelLocL;
    AmatR = camR.R*pixelLocR;
    Amat = [AmatL -AmatR];

    %finally, u vector is pinv(A)*t
    u = pinv(Amat)*tVec;

    %averages the two locations together
    locL = AmatL*u(1)+camL.t; locR = AmatR*u(2)+camR.t;
    X(:,curNum) = mean([locL locR],2);
    
end


end