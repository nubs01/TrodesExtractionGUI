function RN_exportBinary(binary,flags)


switch binary
    case 'LFP'
    case 'spikes'
    case 'time'
    case 'dio'
    case 'mda'
    case 'phy'
    otherwise
        h = msgbox('Not a valid binary export type. Please choose: LFP, spikes, time, dio, mda, or phy');
        waitfor(h);
end

%Find the path to the extraction programs
trodesPath = which('trodes_path_placeholder.m');
trodesPath = fileparts(trodesPath);

%Beacuse the path may have spaces in it, we deal with it differently in
%windows vs mac/linux
disp(['"',fullfile(trodesPath,['export' binary]),'"', flags]);
if ispc
    eval(['!"',fullfile(trodesPath,['export' binary]),'"', flags]);
else
    escapeChar = '\ ';
    trodesPath = strrep(trodesPath, ' ', escapeChar);
    eval(['!',fullfile(trodesPath,['export' binary]), flags]);
end