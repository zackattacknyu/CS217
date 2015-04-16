[yy,xx] = meshgrid(linspace(0,25.2,10),linspace(0,19.55,8));
zz = zeros(size(xx(:)));
X = [xx(:) yy(:) zz(:)]';

%gets the x values

%obtained using paint and visually recording the pixel location
origin = [588;775];
vectorInYdir = [626;734]-origin;
vectorInXdir = [629;812]-origin;

x = zeros(2,80);
index = 1;
for i = 0:8
   for j=0:10
       x(:,index) = origin+vectorInXdir*j+vectorInYdir*i;
       index = index+1;
   end
end

camEst = calibrate(X,x);