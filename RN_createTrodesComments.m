function commentFiles = RN_createTrodesComments(sortedFilenames)
% RN_createTrodesComments(sortedFilenames) creates a .trodesComments file
% corresponding to each .h264 file. Files are sorted in the order given my
% sortedFilenames or by date_created is input is left empty

if ~exist('sortedFilenames','var')
    [commentStr,sortedFilenames] = getTrodesCommentsStrings(pwd);
else
    [commentStr,sortedFilenames] = getTrodesCommentsStrings(pwd,sortedFilenames);
end

commentFiles = strcat(sortedFilenames,'.trodesComments');
for i=1:numel(sortedFilenames)
        disp(['Creating ' commentFiles{i} ':'])
        fid = fopen( commentFiles{i},'w');
        for k=1:size(commentStr{i},1),
            fprintf(fid,'%s\n',strtrim(commentStr{i}(k,:)));
            disp(strtrim(commentStr{i}(k,:)))
        end
        fclose(fid);
        disp(char(10))
end
