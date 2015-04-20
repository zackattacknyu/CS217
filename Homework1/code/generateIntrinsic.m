function [ K ] = generateIntrinsic( cam )
%GENINSTRINSIC Summary of this function goes here
%   Detailed explanation goes here

mx = cam.m(1);
my = cam.m(2);

px = cam.c(1);
py = cam.c(2);

K = [mx*cam.f 0 px;0 my*cam.f py; 0 0 1];

end

