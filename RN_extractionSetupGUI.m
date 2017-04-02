function varargout = RN_extractionSetupGUI(varargin)
% RN_EXTRACTIONSETUPGUI MATLAB code for RN_extractionSetupGUI.fig
%      RN_EXTRACTIONSETUPGUI, by itself, creates a new RN_EXTRACTIONSETUPGUI or raises the existing
%      singleton*.
%
%      H = RN_EXTRACTIONSETUPGUI returns the handle to a new RN_EXTRACTIONSETUPGUI or the handle to
%      the existing singleton*.
%
%      RN_EXTRACTIONSETUPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RN_EXTRACTIONSETUPGUI.M with the given input arguments.
%
%      RN_EXTRACTIONSETUPGUI('Property','Value',...) creates a new RN_EXTRACTIONSETUPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RN_extractionSetupGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RN_extractionSetupGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RN_extractionSetupGUI

% Last Modified by GUIDE v2.5 02-Apr-2017 01:31:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RN_extractionSetupGUI_OpeningFcn, ...
    'gui_OutputFcn',  @RN_extractionSetupGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RN_extractionSetupGUI is made visible.
function RN_extractionSetupGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RN_extractionSetupGUI (see VARARGIN)

% Choose default command line output for RN_extractionSetupGUI
handles.output = hObject;
setappdata(handles.output,'ExPath',varargin{1})
exDat = varargin{2};
dayNames = {exDat.day_name};
animalNames = {exDat.animal_name};
[~,idx] = sort(animalNames);
animalNames = animalNames(idx);
dayNames = dayNames(idx);
exDat = exDat(idx);
dayList = {};
dayIdx = zeros(numel(dayNames),1);
prevAnim = '';
for i=1:numel(dayNames),
    a = animalNames{i};
    if ~strcmp(a,prevAnim)
        prevAnim = a;
        dayList = [dayList;a];
    end
    dayList = [dayList;['--' dayNames{i}]];
    dayIdx(i) = numel(dayList);
end
setappdata(handles.output,'dayIdx',dayIdx)
setappdata(handles.output,'ExDat',exDat)
set(handles.dir_list,'String',dayList,'Value',2)
allExTypes = {'Spikes','LFP','Time','DIO','MDA','Phy'};
setappdata(handles.output,'allExportTypes',allExTypes)
setappdata(handles.output,'origDat',exDat)
handles.i = 1;
handles.submit = 0;
updateGUI(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RN_extractionSetupGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RN_extractionSetupGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.submit
    out = getappdata(handles.output,'ExDat');
    out2 = str2double(get(handles.parallel_edit,'String'));
else
    out = [];
    out2 = [];
end
varargout{1} = out;
varargout{2} = out2;
delete(handles.figure1)

% --- Updates GUI to reflect the base data structures ExPath and ExDat
function updateGUI(handles)
%
i = handles.i;
h = handles.output;
dayIdx = getappdata(h,'dayIdx');
ExDat = getappdata(h,'ExDat');
ExPath = getappdata(h,'ExPath');
ed = ExDat(i);
set(handles.info_text,'String',sprintf(...
    'Animal: %s\nDay Dir: %s',ed.animal_name,ed.day_name))
set(handles.export_text,'String','')
exText = {};
exportTypes = getappdata(handles.output,'allExportTypes');

for j=1:numel(ExPath),
    exItem = ExPath{j};
    switch exItem
        case 'Fix Filenames'
            set(handles.prefix_text,'String',['Prefix: ' ed.prefix])
            set(handles.prefix_panel,'Visible','On')
        case 'Create Trodes Comments'
            set(handles.rec_list,'String',ed.rec_order)
            set(handles.rec_panel,'Visible','On')
        case 'Generate Matclusts'
            set(handles.parallel_panel,'Visible','On')
            set(handles.prefix_panel,'Visible','On')
        otherwise
            [a,b] = strtok(exItem);
            % Display export flags
            if strcmp(a,'Export')
                set(handles.config_panel,'Visible','On')
                if ~isempty(ed.config)
                    set(handles.config_text,'String',['Config: ' ed.config])
                else
                    set(handles.config_text,'String','Config: Default')
                end
                set(handles.export_panel,'Visible','On')
                set(handles.prefix_panel,'Visible','On')
                set(handles.prefix_text,'String',['Prefix: ' ed.prefix])
                b = strtrim(b);
                exIdx = find(strcmpi(exportTypes,b));
                k = ed.export_flags{exIdx};
                b = [b ':'];
                if isempty(k)
                    exText = [exText b];
                else
                    exText = [exText b k];
                end
                exText{end+1} = '';
            end
    end
end
if ~any(strcmp(ExPath,'Fix Filenames'))
    set(handles.prefix_text,'String',['Prefix: ' ed.prefix])
    set(handles.change_pre_push,'Visible','off')
end
set(handles.export_text,'String',char(exText));


% --- Executes on selection change in dir_list.
function dir_list_Callback(hObject, eventdata, handles)
% hObject    handle to dir_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dayIdx = getappdata(handles.output,'dayIdx');
i = get(hObject,'Value');
if ~any(dayIdx==i)
    i = find(dayIdx>i,1,'first');
    set(hObject,'Value',dayIdx(i))
else
    i = find(dayIdx==i);
end
handles.i = i;
updateGUI(handles);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dir_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancel_push.
function cancel_push_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)


