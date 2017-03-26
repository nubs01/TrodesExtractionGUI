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

% Last Modified by GUIDE v2.5 15-Mar-2017 21:49:53

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
exKey = load('RN_extractionKey.mat');
handles.extractionKey = exKey.extractionKey;

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


% --- Executes on button press in down_push.
function down_push_Callback(hObject, eventdata, handles)
% hObject    handle to down_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in delete_push.
function delete_push_Callback(hObject, eventdata, handles)
% hObject    handle to delete_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fixFile_push.
function fixFile_push_Callback(hObject, eventdata, handles)
% hObject    handle to fixFile_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in trodesComment_push.
function trodesComment_push_Callback(hObject, eventdata, handles)
% hObject    handle to trodesComment_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exSpike_push.
function exSpike_push_Callback(hObject, eventdata, handles)
% hObject    handle to exSpike_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exLFP_push.
function exLFP_push_Callback(hObject, eventdata, handles)
% hObject    handle to exLFP_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exTime_push.
function exTime_push_Callback(hObject, eventdata, handles)
% hObject    handle to exTime_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exDIO_push.
function exDIO_push_Callback(hObject, eventdata, handles)
% hObject    handle to exDIO_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exMDA_push.
function exMDA_push_Callback(hObject, eventdata, handles)
% hObject    handle to exMDA_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exPhy_push.
function exPhy_push_Callback(hObject, eventdata, handles)
% hObject    handle to exPhy_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --------------------------------------------------------------------
function open_menu_Callback(hObject, eventdata, handles)
% hObject    handle to open_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
