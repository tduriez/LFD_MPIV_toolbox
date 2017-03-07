function  LFD_MPIV_CommandLine(the_input,varargin)

%% three cases for THE_INPUT: structure, structure+options, file+options

% Loading default parameters from private/default_parameters.m   
[allowed_args,default,allowed_types]=default_parameters; 

if ischar(the_input) % if THE_INPUT is a CXD file route
    expe=parameters_parser(varargin,allowed_args,allowed_types,default,1);
    expe.cxd_file=the_input;
elseif isstruct(the_input) % THE_INPUT is an array of structures
    for i=1:numel(the_input)
        % THE_INPUT is used as default so it can be overridden by specified
        % parameters in varargin
        expe(i)=parameters_parser(varargin,allowed_args,allowed_types,the_input(i),2);
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
                data_3D_phase.x=repmat(data.x,[1 1 length(this_z)]);
                data_3D_phase.y=repmat(data.y,[1 1 length(this_z)]);
                data_3D_phase.z=repmat(permute(this_z,[1 3 2]),...
                    [size(data_3D_phase.x,1) size(data_3D_phase.x,2)]);
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






end

