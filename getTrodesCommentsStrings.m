function [out,sortedFilenames] = getTrodesCommentsStrings(rawDir,sortedFilenames)
currDir = pwd;
cd(rawDir)
useVideo = 0;
reset = 0;
lastEnd = 0;
clockrate = 30000;

if ~isempty(dir('*.videoTimeStamps'))
    useVideo = 1;
elseif isempty(dir('*.time'))
    error('Cannot Create trodesComments: No Video Time Stamps Files or Time Folder Found. If you did not record video please create a .trodesComments file with ''time reset'' ONLY for rec files that have resets THEN extract Time binaries before creating Trodes Comments.')
end

if useVideo
    if ~exist('sortedFilenames','var')
        fns = dir('*.h264');
        if isempty(fns)
            fns = dir('*.videoTimeStamps');
        end
        [~,idx] = sort({fns.date});
        sortedFilenames = {fns(idx).name}';
    end
    sortedFilenames = strtok(sortedFilenames,'.');
    Nfiles = numel(sortedFilenames);
    out = repmat({''},Nfiles,1);

    for i=1:Nfiles
        outStr = '';
        fn = sortedFilenames{i};
        timeStamps = readCameraModuleTimeStamps([fn '.videoTimeStamps']);

        if i>1 && (timeStamps(1)<lastEnd || reset);
            outStr = char(outStr,'time reset');
            reset = 1;
        end

        % Check for pauses > 1sec
        pauses = find(diff(timeStamps)>=1);
        if ~isempty(pauses)
            for k=1:numel(pauses)+1,
                if k==1,
                    startEpoch = timeStamps(1);
                else
                    startEpoch = timeStamps(pauses(k-1)+1);
                end
                if k==numel(pauses)+1
                    endEpoch = timeStamps(end);
                else
                    endEpoch = timeStamps(pauses(k));
                end
                disp([RN_readTimeStamp(startEpoch) ' - ' RN_readTimeStamp(endEpoch) '   Epoch ' num2str(k)]);
                startEpoch = startEpoch*clockrate;
                endEpoch = endEpoch*clockrate;
                outStr = char(outStr,sprintf('%0.0f %s',startEpoch,'epoch start'));
                outStr = char(outStr,sprintf('%0.0f %s',endEpoch,'epoch end'));
                if isempty(outStr(1,:))
                    outStr = outStr(2:end,:);
                end
            end
        else
            startEpoch= timeStamps(1)*clockrate;
            endEpoch= timeStamps(end)*clockrate;
            outStr = char(outStr,sprintf('%0.0f %s',startEpoch,'epoch start'));
            outStr = char(outStr,sprintf('%0.0f %s',endEpoch,'epoch end'));
            outStr = outStr(2:end,:);
        end
        out{i} = outStr;
        lastEnd = timeStamps(end);
    end
else
    % use time folder to create comments
    timeDir = dir('*.time');
    timeDir = [timeDir.name filesep];
    epochs = getEpochs(1);

    if ~exist('sortedFilenames','var')
        recFiles = dir('*.rec');
        [~,idx] = sort([recFiles.datenum],'ascend');
        recFiles = recFiles(idx);
        recFiles = {recFiles.name};
        sortedFilenames = strtok(recFiles,'.');
        offsetFiles = strcat(sortedFilenames,'.offset.txt');
    else
        offsetFiles = strcat(sortedFilenames,'.offset.txt');
    end
    timeDatFile = dir([timeDir '*.time.dat']);
    timeDatFile = [timeDir timeDatFile.name];
    t = readTrodesExtractedDataFile(timeDatFile);
    clockrate = t.clockrate;

    offsets = zeros(1,numel(offsetFiles));
    for i=1:numel(offsets)
        fn = [timeDir offsetFiles{i}];
        fid = fopen(fn,'r');
        if fid==-1
            disp(['Offset file not found at ' fn])
            continue;
        end
        offsets(i) = fscanf(fid,'%i');
        fclose(fid);
    end
    offsets = offsets/clockrate;

    % TODO: Fix this
    if numel(offsets) < size(epochs,1)
        error('Cannot create trodes comments without 1 rec file per epoch. Program not yet able to determine which epochs are grouped.')
    end

    for i=1:numel(offsets)
        outStr = '';
        if reset || offsets(i)>0
            outStr = char(outStr,'time reset');
            reset = 1;
        end
        outStr = char(outStr,sprintf('%0.0f epoch start',epochs(i,1)*clockrate));
        outStr = char(outStr,sprintf('%0.0f epoch end',epochs(i,2)*clockrate));
        outStr = outStr(2:end,:);
        out{i} = outStr;
    end
    cd(currDir)
end
