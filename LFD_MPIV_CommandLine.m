function  data_PIV=LFD_MPIV_CommandLine(the_input,varargin)
%LFD_MPIV_COMMANDLINE computes PIV fields from CXD file(s).
%   
%   DATA=LFD_MPIV_COMMANDLINE(CXD_FILENAME) returns the DATA structure
%   containing the result of the PIV computation using default <a href="matlab:help LFD_MPIV_parameters">parameters</a>
%   for the PIV computations of images included in CXD_FILENAME archive.
%
%   DATA=LFD_MPIV_COMMANDLINE(CXD_FILENAME,'arg1',value1,...) allows the use 
%   of custom parameters. A full list of parameters is available <a href="matlab:help LFD_MPIV_parameters">here</a>.
%
%   DATA=LFD_MPIV_COMMANDLINE(LM_PARAMS) computes PIV according
%   to the array LM_PARAMS of <a href="matlab:help LFD_MPIV_parameters">LFD_MPIV_parameters</a> objects provided. You
%   can generate such an array using <a href="matlab:help LFD_MPIV_Interface">LFD_MPIV_Interface</a>
%
%   By default, single frame time series will be converted in double frame
%   time series (1-2 2-3 3-4 ...) and cumulative cross-correlation will be
%   performed. Three passes (64x64 32x32 and 16x16) are performed.
%
%   Quick option guide:
%
%   Parameter name    | Parameter values
%   ------------------|-----------------
%   IntWin            | [64 32 16]   array of interrogation window size.
%   cumulcross        | 1            switch to 0 to deactive cumulative
%                     |              cross-correlation
%   image_indices     | []           indices of images to include. Empty
%                     |              means all images are used.
%
%   See <a href="matlab:help LFD_MPIV_parameters">here</a> for a full option list and description.
%   
%   See also LFD_MPIV_INTERFACE, LFD_MPIV_READ_CXD
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


    


%% three cases for THE_INPUT: structure, structure+options, file+options
GetFrames=0;
FlagImage=0;
if nargin>1
    if any(strcmpi(varargin,'GetFrames'));
        GetFrames=1;
       
        idx=find(strcmpi(varargin,'GetFrames'));
        varargin=varargin(setdiff(1:length(varargin),idx));

    end
end

if ischar(the_input) % if THE_INPUT is a CXD file route
    parameters=LFD_MPIV_parameters;
    parameters.cxd_file=the_input;
    parameters.update(varargin{:});
    
    if GetFrames
        images=LFD_MPIV_read_images(the_input,parameters.image_indices,0);
        images=prepare_frames(images,parameters);
        data_PIV.images=images;
        data_PIV.parameters=parameters;
        return
    end
    
elseif isa(the_input,'LFD_MPIV_parameters') % THE_INPUT is an array of LFD_MPIV objects
    for i=1:numel(the_input)
        % THE_INPUT is used as default so it can be overridden by specified
        % parameters in varargin
        parameters(i)=the_input(i).copy;
        parameters(i).update(varargin{:});
    end  
elseif isa(the_input,'struct')
    if isfield(the_input,'frameA') && isfield(the_input,'frameB')
        FlagImage=1;
        parameters=LFD_MPIV_parameters;
        parameters.update(varargin{:});
    end
        
end

%% Check if new version is available
%msg=check_last_version(parameters(1));
%if parameters(1).Verbose
%    fprintf('%s',msg)
%end

%% Start of tomography

if ~isempty(parameters)
    case_name_collection={};
    for i=1:length(parameters);
        if ~any(strcmp(case_name_collection,parameters(i).export_filename))
        case_name_collection{numel(case_name_collection)+1}=parameters(i).export_filename;        
        end
    end
    
    for i_case=1:length(case_name_collection)
        this_parameters_idx=zeros(1,length(parameters));
        this_z=zeros(1,length(parameters));
        for i=1:length(parameters);
            if strcmp(case_name_collection{i_case},parameters(i).export_filename)
                this_parameters_idx(i)=1;
                this_z(i)=parameters(i).height;
            end
           
           
        end
        
        
        this_case_parameters=parameters(this_parameters_idx>0);
        [this_z,sort_idx]=sort(this_z(this_parameters_idx>0));
        this_case_parameters=this_case_parameters(sort_idx);
        
         if length(unique(this_z))~=length(this_z);
                error(['At least two parametersriment have same ''case_name'''...
                    'and ''height''. This would result in overridden '...
                    'data. Please modify it'])
            end
        
        for i_height = 1:numel(this_z)
            setappdata(0,'LFD_MPIV_gui',gcf);
            if FlagImage
                data=raw_to_vectors(this_case_parameters(i_height),'images',the_input);
            else
                data=raw_to_vectors(this_case_parameters(i_height));
            end
            if i_height==1
                try
                    clear data_PIV
                catch
                end
                data_PIV.x=repmat(data.x,[1 1 length(this_z)]);
                data_PIV.y=repmat(data.y,[1 1 length(this_z)]);
                data_PIV.z=repmat(permute(this_z,[1 3 2]),...
                    [size(data_PIV.x,1) size(data_PIV.x,2)]);
                data_PIV.u=repmat(data_PIV.y*0,[1 1 1 size(data.u,3)]);
                data_PIV.v=repmat(data_PIV.y*0,[1 1 1 size(data.u,3)]);
                data_PIV.w=repmat(data_PIV.y*0,[1 1 1 size(data.u,3)]);
                data_PIV.s2n=repmat(data_PIV.y*0,[1 1 1 size(data.u,3)]);
            end
            data_PIV.u(:,:,i_height,:)=permute(data.u,[1 2 4 3]);
            data_PIV.v(:,:,i_height,:)=permute(data.v,[1 2 4 3]);
            data_PIV.s2n(:,:,i_height,:)=permute(data.s2n,[1 2 4 3]);
            data_PIV.parameters(i_height)=this_case_parameters(i_height);
        end
        
        
        save_name=fullfile(data_PIV.parameters(1).export_folder,data_PIV.parameters(1).export_filename);
        if ~isempty(save_name)
        save(sprintf('%s.mat',save_name),'data_PIV');
        end
        
        
    end
        
                
        
    
end






end

