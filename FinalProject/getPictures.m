govFile = 'CraterLakeVideos/CraterLakeGovernmentVideo.mp4';
govObj = VideoReader(govFile);

%relevant to pro video
%Good shots around 5:11, so 311 seconds
govObj.currentTime = 311;
numSeconds = 7;
fps = ceil(proObj.FrameRate);
totalFrames = numSeconds*fps;
for i = 0:totalFrames
    picToDisplay = readFrame(govObj);
    if(mod(i,fps) == 0)
        figure
        image(picToDisplay);
    end
    
end
