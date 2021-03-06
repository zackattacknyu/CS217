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
E = [0 0 1];
L = zeros(11,3);
N = zeros(11,3);
for i = 1:11
    curImageName = strcat(imageName,num2str(i),'.png');
    curImage = single(rgb2gray(imread(curImageName)));
    
    %find points in spot
    [xPts,yPts]=find(curImage>threshold);

    %find the center and uses that as (a,b)
    a = round(mean(xPts)) - centerX; 
    b = round(mean(yPts)) - centerY;
    
    c = sqrt(radius^2 - a^2 - b^2);
    
    N(i,:) = [a/radius b/radius c/radius];
    
    L(i,:) = [2*a*c/radius^2 2*b*c/radius^2 2*c^2/radius^2-1];

end
