function varargout = Inter_field_height(varargin)
% INTER_FIELD_HEIGHT MATLAB code for Inter_field_height.fig
%      INTER_FIELD_HEIGHT, by itself, creates a new INTER_FIELD_HEIGHT or raises the existing
%      singleton*.
%
%      H = INTER_FIELD_HEIGHT returns the handle to a new INTER_FIELD_HEIGHT or the handle to
%      the existing singleton*.
%
%      INTER_FIELD_HEIGHT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER_FIELD_HEIGHT.M with the given input arguments.
%
%      INTER_FIELD_HEIGHT('Property','Value',...) creates a new INTER_FIELD_HEIGHT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inter_field_height_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inter_field_height_OpeningFcn via varargin.
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

% Edit the above text to modify the response to help Inter_field_height

% Last Modified by GUIDE v2.5 14-Feb-2017 13:15:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_field_height_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_field_height_OutputFcn, ...
                   'gui_LayoutFcn',  @Inter_field_height_LayoutFcn, ...
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


% --- Executes just before Inter_field_height is made visible.
function Inter_field_height_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inter_field_height (see VARARGIN)

% Choose default command line output for Inter_field_height
handles.cxd=varargin{1};
handles.selected=varargin{2};
if numel(handles.selected)>1
handles.expression=sprintf('0:1:%d',(numel(handles.cxd(handles.selected))-1));
else
    handles.expression='0';
end
set(handles.expression_edt,'String',handles.expression);
handles.height=interpret_expression(handles);
set(hObject,'closeRequestFcn',[])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inter_field_height wait for user response (see UIRESUME)
uiwait(handles.figure1);

function  height=interpret_expression(handles)
    set(handles.pushbutton1,'Enable','Off');
     height=[];
      try %% Check expression validity
          eval(sprintf('height = %s;',handles.expression)); 
      catch err
          errormsg=sprintf('Invalid expression. Matlab says:\n%s',err.message);
          set(handles.text_verif,'String',errormsg,'backgroundColor',[1 0.94 0.94])
          return;
      end
      %% Check expression plausability
      if numel(height)~=numel(handles.cxd(handles.selected))
          errormsg=sprintf('%d elements in ''height'', %d CXD files selected',...
              numel(height),numel(handles.cxd(handles.selected)));
          set(handles.text_verif,'String',errormsg,'backgroundColor',[1 0.94 0.94]);
      else
          set(handles.text_verif,'String','Expression correct','backgroundColor',[0.94 1 0.94]);
          set(handles.pushbutton1,'Enable','On');
      end
      
      %% Update CXD list with height
      cxd=handles.cxd(handles.selected);
      textlist=cell(1,numel(cxd));
      for i=1:length(cxd)
          textlist{i}=sprintf('y=%+06.2f (mum): %s',height(i),cxd{i});
      end
      set(handles.list_cxd,'String',textlist,'Value',1);
      
      
      
          
      
      
      
      

% --- Outputs from this function are returned to the command line.
function varargout = Inter_field_height_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(hObject,'closeRequestFcn','closereq');

varargout{1} = handles.height;
close(hObject);




% --- Executes on selection change in list_cxd.
function list_cxd_Callback(hObject, eventdata, handles)
% hObject    handle to list_cxd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_cxd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_cxd


% --- Executes during object creation, after setting all properties.
function list_cxd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_cxd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function expression_edt_Callback(hObject, eventdata, handles)
% hObject    handle to expression_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.expression=get(hObject,'String');
handles.height=interpret_expression(handles);
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of expression_edt as text
%        str2double(get(hObject,'String')) returns contents of expression_edt as a double


% --- Executes during object creation, after setting all properties.
function expression_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expression_edt (see GCBO)
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


% --- Creates and returns a handle to the GUI figure. 
function h1 = Inter_field_height_LayoutFcn(policy)
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
    'listbox', 3, ...
    'edit', 2, ...
    'pushbutton', 2), ...
    'override', 0, ...
    'release', [], ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', '/mnt/Win_OS/Users/thomas/Dropbox/microflux-GPC/PIV/LFD_MPIV_quick_PIV/private/Inter_field_height.m', ...
    'lastFilename', '/mnt/Win_OS/Users/thomas/Dropbox/microflux-GPC/PIV/LFD_MPIV_quick_PIV/LFD_MPIV_Interface/Inter_field_height.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'Position',[135.714285714286 25.0625 112.142857142857 32.375],...
'PositionMode',get(0,'defaultfigurePositionMode'),...
'Visible',get(0,'defaultfigureVisible'),...
'Color',get(0,'defaultfigureColor'),...
'IntegerHandle','off',...
'MenuBar','none',...
'Name','Inter_field_height',...
'NumberTitle','off',...
'Resize','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'ScreenPixelsPerInchMode','manual',...
'ParentMode','manual',...
'HandleVisibility','callback',...
'Tag','figure1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text2';

h2 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Please fill in the height',...
'Style','text',...
'Position',[29.8571428571429 27.0625 48.4285714285714 3.1875],...
'Children',[],...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text2',...
'FontSize',20);

appdata = [];
appdata.lastValidTag = 'list_cxd';

h3 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String',{  'Listbox' },...
'Style','listbox',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[49.8571428571429 4.8125 62 21.125],...
'Callback',@(hObject,eventdata)Inter_field_height('list_cxd_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Inter_field_height('list_cxd_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','list_cxd');

appdata = [];
appdata.lastValidTag = 'expression_edt';

h4 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','0',...
'Style','edit',...
'Position',[8.28571428571428 17.5625 27.1428571428571 2.125],...
'Callback',@(hObject,eventdata)Inter_field_height('expression_edt_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ForegroundColor',get(0,'defaultuicontrolForegroundColor'),...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Inter_field_height('expression_edt_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','expression_edt');

appdata = [];
appdata.lastValidTag = 'text3';

h5 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String',{  'List of heigths'; '(Use Valid matlab expression)' },...
'Style','text',...
'Position',[4.57142857142857 20.6875 35.7142857142857 2.25],...
'Children',[],...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text3');

appdata = [];
appdata.lastValidTag = 'text_verif';

h6 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'HorizontalAlignment','left',...
'String',{  'Static Text' },...
'Style','text',...
'Position',[2.57142857142857 10.125 40.1428571428571 5.1875],...
'BackgroundColor',[0.94 1 0.94],...
'Children',[],...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','text_verif');

appdata = [];
appdata.lastValidTag = 'pushbutton1';

h7 = uicontrol(...
'Parent',h1,...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','characters',...
'String','Update and close',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[81.4285714285714 0.9375 25.5714285714286 2.625],...
'Callback',@(hObject,eventdata)Inter_field_height('pushbutton1_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'KeyPressFcn',blanks(0),...
'ParentMode','manual',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
'DeleteFcn',blanks(0),...
'ButtonDownFcn',blanks(0),...
'Tag','pushbutton1');


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
    % INTER_FIELD_HEIGHT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % INTER_FIELD_HEIGHT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % INTER_FIELD_HEIGHT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % INTER_FIELD_HEIGHT(...)
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


