function [ meanDiff ] = part4function( Input,Orig3Dpts,mod2Dpts )
%PART4FUNCTION Summary of this function goes here
%   Detailed explanation goes here

%deconstrucs the input
theta1 = Input(1);
theta2 = Input(2);
theta3 = Input(3);

xt = Input(4);
yt = Input(5);
zt = Input(6);

Rx = [cos(theta1) -sin(theta1) 0; ...
    sin(theta1) cos(theta1) 0;...
    0 0 1];
Ry = [cos(theta2) 0 -sin(theta2); ...
    0 1 0;...
    sin(theta2) 0 cos(theta2)];
Rz = [1 0 0;
    0 cos(theta3) -sin(theta3); ...
    0 sin(theta3) cos(theta3)];

tVec = [xt;yt;zt];
Rmatrix = Rx*Ry*Rz;

MainMat = [Rmatrix tVec];

meanDiff = mean(abs(MainMat*Orig3Dpts-mod2Dpts),2);

end

