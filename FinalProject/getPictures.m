govFile = 'CraterLakeVideos/CraterLakeGovernmentVideo.mp4';
govObj = VideoReader(govFile);

%relevant to pro video
%Good shots around 5:11, so 311 seconds
govObj.currentTime = 309;
numSeconds = 13;
fps = ceil(govObj.FrameRate);
totalFrames = numSeconds*fps;
numIterFrames = ceil(fps/3);
imgNum = 1;
for i = 0:totalFrames
    picToDisplay = readFrame(govObj);
    if(mod(i,numIterFrames) == 0)
        fileName = strcat('sfmPics1/shot',num2str(imgNum),'.png');
        imwrite(picToDisplay,fileName);
        imgNum
        imgNum = imgNum + 1;
        %figure
        %image(picToDisplay);
    end
    
end
