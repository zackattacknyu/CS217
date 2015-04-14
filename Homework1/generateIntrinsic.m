function [ K ] = generateIntrinsic( cam )
%GENINSTRINSIC Summary of this function goes here
%   Detailed explanation goes here

mx = cam.m(1);
my = cam.m(2);

px = cam.c(1);
py = cam.c(2);

K1 = [mx 0 0;0 my 0;0 0 1];
K2 = [cam.f 0 px;0 cam.f py; 0 0 1];

K = K1*K2;

end

