images = cell(1,11);
baseImageName = 'data/chrome/chrome.mask.png';
baseImage = single(rgb2gray(imread(baseImageName)));

%image value greater than threshold is white
%   otherwise pixel is considered black
threshold=200;

%find points in circle
[xPts,yPts]=find(baseImage>threshold);

%gets the center of the circle
centerX = round(mean(xPts)); 
centerY = round(mean(yPts));

%gets the radius of the circle
radiusX = (max(xPts)-min(xPts))/2;
radiusY = (max(yPts)-min(yPts))/2;
radius = round(mean([radiusX,radiusY]));



%%

imageName = 'data/chrome/chrome.';
for i = 1:11
    curImageName = strcat(imageName,num2str(i),'.png');
    curImage = single(rgb2gray(imread(curImageName)));
    
    %find points in spot
    [xPts,yPts]=find(curImage>threshold);

    %find the center and uses that as (a,b)
    a = round(mean(xPts)) - centerX; 
    b = round(mean(yPts)) - centerY;
    
    c = sqrt(radius^2 - a^2 - b^2);
    
    dir = [a/radius b/radius c/radius];

end

%%

h=2*radius;
E = [a b c-h];
E = E./norm(E,2);
N = dir./norm(dir,2);
L = 2*N*(dot(E,N)) - E;
