function [ Ext ] = generateExtrinsic( cam )
%GENINSTRINSIC Summary of this function goes here
%   Detailed explanation goes here

Rinv = inv(cam.R);

Ext = [Rinv -Rinv*cam.t];

end

