function varargout = Inter_import(varargin)
% INTER_IMPORT MATLAB code for Inter_import.fig
%      INTER_IMPORT, by itself, creates a new INTER_IMPORT or raises the existing
%      singleton*.
%
%      H = INTER_IMPORT returns the handle to a new INTER_IMPORT or the handle to
%      the existing singleton*.
%
%      INTER_IMPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_IMPORT.M with the given input arguments.
%
%      INTER_IMPORT('Property','Value',...) creates a new INTER_IMPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_import_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_import_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_import

% Last Modified by GUIDE v2.5 29-Apr-2017 18:26:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_import_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_import_OutputFcn, ...
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


% --- Executes just before Inter_import is made visible.
function Inter_import_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_import (see VARARGIN)

% Choose default command line output for Inter_import
handles.output=varargin{1};
handles.cxd=varargin{2};
set(hObject,'closeRequestFcn',[])
handles.images=[];
handles.showframe=1;
handles.currentimage=1;
handles=set_options(handles);
axes(handles.axes1);
imshow(imadjust(handles.images(:,:,1)));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_import wait for user response (see UIRESUME)
 uiwait(handles.figure1);


function handles=set_options(handles)
    reading_necessary=1;
    if ~isempty(handles.images)
            reading_necessary=0;
    end
            
    if reading_necessary
        [images,~,nb_frames]=LFD_MPIV_read_cxd(handles.cxd,[],-1,[],'Reading from CXD file');
        handles.images=images;
        handles.output.source_frames=nb_frames;
        
    end
    
    switch handles.output.background
        case 'auto'
            set(handles.remove_back_selec,'Value',1)
        case 'min'
            set(handles.remove_back_selec,'Value',2)
        case 'avg'
            set(handles.remove_back_selec,'Value',3)
        case 'none'
            set(handles.remove_back_selec,'Value',4)
    end
    
    set(handles.frame_nb,'String',num2str(handles.currentimage));
    
    set(handles.cut_dir_choice,'Value',handles.output.dire);
    
    if handles.output.source_frames==1
        set(handles.frame_mode,'String',{'Time series','Successive'});
        if strcmp(handles.output.frame_mode,'TimeSeries')
            set(handles.frame_mode,'Value',1)
        else
            set(handles.frame_mode,'Value',2)
        end
    else
        set(handles.frame_mode,'String',{'AB','AA'});
        if strcmp(handles.output.frame_mode,'AB')
            set(handles.frame_mode,'Value',1)
        else
            set(handles.frame_mode,'Value',2)
        end
    end
    
    if strcmp(handles.output.frame_mode,'AB')
        set(handles.skip_edt,'enable','off')
    else
        set(handles.skip_edt,'enable','on')
    end
    
    set(handles.skip_edt,'String',num2str(handles.output.frame_skip));
    %% saving frame editing options 
    roi=handles.output.roi;
    mask=handles.output.mask;
    flip_ver=handles.output.flip_ver;
    flip_hor=handles.output.flip_hor;
    rotation=handles.output.rotation;
    %% resetting
    handles.output.roi=[];
    handles.output.mask=[];
    handles.output.flip_ver=0;
    handles.output.flip_hor=0;
    handles.output.rotation=0;
    
    handles.frames=LFD_MPIV_prepare_frames(handles.images,handles.output);
    
    handles.nb_image_pair=length(handles.frames);
    set(handles.infotext,'String',sprintf('View image pair number               (of %d)',handles.nb_image_pair));
    handles.currentimage=max(1,round(handles.currentimage));
    handles.currentimage=min(handles.nb_image_pair,round(handles.currentimage));
    set(handles.slider1,'Value',(handles.currentimage-1)/(handles.nb_image_pair-1))
    handles.frames=handles.frames(handles.currentimage);
    
    
    
    %% write
    show_frame(handles);
    %% restoring
    handles.output.roi=roi;
    handles.output.mask=mask;
    handles.output.flip_ver=flip_ver;
    handles.output.flip_hor=flip_hor;
    handles.output.rotation=rotation;
    
    
    function show_frame(handles)
        axes(handles.axes2)
        if handles.showframe==1
            activeframe=handles.frames.frameA;
            set(handles.frametxt,'string','A')
        else
            activeframe=handles.frames.frameB;
            set(handles.frametxt,'string','B')
        end
        imshow(imadjust(activeframe));
        
    
    
        


% --- Outputs from this function are returned to the command line.
function varargout = Inter_import_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
varargout{1} = handles.output;
close(hObject)

% --- Executes on selection change in frame_mode.
function frame_mode_Callback(hObject, eventdata, handles)
% hObject    handle to frame_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
selected=contents{get(hObject,'Value')};
if strcmp(selected,'Time series')
    selected='TimeSeries';
end
handles.output.frame_mode=selected;
handles=set_options(handles);
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns frame_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frame_mode


% --- Executes during object creation, after setting all properties.
function frame_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in change_frame_bttn.
function change_frame_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to change_frame_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.showframe==1
    handles.showframe=2;
else
    handles.showframe=1;
end
show_frame(handles);
guidata(hObject,handles);

    

% --- Executes on button press in quick_piv_bttn.
function quick_piv_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to quick_piv_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
quick_piv_params=LFD_MPIV_parameters;
quick_piv_params.frame_mode=handles.output.frame_mode;
quick_piv_params.frame_skip=handles.output.frame_skip;
quick_piv_params.dire=handles.output.dire;
quick_piv_params.IntWin=64;
quick_piv_params.nb_phases=1;
c=colormap;
axes(handles.axes2);
LFD_MPIV_PIV(handles.frames,quick_piv_params);
colormap(c);


function skip_edt_Callback(hObject, eventdata, handles)
% hObject    handle to skip_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.frame_skip=str2double(get(hObject,'String'));
handles=set_options(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of skip_edt as text
%        str2double(get(hObject,'String')) returns contents of skip_edt as a double


% --- Executes during object creation, after setting all properties.
function skip_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skip_edt (see GCBO)
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


% --- Executes on selection change in cut_dir_choice.
function cut_dir_choice_Callback(hObject, eventdata, handles)
% hObject    handle to cut_dir_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.dire=get(hObject,'Value');
handles=set_options(handles);
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns cut_dir_choice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cut_dir_choice


% --- Executes during object creation, after setting all properties.
function cut_dir_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_dir_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in remove_back_selec.
function remove_back_selec_Callback(hObject, eventdata, handles)
% hObject    handle to remove_back_selec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.output.background=contents{get(hObject,'Value')};
handles=set_options(handles);
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns remove_back_selec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from remove_back_selec


% --- Executes during object creation, after setting all properties.
function remove_back_selec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_back_selec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currentimage=round(get(hObject,'Value')*(handles.nb_image_pair-1)+1);
handles=set_options(handles);
guidata(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function frame_nb_Callback(hObject, eventdata, handles)
% hObject    handle to frame_nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currentimage=str2double(get(hObject,'String'));
handles=set_options(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of frame_nb as text
%        str2double(get(hObject,'String')) returns contents of frame_nb as a double


% --- Executes during object creation, after setting all properties.
function frame_nb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_bttn.
function select_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to select_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=Inter_image_index(handles.output,size(handles.images,3));
guidata(hObject,handles);
