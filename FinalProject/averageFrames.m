function [ outputFrame ] = averageFrames( videoObj,startTime,numFrames )
%AVERAGEFRAMES Summary of this function goes here
%   Detailed explanation goes here

videoObj.CurrentTime = startTime;
pics = zeros(videoObj.Height,videoObj.Width,3,numFrames);
for i = 1:numFrames
    pics(:,:,:,i) = readFrame(videoObj);
end

outputFrame = uint8(mean(pics,4));

end

