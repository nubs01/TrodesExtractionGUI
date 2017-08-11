function [out] = RN_runTREXpath(exPath)
out = '';
%% Check Path for validity
[valid,suggested] = RN_checkExPath(exPath);
if ~valid
    out = [];
    msgTxt = sprintf('Extraction Path is invalid! Cancelling...\n\nSuggested Path:\n%s\nWould you like to execute this path instead?',...
        strjoin(A,'\n'));
    q = questdlg(msgTxt,'Yes','No','Yes');
    if strcmp(q,'Yes')
        exPath = suggested;
    else
        return;
    end
end

% Figure out what exports are needed
[str1,rem] = strtok(exPath,' ');
allExports = {'spikes','LFP','time','dio','mda','phy'};
tmpIdx = strcmpi(str1,'Export');
exports = cell(1,numel(str1));
exports(tmpIdx) = strtrim(rem(tmpIdx));
exportIdx = zeros(numel(tmpIdx),1);
for i=1:numel(tmpIdx),
    if tmpIdx(i),
        exportIdx(i) = find(strcmpi(allExports,exports{i}));
    end
end


%% Setup day directories
selected_dirs = ListGUI([],sprintf('Select Extraction Directories\n(Animal or Day)'),'dir');
curr_dir = pwd;
animal_dirs = {};
day_dirs = {};
day_names = {};
animal_names = {};

for i = 1:numel(selected_dirs),
    selected_dir = selected_dirs{i};

    % Check is selected_dir is animal dir or day dir
    if ~strcmp(selected_dir(end),filesep)
        selected_dir = [selected_dir filesep];
    end

    recCheck = dir([selected_dir '*.rec']);
    if isempty(recCheck)
        ad = selected_dir;
        dns = dir(selected_dir);
        dns = dns(cellfun(@(x) ~strcmp(x(1),'.'),{dns.name}));
        dns = {dns.name}';
        dds = cellfun(@(x) [ad x],dns,'UniformOutput',0);
        n = numel(dds);
        animal_dirs = [animal_dirs;repmat({ad},n,1)];
        day_dirs = [day_dirs;dds];
        day_names = [day_names;dns];
        if ad(end)==filesep
            ad = ad(1:end-1);
        end
        [~,an] = fileparts(ad);
        animal_names = [animal_names;...
            repmat({an},n,1)];
    else
        day_dirs = [day_dirs;selected_dir];
        [ad,dns] = fileparts(selected_dir(1:end-1));
        day_names = [day_names;dns];
        animal_dirs = [animal_dirs;[ad filesep]];
        [~,an] = fileparts(ad);
        animal_names = [animal_names;an];
    end
end

%% Setup extraction data strcuture
emptArr = {repmat([],numel(day_dirs),1)};
extractionDat = struct('animal_name',animal_names,'day_dir',day_dirs,...
    'day_name',day_names,'prefix',emptArr,...
    'config',emptArr,'rec_order',emptArr,...
    'export_flags',{repmat([],numel(day_dirs),1)});

for i=1:numel(day_dirs),
    dd = extractionDat(i).day_dir;
    if strcmp(dd(end),filesep)
        dd = dd(1:end);
    end
    RO = dir([dd filesep '*.rec']);
    [~,idx] = sort([RO.datenum]');
    RO = {RO(idx).name};
    extractionDat(i).rec_order = RO;
    if numel(RO)>1
        extractionDat(i).prefix = RN_findCommonPrefix(RO);
    else
        a = dir([dd filesep '*.*']);
        a = a(cellfun(@(x) ~strcmp(x(1),'.'),{a.name}));
        a = {a.name};
        extractionDat(i).prefix = RN_findCommonPrefix(a);
    end
    extractionDat(i).export_flags = repmat({''},1,numel(allExports));
end

%% Gather User Input #INTRO
[exDat,maxJobs] = RN_extractionSetupGUI(exPath,extractionDat);
if isempty(exDat)
    return;
else
    extractionDat = exDat;
end

%% Run Extraction on each day_directory #BODY
N = numel(extractionDat);
logs = cell(1,N);
for i=1:N
    exd = extractionDat(i);
    cd(exd.day_dir)

    % Setup log
    mkdir([exd.prefix '_Logs' filesep])
    logFile = [exd.prefix '_Logs' filesep exd.day_name '_ExtractionLog.log'];
    diary(logFile)
    tic
    fprintf('Running extraction for animal %s - day %s (%i/%i)',exd.animal_name,exd.day_name,i,N);

    fn_mask = exd.prefix;
    RO = exd.rec_order;
    config = exd.config;


    for j=1:numel(exPath),
        pStep = exPath{j};

        % Handle Export
        % #EXPORT
        if exportIdx(j)~=0
            % Create time reset comments for exportTimes if Trodes Comments don't already exist
            if strcmp(allExports{exportIdx(j)},'time')
                tcfs = dir([exd.day_dir filesep '*.trodesComments']);
                tcfs = {tcfs.name};
                if isempty(tcfs) || numel(RO) == numel(tcfs)
                    trfs = ListSelectGUI(RO,'Select Rec Files with Time Resets',1);
                    for k=1:numel(RO)
                        if any(trfs<=k)
                            tmpFN = [exd.day_dir filesep strtok(RO{k},'.') '.trodesComments'];
                            fid = fopen(tmpFN,'w');
                            fprintf(fid,'time reset');
                            fclose(fid);
                            clear tmpFN
                        end
                    end
                end
            end

            % Make Common Flag
            % #EXPORT
            commonFlag = '';
            if ~isempty(exd.config)
                commonFlag = [' -reconfig ' exd.config];
            end
            commonFlag = [' -rec ' strjoin(RO,' -rec ') ...
                commonFlag ' -output ' fn_mask];
            exType = allExports{exportIdx(j)};

            % Export
            disp(['Exporting ' exType '...'])
            RN_exportBinary(exType,...
                [commonFlag ' ' exd.export_flags{exportIdx(j)}]);
            disp('Export complete.')
            continue;
        end

        switch pStep
            case 'Fix Filenames'
                % Fix Filenames and Change prefix
                % #FIX_FILENAMES
                disp('Fixing Filenames...')
                [fnMask,old_prefix] = RN_fixFilenames([],fn_mask);
                % Fix rec_order if needed
                if ~strcmp(fnMask,old_prefix)
                    RO = cellfun(@(x) strrep(x,old_prefix,fnMask),RO,...
                        'UniformOutput',false);
                end
            case 'Create Trodes Comments'
                % Create Trodes Comments
                % #TRODESCOMMENTS
                disp('Creating Trodes Comments...')
                if isrow(RO)
                    RO1 = RO';
                else
                    RO1 = RO;
                end
                RO1 = strrep(RO1,'.rec','');
                RN_createTrodesComments(RO1);
                disp('Done Making Comments.')
            case 'Generate Matclusts'
                % Generate Matclust Files
                % #MATCLUST
                disp('Generating Matclust Files...')
                outDir = RN_generateMatclusts(maxJobs);
%                 disp(['Matclust file saved to ' outDir])
        end
    end
    cd(curr_dir);
    toc
    diary off
end

end
