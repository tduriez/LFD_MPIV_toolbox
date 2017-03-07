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

% Edit the above text to modify the response to help Inter_field_height

% Last Modified by GUIDE v2.5 08-Feb-2017 14:55:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inter_field_height_OpeningFcn, ...
                   'gui_OutputFcn',  @Inter_field_height_OutputFcn, ...
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
          textlist{i}=sprintf('z=%+06.2f (mum): %s',height(i),cxd{i});
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