% --- Executes on button press in submit_push.
function submit_push_Callback(hObject, eventdata, handles)
% hObject    handle to submit_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.submit = 1;
guidata(hObject,handles)
close(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end


% --- Executes on button press in change_pre_push.
function change_pre_push_Callback(hObject, eventdata, handles)
% hObject    handle to change_pre_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = handles.i;
exDat = getappdata(handles.output,'ExDat');
prefix = inputdlg('Set new file prefix:','Change Prefix',1,{exDat(i).prefix});
if isempty(prefix)
    return;
else
    exDat(i).prefix = prefix;
    setappdata(handles.output,'ExDat',exDat)
    updateGUI(handles)
    guidata(hObject,handles)
end


% --- Executes on button press in change_rec_push.
function change_rec_push_Callback(hObject, eventdata, handles)
% hObject    handle to change_rec_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = handles.i;
exDat = getappdata(handles.output,'ExDat');
RO = exDat(i).rec_order;
RO2 = ListGUI(RO,'Order Rec Files:');
if isempty(RO2)
    return;
else
    exDat(i).rec_order = RO;
end

setappdata(handles.output,'ExDat',exDat)
updateGUI(handles)
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function rec_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rec_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in change_conf_push.
function change_conf_push_Callback(hObject, eventdata, handles)
% hObject    handle to change_conf_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = handles.i;
exDat = getappdata(handles.output,'ExDat');
q1 = questdlg('Create new config or choose existing?','Change Config File','New','Existing','Cancel','Cancel');
switch q1
    case 'New'
        cf = RN_customizeTrodesConfig();
    case 'Existing'
        [a,b] = uigetfile('*.trodesconf','Choose Config File');
        cf = [b,a];
    case 'Cancel'
        cf = exDat(i).config;
end
exDat(i).config = cf;
setappdata(handles.output,'ExDat',exDat)
updateGUI(handles)
guidata(hObject,handles)



function parallel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to parallel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parallel_edit as text
%        str2double(get(hObject,'String')) returns contents of parallel_edit as a double
if isempty(str2double(get(handles.parallel_edit,'String')))
    h = msgbox('Choose a valid number.','Invalid Input');
    waitfor(h);
    set(hObject,'String','8')
end
updateGUI(handles);


% --- Executes during object creation, after setting all properties.
function parallel_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parallel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in change_export_push.
function change_export_push_Callback(hObject, eventdata, handles)
% hObject    handle to change_export_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = handles.i;
allExTypes = getappdata(handles.output,'allExportTypes');
exPath = getappdata(handles.output,'ExPath');
exDat = getappdata(handles.output,'ExDat');
[a,b] = strtok(exPath,' ');
exIdx = strcmpi(a,'Export');
exTs = strtrim(b(exIdx));
allExIdx = zeros(1,numel(exTs));
for j=1:numel(exTs),
    k = find(strcmpi(allExTypes,exTs{j}));
    allExIdx(j) = k;
end


Qs = cellfun(@(x) ['Extra Export ' x ' Flags:'],exTs,'UniformOutput',0);
exFlags = exDat(i).export_flags;
As = inputdlg(Qs,'Custom Export Flags',1,exFlags(allExIdx));
if isempty(As)
    return;
end
exFlags(allExIdx) = As;
exDat(i).export_flags = exFlags;
setappdata(handles.output,'ExDat',exDat)
guidata(hObject,handles)
updateGUI(handles)




% --- Executes on button press in reset_config_push.
function reset_config_push_Callback(hObject, eventdata, handles)
% hObject    handle to reset_config_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = handles.i;
exDat = getappdata(handles.output,'ExDat');
exDat(i).config = '';

setappdata(handles.output,'ExDat',exDat)
updateGUI(handles)
guidata(hObject,handles)
