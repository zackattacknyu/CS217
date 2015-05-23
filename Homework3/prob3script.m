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
indicesUsed = zeros(1,length(xPts));
shadingThreshold = 100; %used to decide if in shadow or not
numPointsThreshold = 3; %number of points not in a shadow
newIndex = 0;
for i = 1:length(xPts)
   row = xPts(i); col = yPts(i);
   pixel = [col row];
   pixelValues = redChannelImages(:,row,col);
   imgIndicesToUse = find(pixelValues>shadingThreshold);

   if(length(imgIndicesToUse) > numPointsThreshold)
       pixelValuesToUse = pixelValues(imgIndicesToUse);
       lightDirs = zeros(length(imgIndicesToUse),2);
       
       for img = 1:length(imgIndicesToUse)
           curIndex = imgIndicesToUse(img);
            lightPixel = [maxIntensityCol(curIndex) maxIntensityRow(curIndex)];
            lightDirs(img,:) = pixel-lightPixel;
       end

       %using standard least-squares linear regression fitting
       estimatedG = ((transpose(lightDirs)*lightDirs)...
           \transpose(lightDirs))*pixelValuesToUse;

       newIndex = newIndex + 1;
       indicesUsed(newIndex) = i;
       estimatedRow(newIndex) = norm(estimatedG);
       estimatedNormal(newIndex,:) = estimatedG/norm(estimatedG);
   end
   
end

indicesUsed = indicesUsed(1:newIndex);
estimatedRow = estimatedRow(1:newIndex);
estimatedNormal = estimatedNormal(1:newIndex,:);

%%
numPoints = min(length(indicesUsed),800);
randIndexOrder = randperm(length(indicesUsed));
xyIndiciesToPlot = indicesUsed(randIndexOrder);
xyIndiciesToPlot = xyIndiciesToPlot(1:numPoints);
normalIndicesToPlot = randIndexOrder(1:numPoints);
figure
imagesc(curImageRed)
hold on
colormap bone
quiver(yPts(xyIndiciesToPlot),xPts(xyIndiciesToPlot),...
    estimatedNormal(normalIndicesToPlot,2),estimatedNormal(normalIndicesToPlot,1))
