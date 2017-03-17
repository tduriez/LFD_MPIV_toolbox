function  data_PIV=LFD_MPIV_CommandLine(the_input,varargin)
%LFD_MPIV_CommandLine
%    FIXME: redact help
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

%% three cases for THE_INPUT: structure, structure+options, file+options



if ischar(the_input) % if THE_INPUT is a CXD file route
    expe=LFD_MPIV_parameters;
    expe.cxd_file=the_input;
    expe.update(varargin{:});
elseif isa(the_input,'LFD_MPIV_parameters') % THE_INPUT is an array of LFD_MPIV objects
    for i=1:numel(the_input)
        % THE_INPUT is used as default so it can be overridden by specified
        % parameters in varargin
        expe(i)=expe(i).update(varargin{:});
    end  
end

%% Start of tomography

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
        
         if length(unique(this_z))~=length(this_z);
                error(['At least two experiment have same ''case_name'''...
                    'and ''height''. This would result in overridden '...
                    'data. Please modify it'])
            end
        
        for i_height = 1:numel(this_z)
            setappdata(0,'LFD_MPIV_gui',gcf);
            
            data=LFD_MPIV_cxd_to_vectors(this_case_expe(i_height));
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
        end
        
        
        
        save(sprintf('%s.mat',case_name_collection{i_case}),'data_PIV');
        
        
        
    end
        
                
        
    
end






end

