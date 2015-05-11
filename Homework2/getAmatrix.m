function [ equMatrix ] = getAmatrix( X1,X2,Y1,Y2,indices )
%GETAMATRIX Summary of this function goes here
%   Detailed explanation goes here

%taken from paper "In Defense of the Eight Point Algorithm"
%   section 2.2
equMatrix = ones(length(indices),9);
for j = 1:length(indices)
    
    i = indices(j);
    %If (u,v,1) and (u',v',1) are the pts, then this row should be:
    %(uu', uv', u, vu', vv', v, u', v', 1)
    equMatrix(j,:) = [X1(i)*X2(i) X1(i)*Y2(i) X1(i) ...
        Y1(i)*X2(i) Y1(i)*Y2(i) Y1(i)...
        X2(i) Y2(i) 1]; 
end

end

