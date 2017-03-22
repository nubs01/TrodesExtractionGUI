function commentFiles = RN_createTrodesComments(sortedFilenames)
% RN_createTrodesComments(sortedFilenames) creates a .trodesComments file
% corresponding to each .h264 file. Files are sorted in the order given my
% sortedFilenames or by date_created is input is left empty

if ~exist('sortedFilenames','var')
    fns = dir('*.h264');
    [~,idx] = sort({fns.date});
    sortedFilenames = {fns(idx).name}';
    sortedFilenames = strtok(sortedFilenames,'.');
end

lastEnd = 0;
reset = 0;
commentFiles = strcat(sortedFilenames,repmat('.trodesComments',numel(sortedFilenames),1));
for i=1:numel(sortedFilenames)
    recName = sortedFilenames{i};
    if isempty(dir(commentFiles{i}))
        disp(['Creating ' commentFiles{i} ':'])
        fid = fopen( commentFiles{i},'w');
        timeStamps= readCameraModuleTimeStamps([recName '.videoTimeStamps']);
        if i>1 && (timeStamps(1)<lastEnd || reset);
            fprintf(fid, '%s\n','time reset');
            disp('time reset');
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
                startEpoch = startEpoch*30000;
                endEpoch = endEpoch*30000;
                fprintf(fid, '%u %s\n',startEpoch,'epoch start');
                fprintf(fid, '%u %s\n',endEpoch,'epoch end');
            end
        else
            disp([RN_readTimeStamp(timeStamps(1)) ' - ' RN_readTimeStamp(timeStamps(end)) '   Epoch All']);
            startEpoch= timeStamps(1)*30000;
            endEpoch= timeStamps(end)*30000;
            fprintf(fid, '%u %s\n',startEpoch,'epoch start');
            fprintf(fid, '%u %s\n',endEpoch,'epoch end');
        end
        lastEnd = timeStamps(end);
        fclose(fid);
        disp(char(10))
    end
end