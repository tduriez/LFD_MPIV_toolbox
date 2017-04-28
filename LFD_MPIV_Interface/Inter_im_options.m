function varargout = Inter_im_options(varargin)
% INTER_IM_OPTIONS MATLAB code for Inter_im_options.fig
%      INTER_IM_OPTIONS, by itself, creates a new INTER_IM_OPTIONS or raises the existing
%      singleton*.
%
%      H = INTER_IM_OPTIONS returns the handle to a new INTER_IM_OPTIONS or the handle to
%      the existing singleton*.
%
%      INTER_IM_OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_IM_OPTIONS.M with the given input arguments.
%
%      INTER_IM_OPTIONS('Property','Value',...) creates a new INTER_IM_OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_im_options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_im_options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_im_options

% Last Modified by GUIDE v2.5 27-Apr-2017 23:46:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_im_options_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_im_options_OutputFcn, ...
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


% --- Executes just before Inter_im_options is made visible.
function Inter_im_options_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_im_options (see VARARGIN)

% Choose default command line output for Inter_synchro
handles.output=varargin{1};
handles.cxd=varargin{2};
handles.current_frame=0;

set(handles.service_text,'String',[],'BackgroundColor',[0.94 0.94 0.94])
set(handles.hor_flip,'Value',handles.output.flip_hor);
set(handles.ver_flip,'Value',handles.output.flip_ver);
set(handles.rotation_selec,'Value',handles.output.rotation+1);

handles.im_size=display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

if isempty(handles.output.roi);
    handles.output.roi=[1 handles.im_size(2) 1 handles.im_size(1)];
end
set(handles.roi_edt,'String',sprintf('%d ',handles.output.roi));
set(handles.xmin_slider,'Value',handles.output.roi(1)/handles.im_size(2));
set(handles.xmax_slider,'Value',handles.output.roi(2)/handles.im_size(2));
set(handles.ymin_slider,'Value',handles.output.roi(3)/handles.im_size(1));
set(handles.ymax_slider,'Value',handles.output.roi(4)/handles.im_size(1));






set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_synchro wait for user response (see UIRESUME)
 uiwait(handles.figure1);

 
 
        
    
 

% --- Outputs from this function are returned to the command line.
function varargout = Inter_im_options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
% Get default command line output from handles structure


varargout{1} = handles.output;
close(hObject);






function roi_edt_Callback(hObject, eventdata, handles)
% hObject    handle to roi_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    eval(sprintf('handles.output.roi=[%s];',get(hObject,'String')));
    if ~isa(handles.output.roi,'numeric')
         set(handles.service_text,'String',...
        'We are expecting 4 integers...',...
        'BackgroundColor',[1 0.94 0.94]);
    else
        if any(handles.output.roi~=round(handles.output.roi)) || numel(handles.output.roi)~=4
              set(handles.service_text,'String',...
        'We are expecting 4 integers...',...
        'BackgroundColor',[1 0.94 0.94]);
        else
            set(handles.service_text,'String',...
        [],...
        'BackgroundColor',[0.94 0.94 0.94]);
    
        display_image(handles.cxd,handles.output,handles.axes1);
          set(handles.xmin_slider,'Value',(handles.output.roi(1)-1)/(handles.im_size(2)-1));
          set(handles.xmax_slider,'Value',(handles.output.roi(2)-1)/(handles.im_size(2)-1));
          set(handles.ymin_slider,'Value',(handles.output.roi(3)-1)/(handles.im_size(1)-1));
          set(handles.ymax_slider,'Value',(handles.output.roi(4)-1)/(handles.im_size(1)-1));
        
          
          guidata(hObject,handles);
        end
    end
catch err
    set(handles.service_text,'String',...
        sprintf('Invalid expression. Matlab says:\n%s',err.message),...
        'BackgroundColor',[1 0.94 0.94]);
end


    

% Hints: get(hObject,'String') returns contents of roi_edt as text
%        str2double(get(hObject,'String')) returns contents of roi_edt as a double


% --- Executes during object creation, after setting all properties.
function roi_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_edt (see GCBO)
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
uiresume




% --- Executes on button press in hor_flip.
function hor_flip_Callback(hObject, eventdata, handles)
% hObject    handle to hor_flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.flip_hor=get(hObject,'Value');
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of hor_flip


