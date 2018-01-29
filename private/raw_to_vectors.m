function data=raw_to_vectors(cxd_info,varargin)
%RAW_TO_VECTORS    computes PIV fields from cxd files.
%
%   DATA=RAW_TO_VECTORS(CXD_FILE) computes cumulative correlation
%   of all image pairs included in the CXD file.
%
%   DATA=RAW_TO_VECTORS(CXD_FILE,PARAMETER,VALUE,...) allows the
%   introduction of the following parameters:
%
%   Parameter       Value                    Description
%  -----------------------------------------------------------------------
%  'IntWin'     Interger Array    successive sizes of the square
%                 [w1,w2,w3]      interrogation windows.      [64 32 16 16]
%
%  'Overlap'      Integer         Percentage of overlaping of the inter-
%                                 rogation windows. Due to a bug, only 50%
%                                 is available now.                    [50]
%
%  'CumulCross'   0 or 1          Use cumulative correlation.           [1]
%
%  'SubPixMode'   1 or 2          Type of algorithm to use for subpixel
%                                 determination. Only 1 is working anyway.
%                                                                       [1]
%
%  'ImDeform'    'linear'         Algorithm for the image deformation.
%                'cubic'          'linear' and 'cubic' are fine. 'spline'
%                'spline'         is slow.
%                                                                ['linear']
%
%  'Verbose'       0 1 or 2       How much will the program talk to you.
%                                 Default is 1, 0 is mute and 2 for debug.
%                                                                       [1]
%
%  'Rotation'    90,180 or 270    Allows rotation of the image before
%                                 processing by specified number of degrees.
%                                                                       [0]
%
%  'Flip_Hor'      0 or 1         Flips the image horizontally          [0]
%
%  'Flip_Ver'      0 or 1         Flips the image vertically            [0]
%
%  'ROI'     [hmin hmax vmin vmax]  Sets the Region Of Interest in pixels
%                                                              [full image]
%
%
%
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

%% Start program
t1=now;

% If the experiment is GUI generated, a parameters object is created. This
% object is also the output of the GUI, so it can be reused. If only the CXD
% file location is given, default parameters apply. Any parameter entered manually
% will overwrite default or LFD_MPIV object given parameter.

FlagImages=0;
if isa(cxd_info,'char')
    parameters=LFD_MPIV_parameters; %load default_parameters
    parameters.cxd_file=cxd_info;
    parameters=parameters.update(varargin{:});    %implement options
elseif isa(cxd_info,'LFD_MPIV_parameters');
    
    if any(strcmpi(varargin,'images'))
        FlagImages=1;
        idx=find(strcmpi(varargin,'images'));
        all_images=varargin{idx+1};
        varargin=varargin(setdiff(1:length(varargin),[idx idx+1]));
    end 
    
    parameters=cxd_info.update(varargin{:});  %implement options
else
    error('I don''t know what to do with a parameter of class %s.',class(cxd_info));
end





%% Start PIV
if ~FlagImages
if parameters.Verbose
fprintf('case: %s, z= %d (mum)\n',parameters.case_name,parameters.height);
end
[~,pattern,~]=fileparts(parameters.cxd_file);
if parameters.Verbose;fprintf('Source cxd file: %s\n',pattern);end
if parameters.Verbose>1;fprintf('Importing images:                     ');end
tic
read_verbose=0;
if parameters.Verbose>2
    read_verbose=min(2,max(1,parameters.Verbose-2));
end
[all_images,~,nb_frames]=LFD_MPIV_read_images(parameters.cxd_file,parameters.image_indices,read_verbose);
if nb_frames~=parameters.source_frames
    parameters.source_frames=nb_frames;
end
if parameters.Verbose>1;fprintf('ok (%.3f s)\n',toc);end
if parameters.Verbose>1;fprintf('Preparing frames:                     ');tic;end
all_images=prepare_frames(all_images,parameters);
if parameters.Verbose>1;fprintf('ok (%.3f s)\n',toc);end
end
if parameters.cumulcross
if ~isempty(parameters.ttl_folder)
    if strcmp(parameters.ttl_folder,'cxd')
        if parameters.Verbose>1;fprintf('Using timestamps from cxd.');end
        T_acquired=get_times(parameters.cxd_file);
    else
        d=dir(parameters.ttl_folder);
        pattern=lower(pattern);
        pattern=strip_string(pattern);
        simi=zeros(1,numel(d));
        for i=1:length(d);
            name=strip_string(d(i).name);
            simi(i)=stringsimilarity(pattern,name);
        end
        [~,k]=max(simi);
        if parameters.Verbose>1;fprintf('Using synchronisation file: %s\n',d(k).name);end
        load(fullfile(parameters.ttl_folder,d(k).name),'tframe');
        T_acquired=tframe;
    end
else
    T_acquired=(0:numel(all_images)-1)/parameters.acq_freq;
end

f_act=parameters.act_freq;
nb_phases=parameters.nb_phases;

if f_act==0;
    nb_phases=1;
    phase=T_acquired*0+1;
else
    phase=floor(mod(T_acquired+1/(2*f_act),1/f_act)*f_act*nb_phases)+1;
end

else
   phase=1:numel(all_images);
   nb_phases=phase(end);
end

phase=phase(1:numel(all_images));

for pha=1:nb_phases
    images=all_images(phase==pha);
    if parameters.cumulcross
        if nb_phases~=1
            if parameters.Verbose;fprintf('Phase number %d:',pha)
            fprintf(' %d image pairs\n',numel(images));end
        else
            fprintf('Cumulative cross-correlation of %d image pairs\n',numel(images))
        end
    else
        if parameters.Verbose;fprintf('Image number %d\n',pha);end
    end
        

    if numel(images)>0
    data_phase=PIV(images,parameters);

    data.u(:,:,pha)=data_phase.u*parameters.scale/parameters.deltat;
    data.v(:,:,pha)=data_phase.v*parameters.scale/parameters.deltat;
    data.s2n(:,:,pha)=data_phase.s2n;
    if ~isfield(data,'x');
        data.x=data_phase.x*parameters.scale;
        data.y=data_phase.y*parameters.scale;
        data.u=repmat(data_phase.u*parameters.scale/parameters.deltat,[1 1 nb_phases]);
        data.v=repmat(data_phase.v*parameters.scale/parameters.deltat,[1 1 nb_phases]);
        data.s2n=repmat(data_phase.s2n,[1 1 nb_phases]);
    end
    end
end

%% Scaling

data.x=data.x*parameters.scale;
data.y=data.y*parameters.scale;
data.u=data.u*parameters.scale/parameters.deltat;
data.v=data.v*parameters.scale/parameters.deltat;

%% Saving used parameters
data.parameters=parameters;
end



function new_string=strip_string(my_string)
new_string=lower(my_string);
new_string(new_string=='-')=[];
new_string(new_string=='_')=[];
end

function simi=stringsimilarity(string1,string2)
if length(string1)>length(string2);
    string3=string2;string2=string1;string1=string3;
end
simi=0;
for i=1:(length(string2)-length(string1)+1)
    simi=max(simi,sum(string1==string2(i:length(string1)-1+i)));
end
end
