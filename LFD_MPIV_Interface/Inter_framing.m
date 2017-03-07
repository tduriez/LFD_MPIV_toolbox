function varargout = Inter_framing(varargin)
% INTER_FRAMING MATLAB code for Inter_framing.fig
%      INTER_FRAMING, by itself, creates a new INTER_FRAMING or raises the existing
%      singleton*.
%
%      H = INTER_FRAMING returns the handle to a new INTER_FRAMING or the handle to
%      the existing singleton*.
%
%      INTER_FRAMING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_FRAMING.M with the given input arguments.
%
%      INTER_FRAMING('Property','Value',...) creates a new INTER_FRAMING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_framing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_framing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_framing

% Last Modified by GUIDE v2.5 15-Feb-2017 17:56:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_framing_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_framing_OutputFcn, ...
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


% --- Executes just before Inter_framing is made visible.
function Inter_framing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_framing (see VARARGIN)

% Choose default command line output for Inter_framing
allowed_args ={'CxdFile','InputImageType','Framing','FramingStep','dire'   };
allowed_types={'char'   ,'char'          ,'char'   ,'numeric'    ,'numeric'};

handles.output=parameters_parser(varargin,allowed_args,allowed_types,[],0);
set_buttons(handles);
set(handles.txt_service,'String','Opening file...');
handles.images=LFD_MPIV_read_cxd(handles.output.CxdFile,[],0);
[A,B,list_frames]=calculate_frames(handles);
handles.A=A;
handles.B=B;
handles.list_frames=list_frames;
display_setup(handles);
set(hObject,'closeRequestFcn',[])

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_framing wait for user response (see UIRESUME)
 uiwait(handles.figure1);
 
    function set_buttons(handles);
        switch handles.output.InputImageType
            case 'DoubleFrame'
                set(handles.frame_type,'Value',2);
                set(handles.selec_framing,'String',{'1A-1B 2A-2B',sprintf('1A-%dA 1B-%dB',...
                    handles.output.FramingStep,handles.output.FramingStep)});
                switch 'Framing'
                    case 'AB'
                        set(handles.selec_framing,'Value',1);
                    case 'AA'
                        set(handles.selec_framing,'Value',2);
                end
            case 'SingleFrame'
                set(handles.frame_type,'Value',1);
                set(handles.selec_framing,'String',{sprintf('1-%d 2-%d',...
                    handles.output.FramingStep+1,handles.output.FramingStep+2),...
                    sprintf('1-%d %d-%d',...
                    1+handles.output.FramingStep,2+handles.output.FramingStep,2+2*handles.output.FramingStep)});
                switch 'Framing'
                    case 'TimeSeries'
                        set(handles.selec_framing,'Value',1);
                    case 'Successive'
                        set(handles.selec_framing,'Value',2);
                end
        end

 function [A,B,list_frames]=calculate_frames(handles)
     switch handles.output.InputImageType
         case 'DoubleFrame'
             images=LFD_MPIV_cut_images(handles.images,'dire',handles.output.dire);
             switch handles.output.Framing
                 case 'AB'
                     A=images(1).frameA;
                     B=images(1).frameB;
                     for i=1:numel(images)
                         list_frames{i}=sprintf('Image %d A x Image %d B',i,i);
                     end
                 case 'AA'
                     A=images(1).frameA;
                     B=images(1+handles.output.FramingStep).frameA;
                     for i=1:numel(images)-handles.output.FramingStep
                         list_frames{2*i-1}=sprintf('Image %d A x Image %d A',i,i+handles.output.FramingStep);
                     end
                     for i=1:numel(images)-handles.output.FramingStep
                         list_frames{2*i}=sprintf('Image %d B x Image %d B',i,i+handles.output.FramingStep);
                     end
             end
         case 'SingleFrame'
             images=handles.images;
             if ~any(strcmpi({'TimeSeries','Successive'},handles.output.Framing));
                 handles.output.Framing='TimeSeries';
             end
            switch handles.output.Framing
                 case 'TimeSeries'
                    A=images(:,:,1);
                    B=images(:,:,1+handles.output.FramingStep);
                    for i=1:size(images,3)-handles.output.FramingStep
                        list_frames{i}=sprintf('Image %d x Image %d',i,i+handles.output.FramingStep);
                    end
                case 'Successive'
                    A=images(:,:,1);
                    B=images(:,:,1+handles.output.FramingStep);
                    next_firstframe=1;
                    next_secondframe=1+handles.output.FramingStep;
                    i=0;
                    while next_secondframe<size(images,3);
                        i=i+1;
                        list_frames{i}=sprintf('Image %d x Image %d',next_firstframe,next_secondframe);
                        next_firstframe=next_secondframe+1;
                        next_secondframe=next_firstframe+handles.output.FramingStep;
                    end
            end
     end
     set(handles.list_frames,'String',list_frames)
     
                     
                     
             
 
 
function display_setup(handles)
    
s=size(handles.images);
set(handles.txt_service,'String',sprintf('File opened: %d images in CXD',s(3)));






% --- Outputs from this function are returned to the command line.
function varargout = Inter_framing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
% Get default command line output from handles structure
varargout{1} = handles.output;
close(hObject);



% --- Executes on selection change in frame_type.
function frame_type_Callback(hObject, eventdata, handles)
% hObject    handle to frame_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject,'Value')
    case 1
        handles.output.InputImageType='SingleFrame';
    case 2
        handles.output.InputImageType='DoubleFrame';
end
set_buttons(handles);
guidata(hObject,handles);
        

% Hints: contents = cellstr(get(hObject,'String')) returns frame_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frame_type


% --- Executes during object creation, after setting all properties.
function frame_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selec_framing.
function selec_framing_Callback(hObject, eventdata, handles)
% hObject    handle to selec_framing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selec_framing contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selec_framing


% --- Executes during object creation, after setting all properties.
function selec_framing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selec_framing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edt_framing_step_Callback(hObject, eventdata, handles)
% hObject    handle to edt_framing_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_framing_step as text
%        str2double(get(hObject,'String')) returns contents of edt_framing_step as a double


% --- Executes during object creation, after setting all properties.
function edt_framing_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edt_framing_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in switch_bttn.
function switch_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to switch_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in list_frames.
function list_frames_Callback(hObject, eventdata, handles)
% hObject    handle to list_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_frames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_frames


% --- Executes during object creation, after setting all properties.
function list_frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in zoom_in_bttn.
function zoom_in_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_in_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in zoom_out_bttn.
function zoom_out_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_out_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exit_bttn.
function exit_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to exit_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume