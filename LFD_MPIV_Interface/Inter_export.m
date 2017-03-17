function varargout = Inter_export(varargin)
% INTER_EXPORT MATLAB code for Inter_export.fig
%      INTER_EXPORT, by itself, creates a new INTER_EXPORT or raises the existing
%      singleton*.
%
%      H = INTER_EXPORT returns the handle to a new INTER_EXPORT or the handle to
%      the existing singleton*.
%
%      INTER_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_EXPORT.M with the given input arguments.
%
%      INTER_EXPORT('Property','Value',...) creates a new INTER_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_export_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_export

% Last Modified by GUIDE v2.5 17-Mar-2017 16:23:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_export_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_export_OutputFcn, ...
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


% --- Executes just before Inter_export is made visible.
function Inter_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_export (see VARARGIN)
handles.parameters=varargin{1};
show_export(handles);

set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_field_height wait for user response (see UIRESUME)
uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = Inter_export_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
% Get default command line output from handles structure
varargout{1} = handles.parameters;
close(hObject);

function show_export(handles)
    set(handles.export_txt,'String',fullfile(handles.parameters.export_folder,handles.parameters.export_filename));
    set(handles.case_name_edt,'String',handles.parameters.case_name);
    set(handles.the_date_edt,'String',handles.parameters.the_date);


% --- Executes on button press in folder_bttn.
function folder_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to folder_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
route=uigetdir;
handles.parameters.export_folder=route;
show_export(handles)
guidata(hObject,handles);

function case_name_edt_Callback(hObject, eventdata, handles)
% hObject    handle to case_name_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.case_name=get(hObject,'String');
show_export(handles)
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of case_name_edt as text
%        str2double(get(hObject,'String')) returns contents of case_name_edt as a double


% --- Executes during object creation, after setting all properties.
function case_name_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to case_name_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in close_bttn.
function close_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to close_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;






function the_date_edt_Callback(hObject, eventdata, handles)
% hObject    handle to the_date_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.the_date=get(hObject,'String');
show_export(handles)
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of the_date_edt as text
%        str2double(get(hObject,'String')) returns contents of the_date_edt as a double


% --- Executes during object creation, after setting all properties.
function the_date_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to the_date_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in set_now.
function set_now_Callback(hObject, eventdata, handles)
% hObject    handle to set_now (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.the_date=datestr(now,'yyyymmdd-HHMMSS');
show_export(handles)
guidata(hObject,handles);


% --- Executes on button press in today_bttn.
function today_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to today_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.the_date=datestr(now,'yyyymmdd');
show_export(handles)
guidata(hObject,handles);
