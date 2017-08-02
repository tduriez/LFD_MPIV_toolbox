function [varargout] = LFD_MPIV_Interface(varargin)
%LFD_MPIV_INTERFACE M-file for LFD_MPIV_Interface.fig
%      LFD_MPIV_INTERFACE, by itself, creates a new LFD_MPIV_INTERFACE or raises the existing
%      singleton*.
%
%      H = LFD_MPIV_INTERFACE returns the handle to a new LFD_MPIV_INTERFACE or the handle to
%      the existing singleton*.
%
%      LFD_MPIV_INTERFACE('Property','Value',...) creates a new LFD_MPIV_INTERFACE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to LFD_MPIV_Interface_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LFD_MPIV_INTERFACE('CALLBACK') and LFD_MPIV_INTERFACE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LFD_MPIV_INTERFACE.M with the given input
%      arguments.
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

% Edit the above text to modify the response to help LFD_MPIV_Interface

% Last Modified by GUIDE v2.5 08-May-2017 20:16:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LFD_MPIV_Interface_OpeningFcn, ...
    'gui_OutputFcn',  @LFD_MPIV_Interface_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);

if nargin && ischar(varargin{1})
    if ~isempty(strfind(varargin{1},'Callback')) || ~isempty(strfind(varargin{1},'CreateFcn'))
        gui_State.gui_Callback = str2func(varargin{1});
    end
end


if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LFD_MPIV_Interface is made visible.
function LFD_MPIV_Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for LFD_MPIV_Interface
if numel(varargin)
    if ischar(varargin{1})
        handles.dflt_folder=varargin{1};
    else
        handles.dflt_folder=[];
    end
else
    handles.dflt_folder=[];
end

handles.current_parameters=LFD_MPIV_parameters;
set(handles.version_txt,'String',sprintf('LFD_MPIV Toolbox v%s',handles.current_parameters.release));

%handles.cxd_folder='';
%handles.cxd='';

handles.parameters=[];
handles.current_frame=0;
if numel(varargin)==2
    handles.parameters=varargin{2};
    display_expe(handles);
end


update_import_options(handles);
update_PIV_options(handles);
update_synchro_options(handles);
update_images_options(handles);
update_options(handles);

% Update handles structure
guidata(hObject, handles);
set(hObject,'closeRequestFcn',[])
set(hObject, 'Position', get(0,'Screensize')); % Maximize figure. 
% UIWAIT makes LFD_MPIV_Interface wait for user response (see UIRESUME)
 uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = LFD_MPIV_Interface_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'closeRequestFcn','closereq');
% Get default command line output from handles structure
varargout{1} = handles.parameters;
close(hObject);


% --- Executes on selection change in list_cxd.
function list_cxd_Callback(hObject, eventdata, handles)
% hObject    handle to list_cxd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(hObject,'Value');
idx=idx(1);
display_image(fullfile(handles.cxd_folder,handles.cxd{idx}),handles.current_parameters,...
    handles.axes1,2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));







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


% --- Executes on button press in set_cxd_button.
function set_cxd_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_cxd_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cxd_folder=uigetdir(handles.dflt_folder);
d1=dir(fullfile(handles.cxd_folder,'*.cxd'));
d2=dir(fullfile(handles.cxd_folder,'*.CXD'));
d3=dir(fullfile(handles.cxd_folder,'*.MOV'));
d4=dir(fullfile(handles.cxd_folder,'*.mov'));
d=[d1 d2 d3 d4];
handles.cxd=cell(1,numel(d));
for i=1:numel(d)
    handles.cxd{i}=d(i).name;
end
set(handles.list_cxd,'String',handles.cxd,'Max',numel(d),'Value',1);
idx = get(handles.list_cxd,'Value');
idx=idx(1);
display_image(fullfile(handles.cxd_folder,handles.cxd{idx}),handles.current_parameters,...
    handles.axes1,2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));
guidata(hObject,handles);




% --- Executes on selection change in list_expe.
function list_expe_Callback(hObject, eventdata, handles)
% hObject    handle to list_expe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_expe contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_expe


% --- Executes during object creation, after setting all properties.
function list_expe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_expe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in edt_PIV.
function edt_PIV_Callback(hObject, eventdata, handles)
% hObject    handle to edt_PIV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.current_parameters=Inter_PIV_options(handles.current_parameters);
update_PIV_options(handles);
guidata(hObject,handles);

function update_PIV_options(handles);
text_PIV=handles.current_parameters.display('PIV');
set(handles.text_PIV_options,'String',text_PIV);




% --- Executes on button press in synchro_bttn.
function synchro_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to synchro_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx_selected_cxd=get(handles.list_cxd,'Value');
cxd=get(handles.list_cxd,'String');
% if isempty(handles.current_parameters.ttl_folder);
%     handles.current_parameters.ttl_folder=pwd;
% end
%handles.current_parameters=Inter_synchro(handles.current_parameters,cxd(idx_selected_cxd));
Inter_synchro(handles.current_parameters,cxd(idx_selected_cxd));
update_synchro_options(handles);
guidata(hObject,handles);

function update_synchro_options(handles)
text_PIV=handles.current_parameters.display('synchro');
set(handles.synchro_txt,'String',text_PIV);


% --- Executes on button press in im_setting_bttn.
function im_setting_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to im_setting_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_cxd=get(handles.list_cxd,'Value');
cxd_files=get(handles.list_cxd,'String');
Inter_im_options(handles.current_parameters,fullfile(handles.cxd_folder,cxd_files{selected_cxd(1)}));
update_images_options(handles);
guidata(hObject,handles);
idx = get(handles.list_cxd,'Value');
idx=idx(1);
display_image(fullfile(handles.cxd_folder,handles.cxd{idx}),handles.current_parameters,...
    handles.axes1,2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));

