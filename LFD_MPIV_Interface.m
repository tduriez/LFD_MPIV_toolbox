function varargout = LFD_MPIV_Interface(varargin)
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

% Last Modified by GUIDE v2.5 10-Feb-2017 17:09:10

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


%handles.cxd_folder='';
%handles.cxd='';

handles.parameters=[];

if numel(varargin)==2
    handles.parameters=varargin{2};
    display_expe(handles);
end



update_PIV_options(handles);
update_synchro_options(handles);
update_images_options(handles);
update_export_options(handles);

% Update handles structure
guidata(hObject, handles);
set(hObject,'closeRequestFcn',[])

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
varargout{1} = handles.expe;
close(hObject);


% --- Executes on selection change in list_cxd.
function list_cxd_Callback(hObject, eventdata, handles)
% hObject    handle to list_cxd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(hObject,'Value');
idx=idx(1);
display_image(handles.axes1,fullfile(handles.cxd_folder,handles.cxd{idx}),handles);






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
d=[d1 d2];
handles.cxd=cell(1,numel(d));
for i=1:numel(d)
    handles.cxd{i}=d(i).name;
end
set(handles.list_cxd,'String',handles.cxd,'Max',numel(d));
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
if handles.current_parameters.cumulcross==1
    PIV_mode='Cumulative';
else
    PIV_mode='Single';
end
text_PIV=sprintf('%s cross-correlation\n%d passes\n',...
    PIV_mode,numel(handles.current_parameters.IntWin));
for i=1:numel(handles.current_parameters.IntWin)
    text_PIV=sprintf('%s %dx%d %d%% overlap\n',text_PIV,handles.current_parameters.IntWin(i),handles.current_parameters.IntWin(i),handles.current_parameters.overlap(i));
end

set(handles.text_PIV_options,'String',text_PIV);




% --- Executes on button press in synchro_bttn.
function synchro_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to synchro_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx_selected_cxd=get(handles.list_cxd,'Value');
cxd=get(handles.list_cxd,'String');
if isempty(handles.current_parameters.ttl_folder);
    handles.current_parameters.ttl_folder=pwd;
end
%handles.current_parameters=Inter_synchro(handles.current_parameters,cxd(idx_selected_cxd));
Inter_synchro(handles.current_parameters,cxd(idx_selected_cxd));
update_synchro_options(handles);
guidata(hObject,handles);

function update_synchro_options(handles);
if ~isempty(handles.current_parameters.ttl_folder)
    synchro_mode='TTL';
else
    synchro_mode='Frequency';
end
text_PIV=sprintf('%s synchronisation\n%d passes\n',synchro_mode);
if strcmp(synchro_mode,'TTL')
text_PIV=sprintf('%sFolder: %s\n',text_PIV,handles.current_parameters.ttl_folder);
else
text_PIV=sprintf('%sAcq. Freq: %5.2f Hz\n',text_PIV,handles.current_parameters.acq_freq);
end
text_PIV=sprintf('%sAct. Freq: %5.2f Hz\n',text_PIV,handles.current_parameters.act_freq);
text_PIV=sprintf('%sNb of phases: %d',text_PIV,handles.current_parameters.nb_phases);
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

function update_images_options(handles);
text_PIV=[];
text_PIV=sprintf('%sScale (mum/pixel): %f\n',text_PIV,handles.current_parameters.scale);
text_PIV=sprintf('%sDelta t (mus): %f\n',text_PIV,handles.current_parameters.deltat);
if ~isempty(handles.current_parameters.roi)
    text_PIV=sprintf('%sROI: %s \n',text_PIV,sprintf('%d ',handles.current_parameters.roi));
else
    text_PIV=sprintf('%sROI: %s \n',text_PIV,'full frame');
end

switch handles.current_parameters.flip_hor*2^0 + handles.current_parameters.flip_ver*2^1
    case 0
        the_flip='none';
    case 1
        the_flip='horizontal';
    case 2
        the_flip='vertical';
    case 3
        the_flip='horizontal and vertical';
end

text_PIV=sprintf('%sFlip: %s \n',text_PIV,the_flip);
text_PIV=sprintf('%sRotation: %d%c  \n',text_PIV,handles.current_parameters.rotation*90,char(176));

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
handles.expe=add_expe_structure(handles.expe,handles);
display_expe(handles);
guidata(hObject,handles);



function expe=add_expe_structure(old_expe,handles)
%get number of cxd files
idx=get(handles.list_cxd,'Value');
expe=repmat(struct,[1 numel(idx)]);

%create structure
fields_to_include={'IntWin','overlap','cumulcross','ttl_folder','acq_freq',...
    'act_freq','nb_phases','roi','deltat','scale','dire','flip_hor',...
    'flip_ver','rotation','SubPixMode','ImDeform','Verbose'};
