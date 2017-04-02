function [out] = RN_runTREXpath(exPath)

    %% Check Path for validity
    pathSteps = {'Fix Filenames','Create Trodes Comments','Export',...
        'Generate Matclusts'};
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
    exportIdx = strcmp(str1,'Export');
    exports = strtrim(rem(exportIdx));
    for i=1:numel(exportIdx),
        if exportIdx(i),
            exportIdx(i) = find(strcmp(allExports,exports{i}));
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
            animal_names = [animal_names;...
                repmat({ad(find(ad(1:end-1)==filesep,1,'last'):end-1)},n,1)];
        else
            day_dirs = [day_dirs;selected_dir];
            [ad,dn] = fileparts(selected_dir(1:end-1));
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
                'export_flgs',{repmat([],numel(day_dirs),1)});

    for i=1:numel(day_dirs),
        dd = day_dirs{i};
        if strcmp(dd,filesep)
            dd = dd(1:end);
        end
        RO = dir([day_dirs{i} '*.rec']);
        [~,idx] = sort([Ro.datenum]');
        RO = {RO(idx).name};
        extractionDat(i).rec_order = RO;
        extractionDat(i).prefix = RN_findCommonPrefix(RO);
        extractionDat(i).exportFlgs = repmat({''},1,numel(allExports));
    end

    %% Gather User Input #INTRO
    [exDat,maxJobs] = RN_extractionSetupGUI(exPath,extractionDat);
    if isempty(exDat)
        return;
    else
        extractionDat = exDat;
    end

    %% Run Extraction on each day_directory #BODY
    N = numel(extrationDat);
    logs = cell(1,N);
    for i=1:N,
        exd = extractionDat(i);
        cd(exd.day_dir)

        % Setup log
        mkdir('Logs/')
        logFile = ['Logs/' exd.day_name '_ExtractionLog.log'];
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
                % Make Common Flag
                % #EXPORT
                commonFlag = '';
                if ~isempty(configFiles{i})
                    commonFlag = [' -reconfig ' configFiles{i}];
                end
                commonFlag = [' -rec ' strjoin(RO,' -rec ') ...
                        commonFlag ' -output ' fnMask];
                exType = allExports{exportIdx(j)};
                disp(['Exporting ' exType '...'])
                RN_exportBinary(exType,...
                        [commonFlag ' ' exd.export_flags{exportIdx(j)}]);
                        disp(['Export complete.'])
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
                    RN_createTrodesComments(RO);
                    disp('Done Making Comments.')
                case 'Generate Matclusts'
                    % Generate Matclust Files
                    % #MATCLUST
                    disp('Generating Matclust Files...')
                    outDir = RN_generateMatclusts(maxJobs);
                    disp(['Matclust file saved to ' outDir])
            end
        end
        cd(curr_dir);
        toc
        diary off
    end

end