% --- Executes on button press in ver_flip.
function ver_flip_Callback(hObject, eventdata, handles)
% hObject    handle to ver_flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.flip_ver=get(hObject,'Value');
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of ver_flip


% --- Executes on selection change in rotation_selec.
function rotation_selec_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_selec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.rotation=get(hObject,'Value')-1;
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns rotation_selec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rotation_selec


% --- Executes during object creation, after setting all properties.
function rotation_selec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_selec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on slider movement.
function xmin_slider_Callback(hObject, eventdata, handles)
% hObject    handle to xmin_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
xmin_value=get(hObject,'Value');
ixmin=floor(xmin_value*(handles.im_size(2)-1))+1;
set(handles.xmax_slider,'Min',(ixmin)/(handles.im_size(2)-1));
handles.output.roi(1)=ixmin;
roi=handles.output.roi;
set(handles.roi_edt,'String',sprintf('[%d %d %d %d]',roi(1),roi(2),roi(3),roi(4)))
%set(handles.service_text,'String',sprintf('%f',xmin_value));
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xmin_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function xmax_slider_Callback(hObject, eventdata, handles)
% hObject    handle to xmax_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xmax_value=get(hObject,'Value');
ixmax=floor(xmax_value*(handles.im_size(2)-1))+1;
set(handles.xmin_slider,'Max',(ixmax-2)/(handles.im_size(2)-1));
handles.output.roi(2)=ixmax;
roi=handles.output.roi;
set(handles.roi_edt,'String',sprintf('[%d %d %d %d]',roi(1),roi(2),roi(3),roi(4)))
%set(handles.service_text,'String',sprintf('%f',xmin_value));
guidata(hObject,handles);
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function xmax_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ymax_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ymax_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ymax_value=get(hObject,'Value');
iymax=floor(ymax_value*(handles.im_size(1)-1))+1;
set(handles.ymin_slider,'Max',(iymax-2)/(handles.im_size(1)-1));
handles.output.roi(4)=iymax;
roi=handles.output.roi;
set(handles.roi_edt,'String',sprintf('[%d %d %d %d]',roi(1),roi(2),roi(3),roi(4)))
%set(handles.service_text,'String',sprintf('%f',xmin_value));
guidata(hObject,handles);
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));


% --- Executes during object creation, after setting all properties.
function ymax_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ymin_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ymin_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ymin_value=get(hObject,'Value');
iymin=floor(ymin_value*(handles.im_size(1)-1))+1;
set(handles.ymax_slider,'Min',(iymin-2)/(handles.im_size(1)-1));
handles.output.roi(3)=iymin;
roi=handles.output.roi;
set(handles.roi_edt,'String',sprintf('[%d %d %d %d]',roi(1),roi(2),roi(3),roi(4)))
%set(handles.service_text,'String',sprintf('%f',xmin_value));
guidata(hObject,handles);
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ymin_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in set_mask_bttn.
function set_mask_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to set_mask_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datpushbuttona (see GUIDATA)

handles.output=LFD_MPIV_algo_mask(handles.cxd,handles.output);
display_image(handles.cxd,handles.output,handles.axes1);




% --- Executes on button press in clear_mask_bttn.
function clear_mask_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to clear_mask_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.mask=[];
display_image(handles.cxd,handles.output,handles.axes1);


% --- Executes on button press in showroi_box.
function showroi_box_Callback(hObject, eventdata, handles)
% hObject    handle to showroi_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=idx(1);
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(hObject,'Value'));
% Hint: get(hObject,'Value') returns toggle state of showroi_box


% --- Executes on button press in show_mask_box.
function show_mask_box_Callback(hObject, eventdata, handles)
% hObject    handle to show_mask_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(hObject,'Value')+8*get(handles.showroi_box,'Value'));

% Hint: get(hObject,'Value') returns toggle state of show_mask_box


% --- Executes on button press in change_frame_bttn.
function change_frame_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to change_frame_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.current_frame==0
    handles.current_frame=1;
    set(handles.current_frame_txt,'String','B');
else
     handles.current_frame=0;
     set(handles.current_frame_txt,'String','A');
end
display_image(handles.cxd,handles.output,handles.axes1,...
    2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));
guidata(hObject,handles);