function [ meanDiff ] = part4function( Input,Orig3Dpts,mod2Dpts )
%PART4FUNCTION Summary of this function goes here
%   Detailed explanation goes here

[Rmatrix,tVec] = part4Input(Input);

MainMat = [Rmatrix tVec];

meanDiff = mean(abs(MainMat*Orig3Dpts-mod2Dpts),2);

end

