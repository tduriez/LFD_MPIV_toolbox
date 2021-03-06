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

% Last Modified by GUIDE v2.5 28-Mar-2017 15:42:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_synchro_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_synchro_OutputFcn, ...
                   'gui_LayoutFcn',  @Inter_synchro_LayoutFcn, ...
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
handles.output=varargin{1};
handles.cxd=varargin{2};

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
    handles.output.ttl_folder='';
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
guidata(hObject,handles);



% --- Creates and returns a handle to the GUI figure. 
function h1 = Inter_synchro_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'text', 5, ...
    'edit', 4, ...
    'pushbutton', 5, ...
    'checkbox', 2), ...
    'override', 0, ...
    'release', [], ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', '/home/thomas/Documents/00_gits_reps/LFD_MPIV_toolbox/private/Inter_synchro.m', ...
    'lastFilename', '/home/thomas/Documents/00_gits_reps/LFD_MPIV_toolbox/LFD_MPIV_Interface/Inter_synchro.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'Position',[135.714285714286 38.6875 96.7142857142857 18.75],...
'Visible',get(0,'defaultfigureVisible'),...
'Color',get(0,'defaultfigureColor'),...
'IntegerHandle','off',...
'MenuBar','none',...
'Name','Inter_synchro',...
'NumberTitle','off',...
'Resize','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'ScreenPixelsPerInchMode','manual',...
'ParentMode','manual',...
'HandleVisibility','callback',...
'Tag','figure1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'act_freq_edt';

h2 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','0',...
'Style','edit',...
'Position',[4.28571428571429 5.375 10.7142857142857 2.125],...
'Callback',@(hObject,eventdata)Inter_synchro('act_freq_edt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Inter_synchro('act_freq_edt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','act_freq_edt');

appdata = [];
appdata.lastValidTag = 'text2';

h3 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Actuation frequency',...
'Style','text',...
'Position',[4.28571428571429 7.5 11.2857142857143 2.25],...
'Children',[],...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text2');

appdata = [];
appdata.lastValidTag = 'nb_phases_edt';

h4 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','1',...
'Style','edit',...
'Position',[19 5.375 10.7142857142857 2.125],...
'Callback',@(hObject,eventdata)Inter_synchro('nb_phases_edt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Inter_synchro('nb_phases_edt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','nb_phases_edt');

appdata = [];
appdata.lastValidTag = 'text3';

h5 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Number of phases',...
'Style','text',...
'Position',[19 7.5 11.2857142857143 2.25],...
'Children',[],...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text3');

appdata = [];
appdata.lastValidTag = 'ttl_bttn';

h6 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Set TTL folder',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[2.57142857142857 16.375 16.7142857142857 1.3125],...
'Callback',@(hObject,eventdata)Inter_synchro('ttl_bttn_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','ttl_bttn');

appdata = [];
appdata.lastValidTag = 'acq_freq_edt';

h7 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','5',...
'Style','edit',...
'Position',[4.85714285714286 11.5 10.7142857142857 2.125],...
'Callback',@(hObject,eventdata)Inter_synchro('acq_freq_edt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'Enable','off',...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Inter_synchro('acq_freq_edt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','acq_freq_edt');

appdata = [];
appdata.lastValidTag = 'check_acq';

h8 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Use one acquisition frequency',...
'Style','checkbox',...
'Position',[4.71428571428571 13.875 31.4285714285714 1.5625],...
'Callback',@(hObject,eventdata)Inter_synchro('check_acq_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','check_acq');

appdata = [];
appdata.lastValidTag = 'close_bttn';

h9 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Update and close',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[70.4285714285714 0.75 22.2857142857143 2.3125],...
'Callback',@(hObject,eventdata)Inter_synchro('close_bttn_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'Tag','close_bttn');

appdata = [];
appdata.lastValidTag = 'folder_txt';

h10 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'Static Text' },...
'Style','text',...
'Position',[26.8571428571429 16.1875 60.1428571428571 1.8125],...
'Children',[],...
'ParentMode','manual',...
'Tag','folder_txt',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'checkit_bttn';

h11 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Check it !',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[74.4285714285714 13.5625 11.2857142857143 2],...
'Callback',@(hObject,eventdata)Inter_synchro('checkit_bttn_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ParentMode','manual',...
'Tag','checkit_bttn',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % INTER_SYNCHRO
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % INTER_SYNCHRO(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % INTER_SYNCHRO('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % INTER_SYNCHRO(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || (isscalar(fig)&&isprop(fig,'GUIDEFigure'));
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    % Call version of openfig that accepts 'auto' option"
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton, visible);  
%     %workaround for CreateFcn not called to create ActiveX
%     if feature('HGUsingMATLABClasses')
%         peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
%         for i=1:length(peers)
%             if isappdata(peers(i),'Control')
%                 actxproxy(peers(i));
%             end            
%         end
%     end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


