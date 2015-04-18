[yy,xx] = meshgrid(linspace(0,25.2,10),linspace(0,19.55,8));
zz = zeros(size(xx(:)));
X = [xx(:) yy(:) zz(:)]';

%gets the x values

%for image 13
%obtained using paint and visually recording the pixel location
origin = [739,1081];
vectorInYdir = [677;983]-origin;
vectorInXdir = [843;1015]-origin;
x13 = zeros(2,80);
index = 1;
for i = 0:8
   for j=0:10
       x13(:,index) = origin+vectorInXdir*j+vectorInYdir*i;
       index = index+1;
   end
end

%for image 14
%obtained using paint and visually recording the pixel location
origin = [344;657];
vectorInYdir = [433;689]-origin;
vectorInXdir = [399;583]-origin;
x14 = zeros(2,80);
index = 1;
for i = 0:8
   for j=0:10
       x14(:,index) = origin+vectorInXdir*j+vectorInYdir*i;
       index = index+1;
   end
end

camEst = calibrate(X,x);