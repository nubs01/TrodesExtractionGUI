function varargout = OrderListGUI(varargin)
% ORDERLISTGUI MATLAB code for OrderListGUI.fig
%      SortedList = OrderListGUI(unsortedList) brings up a gui that allows
%      the user to sort a list
%
%      ORDERLISTGUI, by itself, creates a new ORDERLISTGUI or raises the existing
%      singleton*.
%
%      H = ORDERLISTGUI returns the handle to a new ORDERLISTGUI or the handle to
%      the existing singleton*.
%
%      ORDERLISTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORDERLISTGUI.M with the given input arguments.
%
%      ORDERLISTGUI('Property','Value',...) creates a new ORDERLISTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OrderListGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OrderListGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OrderListGUI

% Last Modified by GUIDE v2.5 08-Mar-2017 21:39:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OrderListGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OrderListGUI_OutputFcn, ...
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


% --- Executes just before OrderListGUI is made visible.
function OrderListGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OrderListGUI (see VARARGIN)

% Choose default command line output for OrderListGUI
handles.figHandle = hObject;
handles.output = varargin{1};
handles.origList = varargin{1};
updateList(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OrderListGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

%Re-displays the list in its current order
function updateList(handles)
set(handles.list_box,'String',char(handles.output))

% --- Outputs from this function are returned to the command line.
function varargout = OrderListGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figHandle);


% --- Executes on selection change in list_box.
function list_box_Callback(hObject, eventdata, handles)
% hObject    handle to list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_box


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
    guidata(hObject,handles)
end


% --- Executes on button press in cancel_push.
function cancel_push_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = handles.origList;
guidata(hObject,handles);
close(handles.figure1);


% --- Executes on button press in confirm_push.
function confirm_push_Callback(hObject, eventdata, handles)
% hObject    handle to confirm_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
