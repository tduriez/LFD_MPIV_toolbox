function varargout = Please_Update(varargin)
% PLEASE_UPDATE MATLAB code for Please_Update.fig
%      PLEASE_UPDATE, by itself, creates a new PLEASE_UPDATE or raises the existing
%      singleton*.
%
%      H = PLEASE_UPDATE returns the handle to a new PLEASE_UPDATE or the handle to
%      the existing singleton*.
%
%      PLEASE_UPDATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLEASE_UPDATE.M with the given input arguments.
%
%      PLEASE_UPDATE('Property','Value',...) creates a new PLEASE_UPDATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Please_Update_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Please_Update_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Please_Update

% Last Modified by GUIDE v2.5 29-Mar-2017 11:27:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Please_Update_OpeningFcn, ...
                   'gui_OutputFcn',  @Please_Update_OutputFcn, ...
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


% --- Executes just before Please_Update is made visible.
function Please_Update_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Please_Update (see VARARGIN)

% Choose default command line output for Please_Update
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Please_Update wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Please_Update_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
close(hObject);
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume
