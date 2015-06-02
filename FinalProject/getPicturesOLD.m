aFile = 'CraterLakeVideos/CraterLakeAmateurVideo.avi';
aObj = VideoReader(aFile);

proFile = 'CraterLakeVideos/CraterLakeProfessionalVideo.mp4';
proObj = VideoReader(proFile);
%%
govFile = 'CraterLakeVideos/CraterLakeGovernmentVideo.mp4';
govObj = VideoReader(govFile);

%relevant to pro video
%Good shots around 5:11, so 311 seconds
govObj.currentTime = 311;
numSeconds = 7;
fps = ceil(govObj.FrameRate);
totalFrames = numSeconds*fps;
for i = 0:totalFrames
    picToDisplay = readFrame(govObj);
    if(mod(i,fps) == 0)
        figure
        image(picToDisplay);
    end
    
end

%%

%relevant to amateur video
%at 60 seconds, the amateur video has good shots
startTime = 70;
numFramesToAvg = 5;
picToDisplay = averageFrames(aObj,startTime,numFramesToAvg);
figure
image(picToDisplay);
figure
image(imsharpen(picToDisplay));

%%

%relevant to pro video
%Good shots around 4:30, so 270 seconds
proObj.currentTime = 273;
numSeconds = 7;
fps = ceil(proObj.FrameRate);
totalFrames = numSeconds*fps;
for i = 0:totalFrames
    picToDisplay = readFrame(proObj);
    if(mod(i,fps) == 0)
        figure
        image(picToDisplay);
    end
    
end