images = cell(1,11);
baseImageName = 'data/owl/owl.mask.png';
baseImageNormal = imread(baseImageName);
baseImage = single(rgb2gray(imread(baseImageName)));

threshold = 100;
[xPts,yPts]=find(baseImage>threshold);
points = [xPts,yPts];
%%
imageName = 'data/owl/owl.';
grayChannelImages = zeros([11 size(baseImage)]);
redChannelImages = zeros([11 size(baseImage)]);
greenChannelImages = zeros([11 size(baseImage)]);
blueChannelImages = zeros([11 size(baseImage)]);
maxIntensity = zeros(1,11);
maxIntensityRow = zeros(1,11);
maxIntensityCol = zeros(1,11);
for i = 1:11
    curImageName = strcat(imageName,num2str(i),'.png');
    curImage = imread(curImageName);
    curImageGray = single(rgb2gray(curImage));
    grayChannelImages(i,:,:) = curImageGray;
    redChannelImages(i,:,:) = single(curImage(:,:,1));
    greenChannelImages(i,:,:) = single(curImage(:,:,2));
    blueChannelImages(i,:,:) = single(curImage(:,:,3));
    maxCols = max(curImageGray,[],1); maxRows = max(curImageGray,[],2);
    [~,colInd] = max(maxCols); [~,rowInd] = max(maxRows);
    maxIntensityRow(i) = rowInd; maxIntensityCol(i) = colInd;
    maxIntensity(i) = curImageGray(rowInd,colInd);
end

%%

estimatedRow = zeros(1,length(xPts));
estimatedRhoRed = zeros(1,length(xPts));
estimatedRhoGreen = zeros(1,length(xPts));
estimatedRhoBlue = zeros(1,length(xPts));
estimatedNormal = zeros(length(xPts),3);
indicesUsed = zeros(1,length(xPts));
shadingThreshold = 100; %used to decide if in shadow or not
numPointsThreshold = 3; %number of points not in a shadow
newIndex = 0;
for i = 1:length(xPts)
   row = xPts(i); col = yPts(i);
   pixel = [col row];
   pixelValues = grayChannelImages(:,row,col); 
   
   pixelValuesRed = redChannelImages(:,row,col);
   pixelValuesGreen = greenChannelImages(:,row,col);
   pixelValuesBlue = blueChannelImages(:,row,col);

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
       
       pixelValuesRedToUse = pixelValuesRed(imgIndicesToUse);
       pixelValuesRedToUse = pixelValuesRedToUse./256; %makes sure it's in 0-1 range
       pixelValuesGreenToUse = pixelValuesGreen(imgIndicesToUse);
       pixelValuesGreenToUse = pixelValuesGreenToUse./256; %makes sure it's in 0-1 range
       pixelValuesBlueToUse = pixelValuesBlue(imgIndicesToUse);
       pixelValuesBlueToUse = pixelValuesBlueToUse./256; %makes sure it's in 0-1 range
       
       estimatedRhoRed(newIndex) = mean(norm(estimatedG).*(pixelValuesRedToUse./pixelValuesToUse));
       estimatedRhoGreen(newIndex) = mean(norm(estimatedG).*(pixelValuesGreenToUse./pixelValuesToUse));
       estimatedRhoBlue(newIndex) = mean(norm(estimatedG).*(pixelValuesBlueToUse./pixelValuesToUse));
       
   end
   
   
   
end

indicesUsed = indicesUsed(1:newIndex);
estimatedRow = estimatedRow(1:newIndex);
estimatedRhoRed = estimatedRhoRed(1:newIndex);
estimatedRhoGreen = estimatedRhoGreen(1:newIndex);
estimatedRhoBlue = estimatedRhoBlue(1:newIndex);
estimatedNormal = estimatedNormal(1:newIndex,:);

%%
numPoints = min(length(indicesUsed),600);
randIndexOrder = randperm(length(indicesUsed));
xyIndiciesToPlot = indicesUsed(randIndexOrder);
xyIndiciesToPlot = xyIndiciesToPlot(1:numPoints);
normalIndicesToPlot = randIndexOrder(1:numPoints);
dispLength = 0.1;
figure
warp(curImage);
hold on
quiver3(yPts(xyIndiciesToPlot),xPts(xyIndiciesToPlot),...
    zeros(length(xyIndiciesToPlot),1),...
    estimatedNormal(normalIndicesToPlot,1)*dispLength,...
    estimatedNormal(normalIndicesToPlot,2)*dispLength,...
    estimatedNormal(normalIndicesToPlot,3)*dispLength)
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

%%
goodInds = find(estimatedRow<=rhoConstant); 

rhoMatrixRed = zeros(size(curImageGray));
rhoMatrixGreen = zeros(size(curImageGray));
rhoMatrixBlue = zeros(size(curImageGray));
for i = 1:length(estimatedRow)
   if(estimatedRow(i) <= rhoConstant)
      pixelIndex = indicesUsed(i);
      row = xPts(pixelIndex); col = yPts(pixelIndex);
      rhoMatrixRed(row,col) = estimatedRhoRed(i)/rhoConstant;
      rhoMatrixGreen(row,col) = estimatedRhoGreen(i)/rhoConstant;
      rhoMatrixBlue(row,col) = estimatedRhoBlue(i)/rhoConstant;
   end
end
figure
imagesc(rhoMatrixRed);
colormap jet;
colorbar;
figure
imagesc(rhoMatrixGreen);
colormap jet;
colorbar;
figure
imagesc(rhoMatrixBlue);
colormap jet;
colorbar;

%%

%calculates average rho for each channel
rhoValueRed = median(estimatedRhoRed(goodInds)./rhoConstant);
rhoValueGreen = median(estimatedRhoGreen(goodInds)./rhoConstant);
rhoValueBlue = median(estimatedRhoBlue(goodInds)./rhoConstant);