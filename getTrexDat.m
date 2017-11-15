function [exDat,exPath] = getTrexDat(exPath,exDirs)

    if ~exist('exPath','var') || isempty(exPath)
        exPath = {'Fix Filenames','Create Trodes Comments',...
                  'Export Spikes','Export LFP','Export Time',...
                  'Export DIO','Generate Matclusts'};
    end

    % Check if exDirs are animal or day dirs and make day dir list 
    if ~exist('exDirs','var')
        exDirs = ListGUI([],sprintf('Select Extraction Directories\n(Animal or Day)'),'dircontent');
    end
    rmv = [];
    dayDirs = {};
    for i=1:numel(exDirs)
        dayDirs = [dayDirs;getDayDirectories(exDirs{i})];
    end

    allExports = {'spikes','LFP','time','dio','mda','phy'};

    % Extract animal directories and animal names and day names from day dirs
    dayNames = {};
    animalNames = {};
    animalDirs = {};
    for i=1:numel(dayDirs),
        dd = dayDirs{i};
        if dd(end)==filesep,
            dd = dd(1:end-1);
        else
            dayDirs{i} = [dayDirs{i} filesep];
        end
        [ad,dns] = fileparts(dd);
        dayNames = [dayNames;dns];
        animalDirs = [animalDirs;[ad filesep]];
        [~,an] = fileparts(ad);
        animalNames = [animalNames;an];
    end
    emptyArr = {repmat([],numel(dayDirs),1)};
    exDat = struct('animal_name',animalNames,'day_dir',dayDirs,...
        'day_name',dayNames,'prefix',emptyArr,...
        'config',emptyArr,'rec_order',emptyArr,...
        'export_flags',emptyArr);
        
    for i=1:numel(dayDirs),
        dd = exDat(i).day_dir(1:end-1);
        RO = dir([dd filesep '*.rec']);
        [~,idx] = sort([RO.datenum]');
        RO = {RO(idx).name};
        exDat(i).rec_order = RO;
        if numel(RO)>1
            exDat(i).prefix = RN_findCommonPrefix(RO);
        else
            a = dir([dd filesep '*.*']);
            a = a(cellfun(@(x) ~strcmp(x(1),'.'),{a.name}));
            a = {a.name};
            exDat(i).prefix = RN_findCommonPrefix(a);
        end
        exDat(i).export_flags = repmat({''},1,numel(allExports));
    end

