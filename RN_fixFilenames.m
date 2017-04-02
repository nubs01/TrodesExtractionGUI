function [new_prefix,common_prefix] = RN_fixFilenames(dayDir,preFlg)
% RN_fixFilenames goes through all files in raw Trodes data dir (day
% folder) and removes the .1. from filenames. It also changes
% videoTimeStamps.cameraHWFrameCount to just .cameraHWFrameCount. Finally,
% it will allow you to change the common prefix on file names if you
% desire. If you have filenames containing .2. or .3. up to .9. they will
% be changed to _2. or _3. etc.
% RN_fixFilenames(dayDir,preflg)

% Change directory if necessary
cdFlg = 0;
if exist('dayDir','var') && ~isempty(dayDir)
    currDir = pwd;
    [~,b] = fileparts(pwd);
    if ~strcmp(dayDir,b) && ~strcmp(dayDir,pwd)
        cd(dayDir)
        cdFlg = 1;
    end
else
    dayDir = pwd;
    currDir = pwd;
end

new_prefix = '';
common_prefix='';

% Get current common_preifx of rec files
[~,dayName] = fileparts(dayDir);
recFiles = dir('*.rec');
recFiles = {recFiles.name}';
if isempty(recFiles)
    if cdFlg
        cd(currDir)
    end
    return;
end
common_prefix = RN_findCommonPrefix(recFiles);
common_prefix = strrep(common_prefix,'.rec','');

% Determine if program will query for a new prefix, use a given prefix or
% not change the prefix
if ~exist('preFlg','var') || preFlg==1
    preFlg = 1;
elseif ischar(preFlg)
    prefix = preFlg;
    preFlg = 0;
else
    prefix = common_prefix;
    preFlg = 0;
end

% Query user for prefix
while preFlg || isempty(prefix)
    prefix = inputdlg({'Change common prefix from:','To:'},'Change File Prefixes',1,{common_prefix,dayName});
    if ~isempty(prefix)
        if isempty(strfind(common_prefix,prefix{1}))
            h = msgbox('The from field must contain a valid existing common prefix.');
            waitfor(h);
        else
            common_prefix = prefix{1};
            prefix = prefix{2};
            preFlg = 0;
        end
    else
        preFlg = 0;
        prefix = common_prefix;
    end
end

% Loop through all files
allFiles = dir('*.*');
allFiles = {allFiles(~[allFiles.isdir]).name}';
if isempty(allFiles)
    if cdFlg
        cd(currDir);
    end
    return;
end

for i=1:numel(allFiles),
    fn = allFiles{i};
    % Adjust Filename
    fn1 = fn;
    if ~isempty(strfind(fn1,'.1.'))
        fn1 = strrep(fn1,'.1.','.');
    end
    for n=2:9,
        if ~isempty(strfind(fn1,sprintf('.%g.',n)))
            fn1 = strrep(fn1,sprintf('.%g.',n),sprintf('_%g.',n));
        end
    end
    if ~isempty(strfind(fn1,'videoTimeStamps.cameraHWFrameCount'))
        fn1 = strrep(fn1,'videoTimeStamps.cameraHWFrameCount','cameraHWFrameCount');
    end
    if ~isempty(prefix)
        fn1 = strrep(fn1,common_prefix,prefix);
    end

    fn1 = strrep(fn1,' ','_');
    
    % Change filename if needed
    if ~strcmp(fn,fn1)
        disp(['Changing filename ' fn ' to ' fn1])
        movefile(fn,fn1)
    end
end

% Get new common_prefix for output
recFiles = dir('*.rec');
recFiles = {recFiles.name}';
new_prefix = RN_findCommonPrefix(recFiles);
new_prefix = strrep(new_prefix,'.rec','');

if cdFlg
    cd(currDir);
end
