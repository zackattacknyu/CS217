govFile = 'CraterLakeVideos/CraterLakeGovVideo2.mp4';
govObj = VideoReader(govFile);

shot1 = 'sfmResults3/shot3.avi';
shot1obj = VideoWriter(shot1);
open(shot1obj);

govObj.currentTime = 228; %at 3:48
numSeconds = 3;
fps = ceil(govObj.FrameRate);
totalFrames = numSeconds*fps;
numIterFrames = ceil(fps/10);
imgNum = 1;
for i = 0:totalFrames
    picToDisplay = readFrame(govObj);
    writeVideo(shot1obj,picToDisplay)
    if(mod(i,numIterFrames) == 0)
        fileName = strcat('sfmPics3/shot',num2str(imgNum),'.jpg');
        imwrite(picToDisplay,fileName);
        imgNum
        imgNum = imgNum + 1;
    end
    
end
close(shot1obj)