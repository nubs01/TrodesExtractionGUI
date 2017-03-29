function varargout = RN_TrodesExtractionBuilder(varargin)
% RN_TRODESEXTRACTIONBUILDER MATLAB code for RN_TrodesExtractionBuilder.fig
%      RN_TRODESEXTRACTIONBUILDER, by itself, creates a new RN_TRODESEXTRACTIONBUILDER or raises the existing
%      singleton*.
%
%      H = RN_TRODESEXTRACTIONBUILDER returns the handle to a new RN_TRODESEXTRACTIONBUILDER or the handle to
%      the existing singleton*.
%
%      RN_TRODESEXTRACTIONBUILDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RN_TRODESEXTRACTIONBUILDER.M with the given input arguments.
%
%      RN_TRODESEXTRACTIONBUILDER('Property','Value',...) creates a new RN_TRODESEXTRACTIONBUILDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RN_TrodesExtractionBuilder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RN_TrodesExtractionBuilder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RN_TrodesExtractionBuilder

% Last Modified by GUIDE v2.5 29-Mar-2017 00:06:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RN_TrodesExtractionBuilder_OpeningFcn, ...
                   'gui_OutputFcn',  @RN_TrodesExtractionBuilder_OutputFcn, ...
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


% --- Executes just before RN_TrodesExtractionBuilder is made visible.
function RN_TrodesExtractionBuilder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RN_TrodesExtractionBuilder (see VARARGIN)

% Choose default command line output for RN_TrodesExtractionBuilder
handles.output = hObject;
handles.extractionPath = {};
setappdata(handles.output,'saved',1)
setappdata(handles.output,'saveFile','')
handles.saveFile = '';

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes RN_TrodesExtractionBuilder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RN_TrodesExtractionBuilder_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function extraction_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extraction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in up_push.
function up_push_Callback(hObject, eventdata, handles)
% hObject    handle to up_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = handles.extractionPath;
n = get(handles.extraction_list,'Value');
if n==1
    return;
end
tmp = list{n};
list{n} = list{n-1};
list{n-1} = tmp;
handles.extractionPath = list;
set(handles.extraction_list,'String',list,'Value',n-1)
guidata(hObject,handles)


% --- Executes on button press in down_push.
function down_push_Callback(hObject, eventdata, handles)
% hObject    handle to down_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = handles.extractionPath;
disp('derp')
n = get(handles.extraction_list,'Value');
if n<numel(list)
    return;
end
tmp = list{n};
list{n} = list{n+1};
list{n+1} = tmp;
handles.extractionPath = list;
set(handles.extraction_list,'String',list,'Value',n+1)
guidata(hObject,handles)


% --- Executes on button press in delete_push.
function delete_push_Callback(hObject, eventdata, handles)
% hObject    handle to delete_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = handles.extractionPath;
if isempty(list)
    return;
end
n = get(handles.extraction_list,'Value');
if n==numel(list)
    set(handles.extraction_list,'Value',n-1)
end
list(n) = [];
handles.extractionPath = list;
set(handles.extraction_list,'String',list)
guidata(hObject,handles)

% --- Executes on button press of any left side pushbutton.
function add_push_Callback(hObject, eventdata, handles)
% hObject    handle to exTime_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'saved',0)
handles.extractionPath{end+1} = get(hObject,'String');
set(handles.extraction_list,'String',handles.extractionPath)
if numel(handles.extractionPath)<=1
    set(handles.extraction_list,'Value',1)
end
guidata(hObject,handles)

% --- Executes on button press in run_push.
function run_push_Callback(hObject, eventdata, handles)
% hObject    handle to run_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function allHelp_menu_Callback(hObject, eventdata, handles)
% hObject    handle to allHelp_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exHelp_menu_Callback(hObject, eventdata, handles)
% hObject    handle to exHelp_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_menu_Callback(hObject, eventdata, handles)
% hObject    handle to about_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function new_menu_Callback(hObject, eventdata, handles)
% hObject    handle to new_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if getappdata(handles.output,'saved')
    handles.extractionPath = {};
    set(handles.extraction_list,'String',extractionPath)
    setappdata(handles.output,'saved',1)
else
    q = questdlg('Current path is unsaved, if you continue script will be lost. Continue?','Unsaved Changes','Yes','No','No');
    if strcmp(q,'No')
        return;
    else
        handles.extractionPath = {};
        set(handles.extraction_list,'String',extractionPath)
        setappdata(handles.output,'saved',1)
    end
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function open_menu_Callback(hObject, eventdata, handles)
% hObject    handle to open_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if getappdata(handles.output,'saved')
    handles.extractionPath = {};

    [sf,sd] = uigetfile('*.trexpath','Open File');
    if ~sf
        return;
    end
    sf = [sd sf];
    fid = fopen(sf,'r');
    B = {};
    c = fgetl(fid);
    while c~=-1
        B{end+1} = c;
        c = fgetl(fid);
    end
    fclose(fid)
    handles.extractionPath = B';
    setappdata(handles.output,'saveFile',sf)
    set(handles.extraction_list,'String',handles.extractionPath)
    setappdata(handles.output,'saved',1)
else
    q = questdlg('Current path is unsaved, if you continue script will be lost. Continue?','Unsaved Changes','Yes','No','No');
    if strcmp(q,'No')
        return;
    else
        setappdata(handles.output,'saved',1);
        open_menu_Callback(hObject,eventdata,handles);
    end
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sf = getappdata(handles.output,'saveFile');
if isempty(sf)
    [sf,sd] = uiputfile('*.trexpath','Save File');
    if ~sf
        return;
    end
    sf = [sd sf];
end
fid = fopen(sf,'w');
expath = handles.extractionPath;
for i=1:numel(expath),
    fprintf(fid,'%s\n',expath{i});
end
fclose(fid);
setappdata(handles.output,'saveFile',sf)
setappdata(handles.output,'saved',1)


% --------------------------------------------------------------------
function script_export_menu_Callback(hObject, eventdata, handles)
% hObject    handle to script_export_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveas_menu_Callback(hObject, eventdata, handles)
% hObject    handle to saveas_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'saveFile','')
save_menu_Callback(hObject,eventdata,handles)


% --------------------------------------------------------------------
function newconfig_menu_Callback(hObject, eventdata, handles)
% hObject    handle to newconfig_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
