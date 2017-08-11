function new_config = RN_customizeTrodesConfig(baseConfig,new_config,nTrodes,spikeThresh,refNTrode,refChan,lfpChan)
% RN_customizeConfig creates a new Trodes config file from an old allowing
% easy editing of settings such as spikeThreshold, reference tetrode,
% reference channel, and lfp channel. For these setting there should be an
% array element for each tetrode in order. Functionality to add tetrodes
% will be coming eventually. If any fields are empty, existing values will
% be used. nTrodes should be a list of tetrode id numbers, if empty or left
% blank, ids will be read from baseConfig
dataFields = {'id','thresh','refNTrode','refChan','lfpChan'};

if nargin<1
    [baseConfig,configDir] = uigetfile('.trodesconf','Select base config file');
    baseConfig = [configDir baseConfig];
end
if nargin<2
    [new_config,configDir2] = uiputfile('.trodesconf','Select output file',[strtok(baseConfig,'.') '_edited']);
    new_config = [configDir2 new_config];
end
if ~exist('nTrodes','var')
    nTrodes = [];
end
if isempty(nTrodes)
    fid = fopen(baseConfig);
    nextline = fgets(fid);
    while nextline~=-1
        id = extractVal(nextline,dataFields{1},'SpikeNTrode');
        if ~isempty(id)
            nTrodes = [nTrodes id];
        end
        nextline = fgets(fid);
    end
    fclose(fid);
end
if nargin<4
    spikeThresh = zeros(numel(nTrodes),1);
    refNTrode = zeros(numel(nTrodes),1);
    refChan = zeros(numel(nTrodes),1);
    lfpChan = zeros(numel(nTrodes),1);
    currTrode = 0;
    fid = fopen(baseConfig);
    nextline = fgets(fid);
    while nextline~=-1
        % Switch Data Fields if using Trodes 1.6 or later
        trodesVersion = extractVal(nextline,'trodesVersion','GlobalConfiguration');
        if ~isempty(trodesVersion) && ~isempty(regexp(trodesVersion,'1.6.*'))
            dataFields = {'id','thresh','refNTrodeID','refChan','LFPChan'};
        end

        id = extractVal(nextline,dataFields{1},'SpikeNTrode');
        thresh = extractVal(nextline,dataFields{2},'SpikeChannel');
        if ~isempty(id)
            currTrode = find(nTrodes==id);
            refNTrode(currTrode) = extractVal(nextline,dataFields{3},'SpikeNTrode');
            refChan(currTrode) = extractVal(nextline,dataFields{4},'SpikeNTrode');
            lfpChan(currTrode) = extractVal(nextline,dataFields{5},'SpikeNTrode');
        elseif ~isempty(thresh)
            spikeThresh(currTrode) = thresh;
        end
        nextline = fgets(fid);
    end
    fclose(fid);
end

TrodePrefs = [];
for i=1:numel(nTrodes),
    TrodePrefs  = [TrodePrefs struct('id',nTrodes(i),'lfpChan',lfpChan(i),...
        'refNTrode',refNTrode(i),'refChan',refChan(i),'thresh',spikeThresh(i))];
end
TrodePrefs2 = RN_extractionTrodesConfGUI(TrodePrefs);
if isempty(TrodePrefs2)
    disp('New Config Cancelled...base config returned.')
    new_config = baseConfig;
    return;
end

fid = fopen(baseConfig);
fid2 = fopen(new_config,'w');
nextline = fgets(fid);
while nextline~=-1
    outLine = nextline;
    % Switch Data Fields if using Trodes 1.6 or later
    trodesVersion = extractVal(nextline,'trodesVersion','GlobalConfiguration');
    if ~isempty(trodesVersion) && ~isempty(regexp(trodesVersion,'1.6.*'))
        dataFields = {'id','thresh','refNTrodeID','refChan','LFPChan'};
    end

    id = extractVal(nextline,dataFields{1},'SpikeNTrode');
    thresh = extractVal(nextline,dataFields{2},'SpikeChannel');
    if ~isempty(id)
        n = find(nTrodes==id);
        outLine = replaceVal(outLine,dataFields{5},'SpikeNTrode',TrodePrefs2(n).lfpChan);
        outLine = replaceVal(outLine,dataFields{4},'SpikeNTrode',TrodePrefs2(n).refChan);
        outLine = replaceVal(outLine,dataFields{3},'SpikeNTrode',TrodePrefs2(n).refNTrode);
    elseif ~isempty(thresh)
        outLine = replaceVal(outLine,dataFields{2},'SpikeChannel',TrodePrefs2(n).thresh);
    end
    if isempty(outLine)
        disp('Unable to correct config file...Fields to replace do not exist');
        outLine = nextline;
    end
    fprintf(fid2,'%s',outLine);

    nextline = fgets(fid);
end
fclose(fid);
fclose(fid2);

function out = extractVal(str,tag,lineStart)
out = [];
a = strfind(str,tag);
b = strfind(str,lineStart);
if isempty(a) || isempty(b)
    return;
end
a = a + numel(tag) + 2;
b = a+find(str(a:end)=='"',1,'first')-2;
str = str(a:b);

out = str2double(str);
if isnan(out)
    out = str;
end

function out = replaceVal(str,tag,lineStart,newVal)
out = [];
a = strfind(str,tag);
b = strfind(str,lineStart);
if isempty(a) || isempty(b)
    return;
end
a = a + numel(tag) + 2;
b = a+find(str(a:end)=='"',1,'first')-2;
out = [str(1:a-1) num2str(newVal) str(b+1:end)];
