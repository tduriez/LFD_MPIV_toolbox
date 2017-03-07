function varargout = Inter_check_my_TTL(varargin)
% INTER_CHECK_MY_TTL MATLAB code for Inter_check_my_TTL.fig
%      INTER_CHECK_MY_TTL, by itself, creates a new INTER_CHECK_MY_TTL or raises the existing
%      singleton*.
%
%      H = INTER_CHECK_MY_TTL returns the handle to a new INTER_CHECK_MY_TTL or the handle to
%      the existing singleton*.
%
%      INTER_CHECK_MY_TTL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_CHECK_MY_TTL.M with the given input arguments.
%
%      INTER_CHECK_MY_TTL('Property','Value',...) creates a new INTER_CHECK_MY_TTL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_check_my_TTL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_check_my_TTL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inter_check_my_TTL

% Last Modified by GUIDE v2.5 09-Feb-2017 17:27:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_check_my_TTL_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_check_my_TTL_OutputFcn, ...
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


% --- Executes just before Inter_check_my_TTL is made visible.
function Inter_check_my_TTL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_check_my_TTL (see VARARGIN)

% Choose default command line output for Inter_check_my_TTL
cxd=varargin{1};
ttl_folder=varargin{2};

d=dir(ttl_folder);
length(cxd)

for i=1:length(cxd)
    [~,patter,~]=fileparts(cxd{i});
    pattern=strip_string(patter);
    simi=zeros(1,numel(d));
    for j=1:length(d);
        name=strip_string(d(j).name);
        simi(j)=stringsimilarity(pattern,name);
    end
    [~,k]=max(simi);
    ttl{i}=d(k).name;
    list_check{i}=sprintf('%s:    %s',patter,ttl{i})
    set(handles.list_check,'String',list_check);
    handles.ttl_file{i}=fullfile(ttl_folder,ttl{i});
end
set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_check_my_TTL wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inter_check_my_TTL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
% Get default command line output from handles structure
varargout{1} = handles.ttl_file;
close(hObject);


% --- Executes on selection change in list_check.
function list_check_Callback(hObject, eventdata, handles)
% hObject    handle to list_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_check contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_check


% --- Executes during object creation, after setting all properties.
function list_check_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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


    function new_string=strip_string(my_string)
        new_string=lower(my_string);
        new_string(new_string=='-')=[];
        new_string(new_string=='_')=[];
    

    function simi=stringsimilarity(string1,string2)
        if length(string1)>length(string2);
            string3=string2;string2=string1;string1=string3;
        end
        simi=0;
        for i=1:(length(string2)-length(string1)+1)
            simi=max(simi,sum(string1==string2(i:length(string1)-1+i)));
        end
    
        
