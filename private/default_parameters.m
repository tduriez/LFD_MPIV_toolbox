function [allowed_args,default_args,allowed_types]=default_parameters(indices);
    i=1;
    
    %% File options
    args(:,i)={'cxd_file','','char'};i=i+1;
    args(:,i)={'ttl_folder','','char'};i=i+1;
    
    %% Image import options
    args(:,i)={'im_step',1,'numeric'};i=i+1;
    args(:,i)={'im_mode','AB','char'};i=i+1;
    args(:,i)={'source_frames',2,'numeric'};i=i+1;
    
    %% Image display options
    args(:,i)={'roi',[],'numeric'};i=i+1;
    args(:,i)={'dire',2,'numeric'};i=i+1;
    args(:,i)={'flip_hor',0,'numeric'};i=i+1;
    args(:,i)={'flip_ver',0,'numeric'};i=i+1;
    
    %% PIV options
    args(:,i)={'IntWin',[64 32 16],'numeric'};i=i+1;
    args(:,i)={'overlap',50,'numeric'};i=i+1;
    args(:,i)={'cumulcross',1,'numeric'};i=i+1;
    args(:,i)={'deltat',1,'numeric'};i=i+1;
    args(:,i)={'scale',1,'numeric'};i=i+1;
    args(:,i)={'SubPixMode',1,'numeric'};i=i+1;
    args(:,i)={'ImDeform','linear','char'};i=i+1;
    
    %% Synchronization options
    args(:,i)={'acq_freq',1,'numeric'};i=i+1;
    args(:,i)={'act_freq',1,'numeric'};i=i+1;
    args(:,i)={'nb_phases',1,'numeric'};i=i+1;
     
    %% Tomography option
    args(:,i)={'case_name',sprintf('%s_default',...
        datestr(now,'yyyymmdd-HHMMSS')),'char'};i=i+1;
    args(:,i)={'height',0,'numeric'};i=i+1;
    
    %% Global options    
    args(:,i)={'Verbose',1,'numeric'};i=i+1;
    
    if nargin<1;
        indices=1:size(args,2);
    else
        if isempty(indices)
            indices=1:size(args,2);
        end
    end
    
    
    allowed_args=args(1,indices);
    default_args=args(2,indices);
    allowed_types=args(3,indices);
end
    
    
    
 