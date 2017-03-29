%% Setup Extraction script
% #INTRO

% Define animal directory and day directories to extract
animal_dir = '/Volumes/Spyro/Animal_Data/EG9_Experiment/EG9';
day_dirs = {'160730_PreHPC_Baseline',...
            '160731_HPC_Baseline',...
            '160801_HPC_SalKet',...
            '160802_HPC_SalKet'};
cd(animal_dir);

% Define file prefixes, used to fix filenames in a day_dir and for creating
% export folders
% #FIX_FILENAMES
prefixes = {'160730_PreHPC_Baseline',...
            '160731_HPC_Baseline',...
            '160801_HPC_SalKet',...
            '160802_HPC_SalKet'};

% Define config files, empty string uses config in rec for extraction
% #TRODESCOMMENTS #EXPORT
configFiles = {'',...
              '',...
              '',...
              ''};

% Set Rec Order for each day folder
% #EXPORT
RecOrder = {{'160730_PreHPC_Baseline.rec'},...
    {'160731_HPC_Baseline.rec'},...
    {'160801_HPC_SalKet.rec',...
    '160801_HPC_SalKet_PostSaline.rec',...
    '160801_HPC_SalKet_PostKetamine.rec'},...
    {'160802_HPC_SalKet_Pre.rec',...
    '160802_HPC_SalKet_PostSaline.rec',...
    '160802_HPC_SalKet_PostKetamine.rec'}};

% Export types and customFlags for each export function
% #EXPORT
exportTypes = {'spikes','LFP','times','dio','mda','phy'};
exportCustomFlgs = {'',...
    '',...
    '',...
    '',...
    '',...
    ''};

% Max parallel jobs for Matclust file generation
% #MATLCUST
maxParallelJobs = 8;

%% Loops through day_dirs and execute extraction in each folders
% #BODY
for i=1:nDays,
    day = day_dirs{i};
    disp(['Running extraction script in ' day])
    cd(day);
    fnMask = prefixes{i};

    % Setup log
    mkdir('Logs/')
    logFile = ['Logs/' prefixes{i} '_ExtractionLog.log'];
    diary(logFile)

    % Fix Filenames and Change prefix
    % #FIX_FILENAMES
    disp('Fixing Filenames...')
    [fnMask,old_prefix] = RN_fixFilenames([],prefixes{i});

    % Fix Rec names if needed
    % #TRODESCOMMENTS #EXPORT
    sortedRecs = RecOrder{i};
    if ~strcmp(fnMask,old_prefix)
        sortedRecs = cellfun(@(x) strrep(x,old_prefix,fnMask),sortedRecs,...
        'UniformOutput',false);
    end

    % Create Trodes Comments
    % #TRODESCOMMENTS
    RN_createTrodesComments(sortedRecs);

    % Make Common Flag
    % #EXPORT
    commonFlag = '';
    if ~isempty(configFiles{i})
        commonFlag = [' -reconfig ' configFiles{i}];
    end
    commonFlag = [' -rec ' strjoin(sortedRecs,' -rec ') commonFlag ' -output ' fnMask];

    % Run exports
    % #EXPORT
    for j=1:numel(exportTypes),
        disp(['Exporting ' exportTypes{j} '...'])
        RN_exportBinary(exportTypes{j},[commonFlag ' ' exportFlgs{j}])
    end
