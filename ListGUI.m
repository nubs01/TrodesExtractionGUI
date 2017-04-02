function varargout = ListGUI(varargin)
% ListGUI MATLAB code for ListGUI.fig
%      SortedList = ListGUI(unsortedList) brings up a gui that allows
%      the user to sort a list
%
%      SortedList = ListGUI(unsortedList,title,addType) sets the title of
%      the GUI and specifying an addType ('file' or 'string') allows
%      addition and removal of items from the list
%
%      ListGUI, by itself, creates a new ListGUI or raises the existing
%      singleton*.
%
%      H = ListGUI returns the handle to a new ListGUI or the handle to
%      the existing singleton*.
%
%      ListGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ListGUI.M with the given input arguments.
%
%      ListGUI('Property','Value',...) creates a new ListGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ListGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ListGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ListGUI

% Last Modified by GUIDE v2.5 26-Mar-2017 11:51:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ListGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ListGUI_OutputFcn, ...
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


% --- Executes just before ListGUI is made visible.
function ListGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ListGUI (see VARARGIN)

% Choose default command line output for ListGUI
handles.figHandle = hObject;
handles.output = varargin{1};
handles.origList = varargin{1};
updateList(handles);

if numel(varargin)>1
    tstr = varargin{2};
    set(handles.title_text,'String',tstr)
end
if numel(varargin)>2
    add_type = lower(varargin{3});
    switch add_type
        case 'file'
        case 'string'
        case 'dir'
        otherwise
            error('add_type must be either ''dir'', ''file'' or ''string''');
    end
    set(handles.add_push,'Visible','On','Enable','On')
    set(handles.remove_push,'Visible','On','Enable','On')
    handles.add_type = add_type;
end
handles.confirm = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ListGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

% Re-displays the list in its current order
function updateList(handles)
loc = get(handles.list_box,'Value');
list = handles.output;
if isempty(list)
    set(handles.list_box,'String','','Value',1)
    return;
end
set(handles.list_box,'Units','char')
len = get(handles.list_box,'Position');
len = len(3)-1;
sizes = cellfun(@(x) numel(x),list);
if any(sizes>=len)
    for i=find(sizes>=len),
        a = list{i};
        if strcmp(handles.add_type,'file') || strcmp(handles.add_type,'dir')
            b = shortenPath(a,len);
        else
            b = shortenStr(a,len);
        end
        list{i} = b;
    end
end
set(handles.list_box,'String',list)
if loc>numel(handles.output)
    set(handles.list_box,'Value',numel(handles.output))
end

function out = shortenStr(str,N)
% N must be greater than or equal to 3
if numel(str)<N
    out = str;
    return;
end
d = numel(str)-N + 3;
i1 = fix(numel(str)/2)-ceil(d/2)+2;
out = strrep(str,str(i1:i1+d-1),'...');

function out = shortenPath(str,N)
if strcmp(str(end),filesep)
    str = str(1:end-1);
end
M = numel(str);
[b,a,c] = fileparts(str);
a = [a c];
L1 = numel(a)+1;
L2 = numel(a)+5;
L3 = 5;
if numel(a)+5<=N
    out = [shortenPath(b,N-1-(numel(a))) filesep a];
else
    out = [filesep '...'];
end


% --- Outputs from this function are returned to the command line.
function varargout = ListGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.confirm
    varargout{1} = handles.output;
else
    varargout{1} = [];
end
delete(handles.figHandle);


% --- Executes during object creation, after setting all properties.
function list_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_box (see GCBO)
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
list = handles.output;
n = get(handles.list_box,'Value');
if n>1
    tmp = list{n};
    list{n} = list{n-1};
    list{n-1} = tmp;
    handles.output = list;
    updateList(handles)
    set(handles.list_box,'Value',n-1);
    guidata(hObject,handles)
end


% --- Executes on button press in down_push.
function down_push_Callback(hObject, eventdata, handles)
% hObject    handle to down_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = handles.output;
n = get(handles.list_box,'Value');
if n<numel(list)
    tmp = list{n};
    list{n} = list{n+1};
    list{n+1} = tmp;
    handles.output = list;
    updateList(handles)
    set(handles.list_box,'Value',n+1)
    guidata(hObject,handles)
end


% --- Executes on button press in cancel_push.
function cancel_push_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes on button press in confirm_push.
function confirm_push_Callback(hObject, eventdata, handles)
% hObject    handle to confirm_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.confirm = 1;
guidata(hObject,handles)
close(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end


% --- Executes on button press in remove_push.
function remove_push_Callback(hObject, eventdata, handles)
% hObject    handle to remove_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = handles.output;
if isempty(list)
    return;
end
n = get(handles.list_box,'Value');
list(n) = [];
handles.output = list;
updateList(handles);
guidata(hObject,handles);


% --- Executes on button press in add_push.
function add_push_Callback(hObject, eventdata, handles)
% hObject    handle to add_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
txt = '';
switch handles.add_type
    case 'file'
        [fn,direc] = uigetfile([pwd filesep '.*']);
        disp(fn)
        if ischar(fn)
            txt = [direc fn];
        end
    case 'string'
        txt = inputdlg('New List Item:','Add Item');
        if ~isempty(txt)
            txt = txt{1};
        else
            txt = '';
        end
    case 'dir'
        direc = uigetdir(pwd,'Select Directory');
        if direc
            txt = direc;
        else
            txt = '';
        end
end
if ~isempty(txt)
    handles.output{end+1} = txt;
end
updateList(handles)
guidata(hObject,handles)
