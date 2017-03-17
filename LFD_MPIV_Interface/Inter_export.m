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

% Last Modified by GUIDE v2.5 14-Mar-2017 17:31:38

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

handles.output.export_folder=varargin{1};
handles.output.export_vectors=varargin{2};
handles.case_name=varargin{3};

set_selections(handles);
set(handles.folder_txt,'String',handles.output.export_folder);
set(handles.case_name_edt,'Enable','off','String',handles.output.export_vectors);








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
varargout{1} = handles.output;
close(hObject);

function set_selections(handles)
    idx_ext=get(handles.pop_exten,'Value');
    switch idx_ext
        case 1
            extension='.mat';
        case 2
            extension='.csv';
        case 3
            extension='.dat';
    end
            
    selection{1}=sprintf('%s%s',handles.case_name,extension);
    selection{2}=sprintf('%s%s','data',extension);
    selection{3}='custom';
    set(handles.pop_vec,'String',selection);


% --- Executes on button press in folder_bttn.
function folder_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to folder_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
route=uigetdir;
handles.output.export_folder=route;
set(handles.folder_txt,'String',route);
guidata(hObject,handles);


% --- Executes on selection change in pop_exten.
function pop_exten_Callback(hObject, eventdata, handles)
% hObject    handle to pop_exten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_exten contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_exten


% --- Executes during object creation, after setting all properties.
function pop_exten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_exten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_vec.
function pop_vec_Callback(hObject, eventdata, handles)
% hObject    handle to pop_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(hObject,'Value');
if idx==3
    set(handles.case_name_edt,'enable','on');
    custom=get(handles.case_name_edt,'String');
    [~,custom,~] = fileparts(custom);
    set(handles.case_name_edt,'String',custom);
    idx_ext=get(handles.pop_exten,'Value');
    switch idx_ext
        case 1
            extension='.mat';
        case 2
            extension='.csv';
        case 3
            extension='.dat';
    end

    handles.output.export_vectors=sprintf('%s%s',custom,extension);
else
    set(handles.case_name_edt,'enable','off');
    contents=cellstr(get(hObject,'String'));
    set(handles.case_name_edt,'String',contents{idx});
    handles.output.export_vectors=contents{idx};
end
guidata(hObject,handles);


% Hints: contents = cellstr(get(hObject,'String')) returns pop_vec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_vec


% --- Executes during object creation, after setting all properties.
function pop_vec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function case_name_edt_Callback(hObject, eventdata, handles)
% hObject    handle to case_name_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in check_date.
function check_date_Callback(hObject, eventdata, handles)
% hObject    handle to check_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_date



function edt_date_Callback(hObject, eventdata, handles)
% hObject    handle to edt_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_date as text
%        str2double(get(hObject,'String')) returns contents of edt_date as a double


% --- Executes during object creation, after setting all properties.
function edt_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function the_date_edt_Callback(hObject, eventdata, handles)
% hObject    handle to the_date_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on selection change in popup_date.
function popup_date_Callback(hObject, eventdata, handles)
% hObject    handle to popup_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_date contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_date


% --- Executes during object creation, after setting all properties.
function popup_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