function update_images_options(handles);
text_PIV=handles.current_parameters.display('frames');
set(handles.im_list,'String',text_PIV);

% --- Executes on selection change in im_list.
function im_list_Callback(hObject, eventdata, handles)
% hObject    handle to im_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns im_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from im_list


% --- Executes during object creation, after setting all properties.
function im_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to im_list (see GCBO)
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
handles.height=Inter_field_height(handles.cxd,get(handles.list_cxd,'Value'));
handles.parameters=add_expe_structure(handles);
display_expe(handles);
guidata(hObject,handles);



function parameters=add_expe_structure(handles)
%get number of cxd files
idx=get(handles.list_cxd,'Value');
new_parameters=repmat(LFD_MPIV_parameters,[1 numel(idx)]);

if numel(idx)>1
    for i=2:numel(idx)
        new_parameters(i)=LFD_MPIV_parameters;
    end
end

for i=1:numel(idx)
    new_parameters(i).update(handles.current_parameters);
    new_parameters(i).height=handles.height(i);
    new_parameters(i).cxd_file=fullfile(handles.cxd_folder,handles.cxd{idx(i)});
end

parameters=[handles.parameters new_parameters];

function display_expe(handles)
expe_list=cell(1,numel(handles.parameters));
for i=1:numel(handles.parameters);
    [~,cxd,~]=fileparts(handles.parameters(i).cxd_file);
    expe_list{i}=sprintf('%d: %s,',i,handles.parameters(i).case_name);
    expe_list{i}=sprintf('%s %s',expe_list{i},cxd);
    expe_list{i}=sprintf('%s y=%.2f,',expe_list{i},handles.parameters(i).height);
    expe_list{i}=sprintf('%s IntWin:%s, %d%% ',expe_list{i},sprintf('%d ',handles.parameters(i).IntWin),handles.parameters(i).overlap(1));
%     if isempty(handles.parameters(i).ttl_folder)
%         expe_list{i}=sprintf('%s Acq. Feq.: %.2f',expe_list{i},handles.parameters(i).acq_freq);
%     else
%         expe_list{i}=sprintf('%s Acq. Sync. TTL',expe_list{i});
%     end
        expe_list{i}=sprintf('%s full info: %s',expe_list{i},handles.parameters(i).display('list'));
    
    
end

idx=get(handles.list_expe,'Value');
idx(idx>numel(handles.parameters))=numel(handles.parameters);
idx(idx<1)=1;
idx=unique(idx);
set(handles.list_expe,'String',expe_list,'Value',idx,'Max',numel(expe_list));


% --- Executes on button press in remove_bttn.
function remove_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.list_expe,'Value');
handles.parameters=handles.parameters(setxor(idx,1:numel(handles.parameters)));

display_expe(handles);
guidata(hObject,handles);


% --- Executes on button press in close_bttn.
function close_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to close_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;


% --- Executes on button press in export_bttn.
function export_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to export_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to im_setting_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Inter_export(handles.current_parameters);
update_options(handles);
guidata(hObject,handles);

function update_options(handles);
text_PIV=handles.current_parameters.display('export');
set(handles.export_list,'String',text_PIV);


% --- Executes on selection change in export_list.
function export_list_Callback(hObject, eventdata, handles)
% hObject    handle to export_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns export_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from export_list


% --- Executes during object creation, after setting all properties.
function export_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to export_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PIV_bttn.
function PIV_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to PIV_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LFD_MPIV_CommandLine(handles.parameters);        
                
        


% --- Executes on button press in import_bttn.
function import_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to import_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_cxd=get(handles.list_cxd,'Value');
cxd_files=get(handles.list_cxd,'String');
Inter_import(handles.current_parameters,fullfile(handles.cxd_folder,cxd_files{selected_cxd(1)}));
update_import_options(handles);
guidata(hObject,handles);

function update_import_options(handles);
text_PIV=handles.current_parameters.display('import');
idx=strfind(text_PIV,char(10));
text_PIV=text_PIV(idx+1:end);
set(handles.import_list,'String',text_PIV)


% --- Executes on selection change in import_list.
function import_list_Callback(hObject, eventdata, handles)
% hObject    handle to import_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns import_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from import_list


% --- Executes during object creation, after setting all properties.
function import_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to import_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showroi_box.
function showroi_box_Callback(hObject, eventdata, handles)
% hObject    handle to showroi_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.list_cxd,'Value');
idx=idx(1);
display_image(fullfile(handles.cxd_folder,handles.cxd{idx}),handles.current_parameters,...
    handles.axes1,2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(hObject,'Value'));

% Hint: get(hObject,'Value') returns toggle state of showroi_box


% --- Executes on button press in show_mask_box.
function show_mask_box_Callback(hObject, eventdata, handles)
% hObject    handle to show_mask_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.list_cxd,'Value');
idx=idx(1);
display_image(fullfile(handles.cxd_folder,handles.cxd{idx}),handles.current_parameters,...
    handles.axes1,2*handles.current_frame+4*get(hObject,'Value')+8*get(handles.showroi_box,'Value'));
% Hint: get(hObject,'Value') returns toggle state of show_mask_box


% --- Executes on button press in change_frame_bttn.
function change_frame_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to change_frame_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.current_frame==0
    handles.current_frame=1;
    set(handles.current_frame_txt,'String','B');
else
     handles.current_frame=0;
     set(handles.current_frame_txt,'String','A');
end
    
idx = get(handles.list_cxd,'Value');
idx=idx(1);
display_image(fullfile(handles.cxd_folder,handles.cxd{idx}),handles.current_parameters,...
    handles.axes1,2*handles.current_frame+4*get(handles.show_mask_box,'Value')+8*get(handles.showroi_box,'Value'));
guidata(hObject,handles);


