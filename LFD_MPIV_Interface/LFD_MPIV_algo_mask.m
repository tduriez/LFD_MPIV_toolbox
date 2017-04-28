function varargout = LFD_MPIV_algo_mask(varargin)
% LFD_MPIV_ALGO_MASK MATLAB code for LFD_MPIV_algo_mask.fig
%      LFD_MPIV_ALGO_MASK, by itself, creates a new LFD_MPIV_ALGO_MASK or raises the existing
%      singleton*.
%
%      H = LFD_MPIV_ALGO_MASK returns the handle to a new LFD_MPIV_ALGO_MASK or the handle to
%      the existing singleton*.
%
%      LFD_MPIV_ALGO_MASK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LFD_MPIV_ALGO_MASK.M with the given input arguments.
%
%      LFD_MPIV_ALGO_MASK('Property','Value',...) creates a new LFD_MPIV_ALGO_MASK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LFD_MPIV_algo_mask_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LFD_MPIV_algo_mask_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LFD_MPIV_algo_mask

% Last Modified by GUIDE v2.5 06-Mar-2017 17:03:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LFD_MPIV_algo_mask_OpeningFcn, ...
                   'gui_OutputFcn',  @LFD_MPIV_algo_mask_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
     
     if ~isempty(strfind(varargin{1},'CreateFcn')) || ~isempty(strfind(varargin{1},'Callback')) 
        gui_State.gui_Callback = str2func(varargin{1});
     end
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LFD_MPIV_algo_mask is made visible.
function LFD_MPIV_algo_mask_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LFD_MPIV_algo_mask (see VARARGIN)

% Choose default command line output for LFD_MPIV_algo_mask
set(handles.info,'String','Initializing...');
filename=varargin{1};
handles.parameters=varargin{2};
handles.std_cut=0;
handles.eros=0;
handles.std_viz_cut=0.9;

[images]=LFD_MPIV_read_cxd(filename,[],-1,'std');
handles.first_im=images(:,:,1);
handles.std_map=images(:,:,2);
[c,h]=hist(double(handles.std_map(:)),1:max(double(handles.std_map(:))));
handles.std_lims=h;
handles.std_hist=c;
handles.output=show_mask(handles);

set(handles.edit1,'String',num2str(handles.std_cut));
set(handles.edit2,'String',num2str(handles.eros));




set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);
set(handles.info,'String','Initialized');
% UIWAIT makes LFD_MPIV_algo_mask wait for user response (see UIRESUME)
 uiwait(handles.figure1);

function mask=show_mask(handles)
warning('off','MATLAB:contour:ConstantData'); %% remove warning when mask is empty
cla(handles.axes1);
set(handles.info,'String','Computing mask...');
set(handles.edit1,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.slider1,'Enable','off')

drawnow
    mask=handles.std_map>handles.std_cut;
    set(handles.dilation_edt,'String',sprintf(...
        'Dilate %d pixels\nErode %d pixels\nDilate %d pixels',...
        round(0.8*handles.eros),round(1*handles.eros),round(0.3*handles.eros)));
        
    if handles.eros>0
    se1 = strel('disk',round(0.8*handles.eros));
    se2 = strel('disk',round(1*handles.eros));
    se3 = strel('disk',round(0.3*handles.eros));
    
    mask=imdilate(mask,se1);
    mask=imerode(mask,se2);
    mask=imdilate(mask,se3);
    end
    
    if handles.parameters.source_frames==2 %% double frame
        shiftblock=[circshift([1 2],[0 handles.parameters.dire]) 3];
        mask=permute(mask,shiftblock);
        s=size(mask);
        maskA=permute(mask(:,1:s(2)/2),shiftblock);
        maskB=permute(mask(:,s(2)/2+1:end),shiftblock);
        mask=(((maskA+maskB)>=1));
    end
    
    [~,k]=min(abs(cumsum(handles.std_hist)/sum(handles.std_hist)-handles.std_viz_cut));
    
         
    
    axes(handles.axes1);
    
    imshow(imadjust(handles.first_im));hold on
    contour(double(mask),'r')
    axes(handles.axes2);
    plot(handles.std_lims,handles.std_hist/max(handles.std_hist));hold on
    plot(handles.std_lims,cumsum(handles.std_hist)/sum(handles.std_hist))
    plot([handles.std_cut handles.std_cut],[0 1]);hold off
    set(gca,'xlim',[0 handles.std_lims(k)])
    set(handles.info,'String','Done');
    set(handles.edit1,'Enable','on')
set(handles.edit2,'Enable','on')
set(handles.slider1,'Enable','on')

    
    
    
    
% --- Outputs from this function are returned to the command line.
function varargout = LFD_MPIV_algo_mask_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.info,'String','Exporting mask...');
set(handles.edit1,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.slider1,'Enable','off')

set(hObject,'closeRequestFcn','closereq');
handles.parameters.mask=handles.mask;
% Get default command line output from handles structure
varargout{1} = handles.parameters;
close(hObject);



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,k]=min(abs(cumsum(handles.std_hist)/sum(handles.std_hist)-handles.std_viz_cut));
handles.std_cut=get(hObject,'Value')*(handles.std_lims(k));
handles.mask=show_mask(handles);
set(handles.edit1,'String',num2str(handles.std_cut));
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



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,k]=min(abs(cumsum(handles.std_hist)/sum(handles.std_hist)-handles.std_viz_cut));
handles.std_cut=str2double(get(hObject,'String'));
handles.mask=show_mask(handles);
set(handles.slider1,'Value',handles.std_cut/(handles.std_lims(k)));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.eros=str2double(get(hObject,'String'));
handles.mask=show_mask(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
