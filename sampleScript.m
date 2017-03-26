function [ logFile ] = setupExtractionScript( exctrationSteps )
% sampleExtraction: Sample extraction script that will be built by RN_TrodesExtractionBuilder
%

selected_dir = uigetdir('Selected Directory to Extract, Animal or Day');

% Check is selected_dir is animal dir or day dir
if ~strcmp(selected_dir(end),filesep)
  selected_dir = [selected_dir filesep];
end

recCheck = dir([selected_dir '*.rec']);
if isempty(recCheck)
  animal_dir = selected_dir;
  day_dirs = dir(selected_dir);
  day_dirs = day_dirs(cellfun(@(x) ~strcmp(x(1),'.'),{day_dirs.name}));
  day_dirs = {day_dirs.name}';
else
  [animal_dir,day_dirs] = fileparts(selected_dir);
  day_dirs = {day_dirs};
  animal_dir = [animal_dir filesep];
end

curr_dir = pwd;

%% Get Prereqs
prefixes = {};
configFiles = {};
recOrder = {};
exports = {'spikes','time','LFP','dio','mda','phy'};
exportFlgs = {'','','','','',''};
max_parallel_jobs = 8;
for i=1:numel(day_dirs),

  for j=1:numel(extractionSteps),
    currStep = extractionSteps{j};

    % Get common_prefix
    recFiles = dir([day_dirs{i} '*.rec']) ;
    recFiles = {recFiles.name}';
    common_prefix = RN_findCommonPrefix(recFiles);
    common_prefix = strrep(common_prefix,'.rec','');

    switch currStep
    case 'Fix Filenames'

    case 'Create TodesComments'

    case 'Generate Matclust Files'

    otherwise

    end

  end
end

end  % sampleExtraction


function [ out ] = exampleExtractionScript( animal_dir,day_dirs,prefixes )
% exampleExtractionScript: Eample output of RN_TrodesExtractionBuilder
%
curr_dir = pwd;
animal_dir = '/Volumes/Spyro/Animal_Data/RN2_Exp/RN2';
day_dirs = {'01_20171210','02_20171211'};
cd (animal_dir)

prefixes = {'01_20171210','02_20171211'};



end  % exampleExtractionScript