for i=1:numel(idx)
    if ~isempty(handles.the_date)
        expe(i).case_name=sprintf('%s-%s',handles.the_date,handles.case_name);
    else
        expe(i).case_name=handles.case_name;
    end
    for j=1:numel(fields_to_include);
        expe(i).(fields_to_include{j})=handles.(fields_to_include{j});
    end
    expe(i).height=handles.height(i);
    expe(i).cxd_file=fullfile(handles.cxd_folder,handles.cxd{idx(i)});
end
expe=[old_expe expe];

function display_expe(handles)
expe_list=cell(1,numel(handles.expe));
for i=1:numel(handles.expe);
    [~,cxd,~]=fileparts(handles.expe(i).cxd_file);
    expe_list{i}=sprintf('%d: %s,',i,cxd);
    expe_list{i}=sprintf('%s %s',expe_list{i},handles.expe(i).case_name);
    expe_list{i}=sprintf('%s y=%.2f',expe_list{i},handles.expe(i).height);
    expe_list{i}=sprintf('%s (IntWin:%s, %d%% ',expe_list{i},sprintf('%d ',handles.expe(i).IntWin),handles.expe(i).overlap(1));
    if isempty(handles.expe(i).ttl_folder)
        expe_list{i}=sprintf('%s Acq. Feq.: %.2f',expe_list{i},handles.expe(i).acq_freq);
    else
        expe_list{i}=sprintf('%s Acq. Sync. TTL',expe_list{i});
    end
        
    
    
end

idx=get(handles.list_expe,'Value');
idx(idx>numel(handles.expe))=numel(handles.expe);
idx(idx<1)=1;
idx=unique(idx);
set(handles.list_expe,'String',expe_list,'Value',idx,'Max',numel(expe_list));


% --- Executes on button press in remove_bttn.
function remove_bttn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_bttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.list_expe,'Value');
handles.expe=handles.expe(setxor(idx,1:numel(handles.expe)));

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
Inter_export(handles.parameters);
update_export_options(handles);
guidata(hObject,handles);

function update_export_options(handles);
text_PIV=sprintf('Folder: %s\n',handles.current_parameters.export_folder);
text_PIV=sprintf('%sCase name: %s\n',text_PIV,handles.current_parameters.case_name);
text_PIV=sprintf('%sDate: %s\n',text_PIV,handles.current_parameters.the_date);
text_PIV=sprintf('%sFilename: %s\n',text_PIV,handles.current_parameters.export_filename);

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
expe=handles.expe;
if ~isempty(expe)
    case_name_collection={};
    for i=1:length(expe);
        if ~any(strcmp(case_name_collection,expe(i).case_name))
        case_name_collection{numel(case_name_collection)+1}=expe(i).case_name;        
        end
    end
    
    for i_case=1:length(case_name_collection)
        this_expe_idx=zeros(1,length(expe));
        this_z=zeros(1,length(expe));
        for i=1:length(expe);
            if strcmp(case_name_collection{i_case},expe(i).case_name)
                this_expe_idx(i)=1;
                this_z(i)=expe(i).height;
            end
        end
        this_case_expe=expe(this_expe_idx>0);
        [this_z,sort_idx]=sort(this_z(this_expe_idx>0));
        this_case_expe=this_case_expe(sort_idx);
        
        for i_height = 1:numel(this_z)
            setappdata(0,'LFD_MPIV_gui',gcf);
           
            data=LFD_MPIV_cxd_to_vectors(this_case_expe(i_height));
            if i_height==1
                data_3D_phase.x=repmat(data.x,[1 1 length(this_z)]);
                data_3D_phase.y=repmat(data.y,[1 1 length(this_z)]);
                data_3D_phase.z=repmat(permute(this_z,[1 3 2]),[size(data_3D_phase.x,1) size(data_3D_phase.x,2)]);
                data_3D_phase.u=repmat(data_3D_phase.y*0,[1 1 1 size(data.u,3)]);
                data_3D_phase.v=repmat(data_3D_phase.y*0,[1 1 1 size(data.u,3)]);
                data_3D_phase.w=repmat(data_3D_phase.y*0,[1 1 1 size(data.u,3)]);
            end
            data_3D_phase.u(:,:,i_height,:)=permute(data.u,[1 2 4 3]);
            data_3D_phase.v(:,:,i_height,:)=permute(data.v,[1 2 4 3]);
        end
        
        save(sprintf('%s.mat',case_name_collection{i_case}),'data_3D_phase');
        clear data_3D_phase
        
        
    end
        
                
        
    
end




    
