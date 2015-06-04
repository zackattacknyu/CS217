%govFile = 'CraterLakeVideos/CraterLakeGovernmentVideo.mp4';
govFile = 'CraterLakeVideos/CraterLakeProfessionalVideo.mp4';
govObj = VideoReader(govFile);

shot1 = 'sfmResults1/shot2.avi';
shot1obj = VideoWriter(shot1);
open(shot1obj);

%relevant to pro video
%Good shots around 5:11, so 311 seconds
%govObj.currentTime = 310;
%numSeconds = 6;
govObj.currentTime = 285; %at 4:45
numSeconds = 7;
fps = ceil(govObj.FrameRate);
totalFrames = numSeconds*fps;
numIterFrames = ceil(fps/3);
imgNum = 1;
for i = 0:totalFrames
    picToDisplay = readFrame(govObj);
    writeVideo(shot1obj,picToDisplay)
    if(mod(i,numIterFrames) == 0)
        fileName = strcat('sfmPics1J/shot',num2str(imgNum),'.JPEG');
        %imwrite(picToDisplay,fileName);
        imgNum
        imgNum = imgNum + 1;
        %figure
        %image(picToDisplay);
    end
    
end
