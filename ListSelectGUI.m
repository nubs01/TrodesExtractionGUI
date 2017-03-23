function varargout = ListSelectGUI(varargin)
% LISTSELECTGUI MATLAB code for ListSelectGUI.fig
%      A = ListSelectGUI(List,Title,MultiSelect) creates a gui that
%      displays a list (cell array) and lets the user select an item (or
%      items is MultiSelect is set to 1, default 0). Title and MultiSelect
%      are not required fields. User cancel operation returns empty array
%      and selection return indices of selected items.
%
%      LISTSELECTGUI, by itself, creates a new LISTSELECTGUI or raises the existing
%      singleton*.
%
%      H = LISTSELECTGUI returns the handle to a new LISTSELECTGUI or the handle to
%      the existing singleton*.
%
%      LISTSELECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISTSELECTGUI.M with the given input arguments.
%
%      LISTSELECTGUI('Property','Value',...) creates a new LISTSELECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ListSelectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ListSelectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ListSelectGUI

% Last Modified by GUIDE v2.5 22-Mar-2017 22:26:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ListSelectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ListSelectGUI_OutputFcn, ...
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


% --- Executes just before ListSelectGUI is made visible.
function ListSelectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ListSelectGUI (see VARARGIN)

% Choose default command line output for ListSelectGUI
handles.output = [];
Nin = numel(varargin);
handles.list = varargin{1};
set(handles.list_box,'String',handles.list,'Value',1)
if Nin > 1
    set(handles.title_text,'String',varargin{2});
end
if Nin > 2
    if varargin{3}
        set(handles.list_box,'max',10,'min',1)
    end
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ListSelectGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ListSelectGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);


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


% --- Executes on button press in cancel_push.
function cancel_push_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = [];
guidata(hObject,handles)
close(handles.figure1)


% --- Executes on button press in done_push.
function done_push_Callback(hObject, eventdata, handles)
% hObject    handle to done_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = get(handles.list_box,'Value');
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