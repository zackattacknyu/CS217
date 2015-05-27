images = cell(1,11);
baseImageName = 'data/owl/owl.mask.png';
baseImageNormal = imread(baseImageName);
baseImage = single(rgb2gray(imread(baseImageName)));

threshold = 100;
[xPts,yPts]=find(baseImage>threshold);
points = [xPts,yPts];
%%
imageName = 'data/owl/owl.';
redChannelImages = zeros([11 size(baseImage)]);
maxIntensity = zeros(1,11);
maxIntensityRow = zeros(1,11);
maxIntensityCol = zeros(1,11);
for i = 1:11
    curImageName = strcat(imageName,num2str(i),'.png');
    curImage = imread(curImageName);
    curImageRed = single(curImage(:,:,1));
    curImageGray = single(rgb2gray(curImage));
    redChannelImages(i,:,:) = curImageRed;
    maxCols = max(curImageGray,[],1); maxRows = max(curImageGray,[],2);
    [~,colInd] = max(maxCols); [~,rowInd] = max(maxRows);
    maxIntensityRow(i) = rowInd; maxIntensityCol(i) = colInd;
    maxIntensity(i) = curImageGray(rowInd,colInd);
end

%%

estimatedRow = zeros(1,length(xPts));
estimatedNormal = zeros(length(xPts),3);
indicesUsed = zeros(1,length(xPts));
shadingThreshold = 100; %used to decide if in shadow or not
numPointsThreshold = 3; %number of points not in a shadow
newIndex = 0;
for i = 1:length(xPts)
   row = xPts(i); col = yPts(i);
   pixel = [col row];
   pixelValues = redChannelImages(:,row,col); 

   %{
   NOTE: 
   The following code block uses thresholding to pick
        out the proper pixels and then uses least squares
        to get the normal vector
   %}
   imgIndicesToUse = find(pixelValues>shadingThreshold);
   if(length(imgIndicesToUse) > numPointsThreshold)
       pixelValuesToUse = pixelValues(imgIndicesToUse);
       pixelValuesToUse = pixelValuesToUse./256; %makes sure it's in 0-1 range
       lightDirs = zeros(length(imgIndicesToUse),3);
       
       for img = 1:length(imgIndicesToUse)
           curIndex = imgIndicesToUse(img);
            lightPixel = [maxIntensityCol(curIndex) maxIntensityRow(curIndex)];
            currentLightDir = pixel-lightPixel;
            currentLightDir3D = [currentLightDir 1];
            currentLightDir3D = currentLightDir3D./norm(currentLightDir3D);
            lightDirs(img,:) = currentLightDir3D;
       end

       %using standard least-squares linear regression fitting
       estimatedG = ((transpose(lightDirs)*lightDirs)...
           \transpose(lightDirs))*pixelValuesToUse;

       newIndex = newIndex + 1;
       indicesUsed(newIndex) = i;
       curEstNormal = estimatedG/norm(estimatedG);
       if(curEstNormal(3) < 0)
          curEstNormal = -curEstNormal; 
       end
       estimatedRow(newIndex) = norm(estimatedG);
       estimatedNormal(newIndex,:) = curEstNormal;
       
   end

   %{
   
   NOTE: 
   The following code block was used
   to do weighted least squares. Results were not too much
    different from thresholding, so I stuck to the above method
   
   pixelValuesToUse = (pixelValues./256).^2; %makes sure it's in 0-1 range
   lightDirs = zeros(11,3);

   for curIndex = 1:11
        lightPixel = [maxIntensityCol(curIndex) maxIntensityRow(curIndex)];
        currentLightDir = pixel-lightPixel;
        pixelVal = pixelValues(curIndex)/256;
        currentLightDir3D = [currentLightDir 1];
        currentLightDir3D = currentLightDir3D./norm(currentLightDir3D);
        lightDirs(curIndex,:) = currentLightDir3D.*pixelVal;
   end

   %using standard least-squares linear regression fitting
   estimatedG = ((transpose(lightDirs)*lightDirs)...
       \transpose(lightDirs))*pixelValuesToUse;
   %} 
   
   
   
end

indicesUsed = indicesUsed(1:newIndex);
estimatedRow = estimatedRow(1:newIndex);
estimatedNormal = estimatedNormal(1:newIndex,:);

%%
numPoints = min(length(indicesUsed),600);
randIndexOrder = randperm(length(indicesUsed));
xyIndiciesToPlot = indicesUsed(randIndexOrder);
xyIndiciesToPlot = xyIndiciesToPlot(1:numPoints);
normalIndicesToPlot = randIndexOrder(1:numPoints);
figure
warp(curImage);
hold on
quiver3(yPts(xyIndiciesToPlot),xPts(xyIndiciesToPlot),...
    zeros(length(xyIndiciesToPlot),1),...
    estimatedNormal(normalIndicesToPlot,1),...
    estimatedNormal(normalIndicesToPlot,2),...
    estimatedNormal(normalIndicesToPlot,3))
%%

%many of the rho values were extremely high
%   so it is possible they were noisy estimates
%I thus count the lowest 80% of the values as 
%   the likely rho values to use in the estimate
sortedRhoValues = sort(estimatedRow);
numValsToUse = floor(length(sortedRhoValues)*0.80);
rhoValsToUse = sortedRhoValues(1:numValsToUse);

%likely value for k*c*(1/pi)
rhoConstant = max(rhoValsToUse);

normalizedRho = rhoValsToUse./rhoConstant;

finalRhoEstimate = median(normalizedRho);
