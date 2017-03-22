function varargout = RN_extractionTrodesConfGUI(varargin)
% RN_EXTRACTIONTRODESCONFGUI MATLAB code for RN_extractionTrodesConfGUI.fig
%      RN_EXTRACTIONTRODESCONFGUI, by itself, creates a new RN_EXTRACTIONTRODESCONFGUI or raises the existing
%      singleton*.
%
%      H = RN_EXTRACTIONTRODESCONFGUI returns the handle to a new RN_EXTRACTIONTRODESCONFGUI or the handle to
%      the existing singleton*.
%
%      RN_EXTRACTIONTRODESCONFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RN_EXTRACTIONTRODESCONFGUI.M with the given input arguments.
%
%      RN_EXTRACTIONTRODESCONFGUI('Property','Value',...) creates a new RN_EXTRACTIONTRODESCONFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RN_extractionTrodesConfGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RN_extractionTrodesConfGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RN_extractionTrodesConfGUI

% Last Modified by GUIDE v2.5 09-Mar-2017 11:26:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RN_extractionTrodesConfGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RN_extractionTrodesConfGUI_OutputFcn, ...
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


% --- Executes just before RN_extractionTrodesConfGUI is made visible.
function RN_extractionTrodesConfGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RN_extractionTrodesConfGUI (see VARARGIN)

% Choose default command line output for RN_extractionTrodesConfGUI
prefs = varargin{1};
handles.output = prefs;
handles.fighandle = hObject;
handles.origPrefs = prefs;
handles.tets = {prefs.id}';
set(handles.tet_pop,'String',handles.tets)
set(handles.lfp_pop,'String',{1,2,3,4})
set(handles.refTet_pop,'String',handles.tets)
set(handles.refChan_pop,'String',{1,2,3,4})
updateFields(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RN_extractionTrodesConfGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

function updateFields(handles)
tet = get(handles.tet_pop,'Value');
pref = handles.output(tet);
set(handles.lfp_pop,'Value',pref.lfpChan);
set(handles.refChan_pop,'Value',pref.refChan);
set(handles.refTet_pop,'Value',pref.refNTrode);
set(handles.thresh_edit,'String',num2str(pref.thresh));

% --- Outputs from this function are returned to the command line.
function varargout = RN_extractionTrodesConfGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.fighandle);


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

% --- Executes on selection change in tet_pop.
function tet_pop_Callback(hObject, eventdata, handles)
% hObject    handle to tet_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tet_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tet_pop
updateFields(handles);


% --- Executes during object creation, after setting all properties.
function tet_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tet_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function lfp_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lfp_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function refTet_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refTet_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function refChan_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refChan_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in copy_push.
function copy_push_Callback(hObject, eventdata, handles)
% hObject    handle to copy_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pref = handles.output(get(handles.tet_pop,'Value'));

% copyto = inputdlg('Copy to which tetrodes?','Copy To',1,{'All'});
% if isempty(copyto) || strcmp(lower(copyto),'all')
%     cpt = 1:numel(handles.output);
% elsei
    


for i=1:numel(handles.output),
    id = handles.output(i).id;
    handles.output(i) = pref;
    handles.output(i).id = id;
end
updateFields(handles);
guidata(hObject,handles);


% --- Executes on button press in reset_push.
function reset_push_Callback(hObject, eventdata, handles)
% hObject    handle to reset_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = handles.origPrefs;
updateFields(handles);
guidata(hObject,handles);


% --- Executes on button press in cancel_push.
function cancel_push_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = [];
guidata(hObject,handles);
close(handles.figure1);


% --- Executes on button press in done_push.
function done_push_Callback(hObject, eventdata, handles)
% hObject    handle to done_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes on selection change in lfp_pop.
function lfp_pop_Callback(hObject, eventdata, handles)
% hObject    handle to lfp_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lfp_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lfp_pop
tet = get(handles.tet_pop,'Value');
pref = handles.output(tet);
pref.lfpChan = get(handles.lfp_pop,'Value');
handles.output(tet) = pref;
updateFields(handles);
guidata(hObject,handles);

% --- Executes on selection change in refTet_pop.
function refTet_pop_Callback(hObject, eventdata, handles)
% hObject    handle to refTet_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns refTet_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from refTet_pop
tet = get(handles.tet_pop,'Value');
pref = handles.output(tet);
pref.refNTrode = get(handles.refTet_pop,'Value');
handles.output(tet) = pref;
updateFields(handles);
guidata(hObject,handles);

% --- Executes on selection change in refChan_pop.
function refChan_pop_Callback(hObject, eventdata, handles)
% hObject    handle to refChan_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns refChan_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from refChan_pop
tet = get(handles.tet_pop,'Value');
pref = handles.output(tet);
pref.refChan = get(handles.refChan_pop,'Value');
handles.output(tet) = pref;
updateFields(handles);
guidata(hObject,handles);


function thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of thresh_edit as a double
tet = get(handles.tet_pop,'Value');
pref = handles.output(tet);
val = str2num(get(handles.thresh_edit,'String'));
if isempty(val)
    h = msgbox('Spike Threshold must be a number.');
    waitfor(h);
    return;
end
pref.thresh = val;
handles.output(tet) = pref;
updateFields(handles);
guidata(hObject,handles);
