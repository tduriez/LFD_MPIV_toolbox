function varargout = Inter_image_index(varargin)
% INTER_IMAGE_INDEX MATLAB code for Inter_image_index.fig
%      INTER_IMAGE_INDEX, by itself, creates a new INTER_IMAGE_INDEX or raises the existing
%      singleton*.
%
%      H = INTER_IMAGE_INDEX returns the handle to a new INTER_IMAGE_INDEX or the handle to
%      the existing singleton*.
%
%      INTER_IMAGE_INDEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_IMAGE_INDEX.M with the given input arguments.
%
%      INTER_IMAGE_INDEX('Property','Value',...) creates a new INTER_IMAGE_INDEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_image_index_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_image_index_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_image_index

% Last Modified by GUIDE v2.5 02-May-2017 14:51:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_image_index_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_image_index_OutputFcn, ...
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


% --- Executes just before Inter_image_index is made visible.
function Inter_image_index_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_image_index (see VARARGIN)

% Choose default command line output for Inter_image_index
handles.output = varargin{1};
handles.nb_images = varargin{2};
update_list(handles);
set(handles.listbox1,'Max',handles.nb_images);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_image_index wait for user response (see UIRESUME)
set(hObject,'closeRequestFcn',[])
 uiwait(handles.figure1);

    function update_list(handles)
       
        image_list_str=[];
        
        for i=1:handles.nb_images
            if (isempty(intersect(i,handles.output.image_indices)) && ~isempty(handles.output.image_indices))...
                    || ~isempty(intersect(handles.output.image_indices,-1));
                state='excl.';
            else
                state='included';
            end
            filler=repmat(' ',[1 8-length(sprintf('%d',i))]);
            image_list_str=sprintf('%sImage #%d%s %s\n',image_list_str,i,(filler),state);
        end
        set(handles.textinfo,'String','');
        set(handles.listbox1,'String',image_list_str);
            

% --- Outputs from this function are returned to the command line.
function varargout = Inter_image_index_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(hObject,'closeRequestFcn','closereq');
varargout{1} = handles.output;
close(hObject); 


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



% --- Executes on button press in add_selec_bttn.
function add_selec_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to add_selec_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.listbox1,'Value');
if ~isempty(idx)
    if isempty(handles.output.image_indices)
        return
    end
        
    
end
handles.output.image_indices=setdiff(unique(sort([handles.output.image_indices idx])),-1);
update_list(handles)
guidata(hObject,handles);

% --- Executes on button press in remove_selec_bttn.
function remove_selec_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_selec_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.listbox1,'Value');
if ~isempty(idx)
    if isempty(handles.output.image_indices)
        handles.output.image_indices=1:handles.nb_images;
    end
end

handles.output.image_indices=setdiff(handles.output.image_indices,idx);
if isempty(handles.output.image_indices);
    handles.output.image_indices=-1;
end
update_list(handles)
guidata(hObject,handles);


% --- Executes on button press in all_bttn.nb=num2str(get(handles.index_edt,'String'));

function all_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to all_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox1,'Value',1:handles.nb_images);


% --- Executes on button press in done_bttn.
function done_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to done_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n_min_images=handles.output.frame_skip+1;
n_selected_images=length(setdiff(handles.output.image_indices,-1));
if isempty(handles.output.image_indices)
    n_selected_images=handles.nb_images;
end
if n_selected_images<n_min_images
    set(handles.textinfo,'String',sprintf('With your current settings, you must select at least %d images. %d selected so far.',n_min_images,n_selected));
else
    uiresume
end
