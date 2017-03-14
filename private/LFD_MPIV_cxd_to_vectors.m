function data=LFD_MPIV_cxd_to_vectors(cxd_info,varargin)
%LFD_MPIV_CXD_TO_VECTOR    computes PIV fields from cxd files.
%
%   DATA=LFD_MPIV_CXD_TO_VECTOR(CXD_FILE) computes cumulative correlation
%   of all image pairs included in the CXD file.
%
%   DATA=LFD_MPIV_CXD_TO_VECTOR(CXD_FILE,PARAMETER,VALUE,...) allows the
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
%   See also LFD_MPIV_READ_CXD, LFD_MPIV_PIV, LFD_MPIV_CUT_IMAGES, LFD_MPIV_REMOVE_BACKGROUND
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

% If the experiment is GUI generated, an experiment object is created. This
% object is also the output of the GUI, so it can be reused. If only the CXD
% file location is given, default parameters apply. Any parameter entered manually
% will overwrite default or LFD_MPIV object given parameter.

if isa(cxd_info,'char')
    expe=LFD_MPIV_parameters; %load default_parameters
    expe.cxd_file=cxd_info;
    expe=expe.update(varargin{:});    %implement options
elseif isa(cxd_info,'LFD_MPIV_parameters');
    expe=cxd_info.update(varargin{:});  %implement options
else
    error('I don''t know what to do with a parameter of class %s.',class(cxd_info));
end





%% Start PIV
fprintf('case: %s, z= %d (mum)\n',expe.case_name,expe.height);
[~,pattern,~]=fileparts(expe.cxd_file);
fprintf('Source cxd file: %s\n',pattern);
fprintf('Importing images:                     ');tic
all_images=LFD_MPIV_read_cxd(expe.cxd_file,[],0);
fprintf('ok (%.3f s)\n',toc);
fprintf('Removing background:                  ');tic
all_images=LFD_MPIV_remove_background(all_images);
fprintf('ok (%.3f s)\n',toc);
fprintf('Cutting images:                       ');tic
all_images=LFD_MPIV_cut_images(all_images,expe);
fprintf('ok (%.3f s)\n',toc);
if expe.cumulcross
if ~isempty(expe.ttl_folder)
    d=dir(expe.ttl_folder);

    pattern=lower(pattern);
    pattern=strip_string(pattern);
    simi=zeros(1,numel(d));
    for i=1:length(d);
        name=strip_string(d(i).name);
        simi(i)=stringsimilarity(pattern,name);
    end
    [~,k]=max(simi);
    fprintf('Using synchronisation file: %s\n',d(k).name);
    load(fullfile(expe.ttl_folder,d(k).name),'tframe');
    T_acquired=tframe;
else
    T_acquired=(0:numel(all_images)-1)/expe.acq_freq;
end

f_act=expe.act_freq;
nb_phases=expe.nb_phases;

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


for pha=1:nb_phases
    if expe.cumulcross
    fprintf('Phase number %d:',pha)
    images=all_images(phase==pha);
    fprintf(' %d image pairs\n',numel(images))
    else
        fprintf('Image number %d\n',pha)
    end
        

    if numel(images)>0
    data_phase=LFD_MPIV_PIV(images,expe);

    data.u(:,:,pha)=data_phase.u*expe.scale/expe.deltat;
    data.v(:,:,pha)=data_phase.v*expe.scale/expe.deltat;
    if ~isfield(data,'x');
        data.x=data_phase.x*expe.scale;
        data.y=data_phase.y*expe.scale;
        data.u=repmat(data_phase.u*expe.scale/expe.deltat,[1 1 nb_phases]);
        data.v=repmat(data_phase.v*expe.scale/expe.deltat,[1 1 nb_phases]);
    end
    end
end

%% Scaling

data.x=data.x*expe.scale;
data.y=data.y*expe.scale;
data.u=data.u*expe.scale/expe.deltat;
data.v=data.v*expe.scale/expe.deltat;

%% Saving used parameters
data.parameters=expe;
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
