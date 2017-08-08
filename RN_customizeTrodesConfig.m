function new_config = RN_customizeTrodesConfig(baseConfig,new_config,nTrodes,spikeThresh,refNTrode,refChan,lfpChan)
% RN_customizeConfig creates a new Trodes config file from an old allowing
% easy editing of settings such as spikeThreshold, reference tetrode,
% reference channel, and lfp channel. For these setting there should be an
% array element for each tetrode in order. Functionality to add tetrodes
% will be coming eventually. If any fields are empty, existing values will
% be used. nTrodes should be a list of tetrode id numbers, if empty or left
% blank, ids will be read from baseConfig

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
        id = extractVal(nextline,'id','SpikeNTrode');
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
        id = extractVal(nextline,'id','SpikeNTrode');
        thresh = extractVal(nextline,'thresh','SpikeChannel');
        if ~isempty(id)
            currTrode = find(nTrodes==id);
            refNTrode(currTrode) = extractVal(nextline,'refNTrodeID','SpikeNTrode');
            refChan(currTrode) = extractVal(nextline,'refChan','SpikeNTrode');
            lfpChan(currTrode) = extractVal(nextline,'LFPChan','SpikeNTrode');
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
    id = extractVal(nextline,'id','SpikeNTrode');
    thresh = extractVal(nextline,'thresh','SpikeChannel');
    if ~isempty(id)
        n = find(nTrodes==id);
        outLine = replaceVal(outLine,'LFPChan','SpikeNTrode',TrodePrefs2(n).lfpChan);
        outLine = replaceVal(outLine,'refChan','SpikeNTrode',TrodePrefs2(n).refChan);
        outLine = replaceVal(outLine,'refNTrodeID','SpikeNTrode',TrodePrefs2(n).refNTrode);
    elseif ~isempty(thresh)
        outLine = replaceVal(outLine,'thresh','SpikeChannel',TrodePrefs2(n).thresh);
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
out = str2double(str(a:b));

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