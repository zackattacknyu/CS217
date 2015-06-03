topImage = imread('sfmResults1/TopMap_withPoints.png');
figure(1)
ax = image(topImage);
[xLand,yLand] = getpts(1);

%%
xL = [698.491967871486
          676.002008032129
          767.568273092369
          590.861445783133
          521.785140562249
          1084.03413654618
          1344.27510040161
          1112.94979919679
          1633.43172690763
          1651.10240963855];
      
yL = [152.401920438958
          153.898491083676
          113.491083676269
          74.5802469135803
          46.1454046639233
          733.071330589849
          824.362139917695
          556.475994513032
          774.975308641975
          710.622770919067];
%%

scaleImage = imread('sfmResults1/TopMapScale.jpg');
figure(1)
ax = image(scaleImage);
[xS,yS] = getpts(1);
%After running above, it is established that 70 pixels equals 1000 feet
%%
%{
Our (0,0) in x-y point will be at 51 47 in the topographic maps

Points 1-5 will have the first 51 47 as its (0,0), which has coords:
    982.262917933131
    734.182262569832

Points 6-10 will have the second 51 47 as its (0,0)
    1061.29027355623
    647.328910614525
%}
first5147 = [    982.262917933131
    734.182262569832];
second5147 = [1061.29027355623
    647.328910614525];

points = zeros(10,2);
for i = 1:5
   points(i,:) = [xL(i)-first5147(1) yL(i)-first5147(2)];
end
for i = 6:10
   points(i,:) = [xL(i)-second5147(1) yL(i)-second5147(2)]; 
end

xyPoints = points.*(1000/70); %converts pixels to feet in map coords
%%

xyPoints2 =[-4053.87071516636         -8311.14774472677
          -4375.1558557286         -8289.76816408794
         -3067.06635486803         -8867.01684133662
         -5591.44960214283         -9422.88593794645
         -6578.25396244117         -9829.09797008441
          324.912328427857           1224.8917139332
          4042.64038350543          2529.04613290243
          737.993223436573          -1297.8988014499
          8173.44933359143          1823.51997182071
          8425.88765831886            904.1980043506];
%%

%gets x,y,z points
xyzPoints = zeros(10,3);
xyzPoints(1:10,1:2) = xyPoints2;

%points 3,4,5,8 have z=0
%   elevation is 6176 feet, so that is 0 for all the other points
zInit = 6176;
xyzPoints(3,3)=0;
xyzPoints(4,3)=0;
xyzPoints(5,3)=0;
xyzPoints(8,3)=0;

%elevation for wizard island is 6940 feet: points 1,2
xyzPoints(1,3)=6940-zInit;
xyzPoints(2,3)=6940-zInit;

%garfield peak has elevation 7976 feet: point 6
xyzPoints(6,3)=7976-zInit;

%applegate peak has elevation 8126 feet: point 7
xyzPoints(7,3)=8126-zInit;

%dutton cliff has elevation 8106 feet: point 9,10
xyzPoints(9,3)=8106-zInit;
xyzPoints(10,3)=8106-zInit;

%%

%points in the photo where those landmarks occur
photoImage = imread('sfmResults1/Photo_withPoints.png');
figure(1)
ax = image(photoImage);
[xP,yP] = getpts(1);
%%

xP = [882.348184818482
          985.846534653466
          601.424092409241
          1220.30198019802
          1575.15346534653
          818.981848184819
          554.955445544555
          662.678217821782
          282.480198019802
          151.523102310231];
      
yP = [315.945544554456
          315.945544554456
          465.648514851485
          529.806930693069
          569.524045261669
          173.880480905234
          176.935643564357
          334.276520509194
          187.628712871287
          181.518387553041];
%%

points2D = [xP';yP'];
points3D = xyzPoints';

%attempt at calibrating camera
cam = calibrate(points3D,points2D);
%%
save('cameraParams26.mat','cam');