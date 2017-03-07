function varargout = Inter_synchro(varargin)
% INTER_SYNCHRO MATLAB code for Inter_synchro.fig
%      INTER_SYNCHRO, by itself, creates a new INTER_SYNCHRO or raises the existing
%      singleton*.
%
%      H = INTER_SYNCHRO returns the handle to a new INTER_SYNCHRO or the handle to
%      the existing singleton*.
%
%      INTER_SYNCHRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_SYNCHRO.M with the given input arguments.
%
%      INTER_SYNCHRO('Property','Value',...) creates a new INTER_SYNCHRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_synchro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_synchro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_synchro

% Last Modified by GUIDE v2.5 09-Feb-2017 17:02:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_synchro_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_synchro_OutputFcn, ...
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


% --- Executes just before Inter_synchro is made visible.
function Inter_synchro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_synchro (see VARARGIN)

% Choose default command line output for Inter_synchro
handles.output.ttl_folder=varargin{1};
handles.output.acq_freq=varargin{2};
handles.output.act_freq=varargin{3};
handles.output.nb_phases=varargin{4};
handles.cxd=varargin{5};

set(handles.folder_txt,'String',handles.output.ttl_folder);
if isempty(handles.output.ttl_folder)
    set(handles.check_acq,'Value',1)
    set(handles.acq_freq_edt,'Enable','on')
    set(handles.ttl_bttn,'Enable','off')
    set(handles.acq_freq_edt,'String',num2str(handles.output.acq_freq))
else
    
end

set(handles.act_freq_edt,'String',num2str(handles.output.act_freq))
set(handles.nb_phases_edt,'String',num2str(handles.output.nb_phases))


handles.cancel_output=handles.output;



set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_synchro wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inter_synchro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
% Get default command line output from handles structure


varargout{1} = handles.output;
close(hObject);


function act_freq_edt_Callback(hObject, eventdata, handles)
% hObject    handle to act_freq_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.act_freq=str2double(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of act_freq_edt as text
%        str2double(get(hObject,'String')) returns contents of act_freq_edt as a double


% --- Executes during object creation, after setting all properties.
function act_freq_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to act_freq_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nb_phases_edt_Callback(hObject, eventdata, handles)
% hObject    handle to nb_phases_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.nb_phases=str2double(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of nb_phases_edt as text
%        str2double(get(hObject,'String')) returns contents of nb_phases_edt as a double


% --- Executes during object creation, after setting all properties.
function nb_phases_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_phases_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ttl_bttn.
function ttl_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to ttl_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[route]=uigetdir;
handles.output.ttl_folder=route;
set(handles.folder_txt,'String',route);
guidata(hObject,handles);


function acq_freq_edt_Callback(hObject, eventdata, handles)
% hObject    handle to acq_freq_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.acq_freq=str2double(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of acq_freq_edt as text
%        str2double(get(hObject,'String')) returns contents of acq_freq_edt as a double


% --- Executes during object creation, after setting all properties.
function acq_freq_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acq_freq_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_acq.
function check_acq_Callback(hObject, eventdata, handles)
% hObject    handle to check_acq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
check_acq=get(hObject,'Value');
if check_acq
    set(handles.acq_freq_edt,'enable','on','String',num2str(handles.output.acq_freq));
    set(handles.ttl_bttn,'enable','off');
 %   handles.output.ttl_folder=[];
else
    set(handles.acq_freq_edt,'enable','off');
    set(handles.ttl_bttn,'enable','on');
 %   handles.output.acq_freq=[];
    set(handles.folder_txt,'String',handles.output.ttl_folder);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of check_acq


% --- Executes on button press in close_bttn.
function close_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to close_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
check_acq=get(handles.check_acq,'Value');
if check_acq
    handles.output.ttl_folder=[];
else
    handles.output.acq_freq=[];
end
guidata(hObject,handles);

uiresume


% --- Executes on button press in checkit_bttn.
function checkit_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to checkit_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ttl]=Inter_check_my_TTL(handles.cxd,handles.output.ttl_folder);
handles.output.ttl_file=ttl;
guidata(hObject,handles);

