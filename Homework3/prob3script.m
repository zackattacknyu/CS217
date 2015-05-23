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
    curImageRed = curImage(:,:,1);
    redChannelImages(i,:,:) = curImageRed;
    maxCols = max(curImageRed,[],1); maxRows = max(curImageRed,[],2);
    [~,colInd] = max(maxCols); [~,rowInd] = max(maxRows);
    maxIntensityRow(i) = rowInd; maxIntensityCol(i) = colInd;
    maxIntensity(i) = curImageRed(rowInd,colInd);
end

%%

estimatedRow = zeros(1,length(xPts));
estimatedNormal = zeros(length(xPts),2);
for i = 1:length(xPts)
   row = xPts(i); col = yPts(i);
   pixel = [col row];
   pixelValues = redChannelImages(:,row,col);
   lightDirs = zeros(11,2);
   for img = 1:11
        lightPixel = [maxIntensityCol(img) maxIntensityRow(img)];
        lightDirs(img,:) = pixel-lightPixel;
   end
   
   %using standard least-squares linear regression fitting
   estimatedG = ((transpose(lightDirs)*lightDirs)...
       \transpose(lightDirs))*pixelValues;
   
   estimatedRow(i) = norm(estimatedG);
   estimatedNormal(i,:) = estimatedG/norm(estimatedG);
end

%%
quiver(yPts,xPts,estimatedNormal(:,2),estimatedNormal(:,1))

%%
numPoints = 800;
ptsToPlot = randperm(length(xPts));
ptsToPlot = ptsToPlot(1:numPoints);
quiver(yPts(ptsToPlot),xPts(ptsToPlot),...
    estimatedNormal(ptsToPlot,2),estimatedNormal(ptsToPlot,1))
