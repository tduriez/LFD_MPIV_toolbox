function varargout = LFD_MPIV_quick_check(varargin)
% LFD_MPIV_QUICK_CHECK MATLAB code for LFD_MPIV_quick_check.fig
%      LFD_MPIV_QUICK_CHECK, by itself, creates a new LFD_MPIV_QUICK_CHECK or raises the existing
%      singleton*.
%
%      H = LFD_MPIV_QUICK_CHECK returns the handle to a new LFD_MPIV_QUICK_CHECK or the handle to
%      the existing singleton*.
%
%      LFD_MPIV_QUICK_CHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LFD_MPIV_QUICK_CHECK.M with the given input arguments.
%
%      LFD_MPIV_QUICK_CHECK('Property','Value',...) creates a new LFD_MPIV_QUICK_CHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LFD_MPIV_quick_check_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LFD_MPIV_quick_check_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LFD_MPIV_quick_check

% Last Modified by GUIDE v2.5 18-May-2017 13:17:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LFD_MPIV_quick_check_OpeningFcn, ...
                   'gui_OutputFcn',  @LFD_MPIV_quick_check_OutputFcn, ...
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


% --- Executes just before LFD_MPIV_quick_check is made visible.
function LFD_MPIV_quick_check_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LFD_MPIV_quick_check (see VARARGIN)

% Choose default command line output for LFD_MPIV_quick_check
handles.output = hObject;
handles.daemon_started=0;
set(hObject,'CurrentCharacter','a')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LFD_MPIV_quick_check wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LFD_MPIV_quick_check_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listcxd.
function listcxd_Callback(hObject, eventdata, handles)
% hObject    handle to listcxd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.the_cxd=contents{get(hObject,'Value')};
display_the_cxd(handles);
guidata(hObject,handles);


% Hints: contents = cellstr(get(hObject,'String')) returns listcxd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listcxd


% --- Executes during object creation, after setting all properties.
function listcxd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listcxd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function display_the_cxd(handles)
    try_read=0;
    while ~try_read
        try
            LFD_MPIV_read_images(fullfile(handles.the_folder,handles.the_cxd),4,0);
            try_read=1;
        catch
            fprintf('Couldn''t read %s. Retry',handles.the_cxd);
        end
    end
    
    
    switch get(handles.intwin_pop,'Value')
        case 1
            IntWin=128;
        case 2
            IntWin=64;
        case 3
            IntWin=32;
        case 4        
            IntWin=16;
    end
    axes(handles.axes1);
    data=LFD_MPIV_CommandLine(fullfile(handles.the_folder,handles.the_cxd),...
        'image_indices',4,'IntWin',IntWin,'Verbose',0,'background','none',...
        'cumulcross',0);
    xlabel('x (pxl)')
    ylabel('y (pxl)')
    axes(handles.axes2)
     switch get(handles.histo_pop,'Value')
         case 1
             desp=data.u;
             lbl='Horizontal component displacement (pxl)';
         case 2
             desp=data.v;
             lbl='Vertical component displacement (pxl)';
         case 3
            desp=sqrt(data.u.^2+data.v.^2);
            lbl='Total displacement (pxl)';
     end
    [pop,bins]=hist(desp(:),min(1000,numel(desp)));
    plot(bins,pop)
    xlabel(lbl);
    ylabel('population')
    


% --- Executes on button press in choose_folder.
function choose_folder_Callback(hObject, eventdata, handles)
% hObject    handle to choose_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.the_folder=uigetdir;
populate_list(handles);
guidata(hObject,handles);

function populate_list(handles)
    d=dir(fullfile(handles.the_folder,'*.cxd'));
    the_list=cell(1,length(d));
    for i=1:length(d)
        the_list{i}=d(i).name;
    end
    set(handles.listcxd,'String',the_list,'Value',1);

    
    

% --- Executes on selection change in intwin_pop.
function intwin_pop_Callback(hObject, eventdata, handles)
% hObject    handle to intwin_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_the_cxd(handles)
% Hints: contents = cellstr(get(hObject,'String')) returns intwin_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from intwin_pop


% --- Executes during object creation, after setting all properties.
function intwin_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intwin_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in histo_pop.
function histo_pop_Callback(hObject, eventdata, handles)
% hObject    handle to histo_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_the_cxd(handles)
% Hints: contents = cellstr(get(hObject,'String')) returns histo_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from histo_pop


% --- Executes during object creation, after setting all properties.
function histo_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histo_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in daemon_start.
function daemon_start_Callback(hObject, eventdata, handles)
% hObject    handle to daemon_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    fprintf('Initializing daemon\n')
    set_all(handles,'off');
    set(handles.daemon_start,'String','Press ESC to stop daemon','enable','off');
    known_cxd=check_directory(handles.the_folder,{},1);
    while  double(get(gcf,'CurrentCharacter'))~=27
        [known_cxd,new_cxd]=check_directory(handles.the_folder,known_cxd,0);
        populate_list(handles);
        pause(1);
        if ~isempty(new_cxd)
            handles.the_cxd=new_cxd{end};
            fprintf('New CXD found: %s\n',handles.the_cxd);
            display_the_cxd(handles)
        end
            
    end
    fprintf('Daemon stopped\n');
    set(handles.daemon_start,'String','Start daemon','enable','on');
    set(gcf,'CurrentCharacter','a');
    set_all(handles,'on');

    function set_all(handles,state);
        set(handles.choose_folder,'enable',state)
        set(handles.listcxd,'enable',state)
    
    
function [known_cxd,new_cxd]=check_directory(the_folder,known_cxd,init)
    new_cxd=[];
    d=dir(fullfile(the_folder,'*.cxd'));
    present_cxd=cell(1,length(d));
    for i=1:length(d)
        present_cxd{i}=d(i).name;
    end
    
    if init==1
        known_cxd=present_cxd;
        return
    end
       
    new_cxd=setdiff(present_cxd,known_cxd);
 
    if isempty(new_cxd)
        return
    end
    if length(new_cxd)>1
        fprintf('More than one new CXD\nReading the last one...\nWhat the heck are you doing ?\n')
    end
    known_cxd=present_cxd;
