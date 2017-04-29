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

% Last Modified by GUIDE v2.5 29-Apr-2017 17:56:01

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
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_image_index wait for user response (see UIRESUME)
 uiwait(handles.figure1);

    function update_list(handles)
        image_list_str=[];
        
        for i=1:handles.nb_images
            if isempty(intersect(i,handles.image_indices))
                state='excl.';
            else
                state='included';
            end
            image_list_str=sprintf('%s\nImage #%d %s',image_list_str,i,state);
        end
        
        set(handles.listbox1,'String',image_list_str);
            

% --- Outputs from this function are returned to the command line.
function varargout = Inter_image_index_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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



function index_edt_Callback(hObject, eventdata, handles)
% hObject    handle to index_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of index_edt as text
%        str2double(get(hObject,'String')) returns contents of index_edt as a double


% --- Executes during object creation, after setting all properties.
function index_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_from_bttn.
function add_from_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to add_from_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_from_bttn.
function remove_from_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_from_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in add_upto_bttn.
function add_upto_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to add_upto_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_upto_bttn.
function remove_upto_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_upto_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in add_selec_bttn.
function add_selec_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to add_selec_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_selec_bttn.
function remove_selec_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_selec_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in all_bttn.
function all_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to all_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in none_bttn.
function none_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to none_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in done_bttn.
function done_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to done_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
