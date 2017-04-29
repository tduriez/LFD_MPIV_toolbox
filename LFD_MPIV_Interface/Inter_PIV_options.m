function varargout = Inter_PIV_options(varargin)
% INTER_PIV_OPTIONS MATLAB code for Inter_PIV_options.fig
%      INTER_PIV_OPTIONS, by itself, creates a new INTER_PIV_OPTIONS or raises the existing
%      singleton*.
%
%      H = INTER_PIV_OPTIONS returns the handle to a new INTER_PIV_OPTIONS or the handle to
%      the existing singleton*.
%
%      INTER_PIV_OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_PIV_OPTIONS.M with the given input arguments.
%
%      INTER_PIV_OPTIONS('Property','Value',...) creates a new INTER_PIV_OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_PIV_options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_PIV_options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%   Copyright (c) 2017, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017, Thomas Duriez
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

% Edit the above text to modify the response to help Inter_PIV_options

% Last Modified by GUIDE v2.5 28-Apr-2017 22:22:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_PIV_options_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_PIV_options_OutputFcn, ...
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


% --- Executes just before Inter_PIV_options is made visible.
function Inter_PIV_options_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_PIV_options (see VARARGIN)

% Choose default command line output for Inter_PIV_options
handles.parameters=varargin{1};
  set(handles.verbose_selec,'Value',handles.parameters.Verbose+1);
  populate_list(handles);
  set(handles.scale_edt,'String',handles.parameters.scale);
    set(handles.delta_edt,'String',handles.parameters.deltat);
set(handles.cumulcross,'Value',handles.parameters.cumulcross);
switch handles.parameters.ImDeform
    case 'linear'
        set(handles.deform_pop,'Value',1)
    case 'spline'
        set(handles.deform_pop,'Value',3)
    case 'cubic'
        set(handles.deform_pop,'Value',2)
end



% UIWAIT makes Inter_PIV_options wait for user response (see UIRESUME)
set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);

 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inter_PIV_options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%keyboard
set(hObject,'closeRequestFcn','closereq');
varargout{1} = handles.parameters;
close(hObject);





function IntWin_edt_Callback(hObject, eventdata, handles)
% hObject    handle to IntWin_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntWin_edt as text
%        str2double(get(hObject,'String')) returns contents of IntWin_edt as a double


% --- Executes during object creation, after setting all properties.
function IntWin_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntWin_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function overlap_edt_Callback(hObject, eventdata, handles)
% hObject    handle to overlap_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlap_edt as text
%        str2double(get(hObject,'String')) returns contents of overlap_edt as a double


% --- Executes during object creation, after setting all properties.
function overlap_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlap_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function populate_list(handles)
    IntWin=handles.parameters.IntWin;
    overlap=handles.parameters.overlap;
    text_list=cell(1,numel(IntWin));
    for i=1:numel(IntWin)
        text_list{i}=sprintf('   %d           %d%',IntWin(i),overlap(i));
    end
    
    idx=get(handles.listbox1,'Value');
    idx(idx>numel(IntWin))=numel(IntWin);
    if numel(IntWin)>0
        idx(idx==0)=1;
    end
    idx=unique(idx);
    
    set(handles.listbox1,'Value',idx,'String',text_list,'Max',length(text_list));

        


% --- Executes on button press in cumulcross.
function cumulcross_Callback(hObject, eventdata, handles)
% hObject    handle to cumulcross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.cumulcross=get(hObject,'Value')
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of cumulcross


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.parameters.IntWin=sort([handles.parameters.IntWin, str2double(get(handles.IntWin_edt,'String'))],'descend');
handles.parameters.overlap=repmat(str2double(get(handles.overlap_edt,'String')),[1 numel(handles.parameters.IntWin)]);
populate_list(handles);
guidata(hObject,handles);




% --- Executes on button press in remove_buttn.
function remove_buttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_buttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.listbox1,'Value');
handles.parameters.IntWin(idx)=0;
handles.parameters.overlap(idx)=0;
handles.parameters.IntWin=handles.parameters.IntWin(handles.parameters.IntWin~=0);
handles.parameters.overlap=handles.parameters.overlap(handles.parameters.overlap~=0);
populate_list(handles)
guidata(hObject,handles);



% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;



function scale_edt_Callback(hObject, eventdata, handles)
% hObject    handle to scale_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.scale=str2double(get(hObject,'String'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of scale_edt as text
%        str2double(get(hObject,'String')) returns contents of scale_edt as a double


% --- Executes during object creation, after setting all properties.
function scale_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_edt_Callback(hObject, eventdata, handles)
% hObject    handle to delta_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_edt as text
%        str2double(get(hObject,'String')) returns contents of delta_edt as a double
handles.parameters.deltat=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function delta_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in deform_pop.
function deform_pop_Callback(hObject, eventdata, handles)
% hObject    handle to deform_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String')) ;
handles.parameters.ImDeform=contents{get(hObject,'Value')};
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns deform_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from deform_pop


% --- Executes during object creation, after setting all properties.
function deform_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deform_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in verbose_selec.
function verbose_selec_Callback(hObject, eventdata, handles)
% hObject    handle to verbose_selec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.parameters.Verbose=get(hObject,'Value')-1;
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns verbose_selec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from verbose_selec


% --- Executes during object creation, after setting all properties.
function verbose_selec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to verbose_selec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
