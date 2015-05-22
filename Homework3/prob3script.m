images = cell(1,11);
baseImageName = 'data/owl/owl.mask.png';
baseImageNormal = imread(baseImageName);
baseImage = single(rgb2gray(imread(baseImageName)));
%%
imageName = 'data/owl/owl.';
redChannelImages = cell(1,11);
for i = 1:11
    curImageName = strcat(imageName,num2str(i),'.png');
    curImage = imread(curImageName);
    redChannelImages{i} = curImage(:,:,1);
end
