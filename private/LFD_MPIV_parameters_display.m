function output_text=LFD_MPIV_parameters_display(obj,mode,name)

listing=0;
if strcmp(mode,'list')
    mode='all';
    listing=1;
end

output_text='';

if any(strcmp(mode,{'all','short'})) && listing==0
    the_title=sprintf('* LFD MPIV Experiment v%s *',obj.release);
    output_text=sprintf('%s\n   %s\n',output_text,repmat('*',[1 length(the_title)]));
    output_text=sprintf('%s   %s\n',output_text,the_title);
    output_text=sprintf('%s   %s\n',output_text,repmat('*',[1 length(the_title)]));
end
%% Import
if any(strcmp(mode,{'all'})) && listing==0
    output_text=sprintf('%s * --- Import --- *\n',output_text);
end


if any(strcmp(mode,{'all','short','import'}))
    if ~isempty(obj.cxd_file)
        output_text=sprintf('%s   File: %s\n',output_text,obj.cxd_file);
    else
        output_text=sprintf('%s   No input file provided\n',output_text);
    end
end

if any(strcmp(mode,{'all','import'}))
    image_text2='images';
    if isempty(obj.image_indices)
        index_text='all';
    else
        index_text=num2str(length(obj.image_indices));
        if length(obj.image_indices)==1
            image_text2='image';
        end
        
    end
    
    if obj.frame_skip==1
        image_text='image';
    else
        image_text='images';
    end
    
    cut_info='';
    if obj.source_frames==2
        if obj.dire==2
            cut_info=' (vertical cut)';
        elseif obj.dire==1
            cut_info=' (horizontal cut)';
        end
    end
    
    
    
    
    output_text=sprintf('%s   %d frames%s\n   mode %s\n   skip %d %s\n   use %s %s\n',...
        output_text,obj.source_frames,cut_info,obj.frame_mode,obj.frame_skip,image_text,index_text,image_text2);
    output_text=sprintf('%s   Background removal: %s\n',output_text,obj.background);
end
    
%% Frames construction
if any(strcmp(mode,{'all'})) && listing==0
    output_text=sprintf('%s * --- Frames composition --- *\n',output_text);
end
if any(strcmp(mode,{'all','frames'}))
    if isempty(obj.roi)
        output_text=sprintf('%s   Full frame used\n',output_text);
    else
        output_text=sprintf('%s   R.O.I.: [%d %d %d %d]\n',output_text,obj.roi(1),obj.roi(2),obj.roi(3),obj.roi(4));
    end
    
    if obj.flip_hor
        output_text=sprintf('%s   Horizontal flip\n',output_text);
    end
    if obj.flip_ver
        output_text=sprintf('%s   Vertical flip\n',output_text);
    end
    if obj.rotation
        output_text=sprintf('%s   %d degrees rotation\n',output_text,obj.rotation*90);
    end
    if ~isempty(obj.mask)
        if ~all(obj.mask(:)==1)
            output_text=sprintf('%s   Mask used\n',output_text);
        end
    end
end

    %% PIV options
    if any(strcmp(mode,{'all'})) && listing==0
        output_text=sprintf('%s * --- PIV options --- *\n',output_text);
    end
    if any(strcmp(mode,{'all','PIV','short'}))
        IntWin_txt=sprintf('%dx%d, ',sort([obj.IntWin(:);obj.IntWin(:)],'descend'));
        IntWin_txt=IntWin_txt(1:end-2);
        output_text=sprintf('%s   %d passes (%s)\n',output_text,length(obj.IntWin),IntWin_txt);
        if obj.cumulcross
            output_text=sprintf('%s   Cumulative cross-correlation\n',output_text);
        else
            output_text=sprintf('%s   Normal cross-correlation\n',output_text);
        end
    end
    
    if any(strcmp(mode,{'all','PIV'}))
        
        
        if obj.scale==1 && obj.deltat==1
            output_text=sprintf('%s   Nondimensionalized\n',output_text);
        else
            output_text=sprintf('%s   Scale: %.3f (um/pxl), Time step: %.0f (us)\n',output_text,obj.scale,obj.deltat);
        end
            output_text=sprintf('%s   Window deformation: %s\n',output_text,obj.ImDeform);
        
    end
    
    %% Synchronization options
    if any(strcmp(mode,{'all'})) && listing==0
        output_text=sprintf('%s * --- Synchronization options --- *\n',output_text);
    end
        
    if any(strcmp(mode,{'all','synchro','short'}))
        if obj.nb_phases==1
            output_text=sprintf('%s   No phase reconstruction\n',output_text);
        end
    end
    if any(strcmp(mode,{'short'}))
        if obj.nb_phases~=1
            
            if ~isempty(obj.ttl_folder)
                output_text=sprintf('%s   Phase reconstruction (TTL)\n',output_text);
            else
                output_text=sprintf('%s   Phase reconstruction\n',output_text);
            end
        end
    end
    
    
    
    if any(strcmp(mode,{'all','synchro'})) && obj.nb_phases~=1
        if isempty(obj.ttl_folder)
            output_text=sprintf('%s   Acquisition frequency: %5.2f\n',output_text,obj.acq_freq);
        else
            output_text=sprintf('%s   Acquisition TTL source: %s\n',output_text,obj.ttl_folder);
        end
        output_text=sprintf('%s   Actuation frequency: %5.2f\n',output_text,obj.act_freq);
        output_text=sprintf('%s   Number of phases: %d\n',output_text,obj.nb_phases);
        
    end
        
      %% Tomography option
      if any(strcmp(mode,{'all'})) && listing==0
        output_text=sprintf('%s * --- Tomography options --- *\n',output_text);
      end   
      
      if any(strcmp(mode,{'all','tomo'}))
            output_text=sprintf('%s   PIV plane height: %.3f (um)\n',output_text,obj.height);
      end
        
      %% Export option
       if any(strcmp(mode,{'all'})) && listing==0
        output_text=sprintf('%s * --- Export options --- *\n',output_text);
       end   
      
        if any(strcmp(mode,{'all','export','short'}))
            output_text=sprintf('%s   Case name: %s\n',output_text,obj.case_name);
        end
        
        if any(strcmp(mode,{'all','export'}))
            output_text=sprintf('%s   Date: %s\n',output_text,obj.the_date);
            output_text=sprintf('%s   Export folder: %s\n',output_text,obj.export_folder);
        end
        
       
      
      
      if any(strcmp(mode,{'short'}))
          output_text=sprintf('%s\n\nDetails: <a href="matlab:%s.display(''import'')">Import options</a>, ',output_text,name);
          output_text=sprintf('%s<a href="matlab:%s.display(''frames'')">Frames options</a>, ',output_text,name);
          output_text=sprintf('%s<a href="matlab:%s.display(''PIV'')">PIV options</a>,\n',output_text,name);
          output_text=sprintf('%s         <a href="matlab:%s.display(''synchro'')">Synchronization options</a>, ',output_text,name);
          output_text=sprintf('%s<a href="matlab:%s.display(''tomo'')">Tomography options</a>,\n',output_text,name);
          output_text=sprintf('%s         <a href="matlab:%s.display(''export'')">Export options</a>, ',output_text,name);
          output_text=sprintf('%s<a href="matlab:%s.display(''all'')">All options</a>\n',output_text,name); 
      end
      
      if listing
          output_text(output_text==char(10))=',';
          output_text=strrep(output_text,'   ',' ');
          output_text=output_text(1:end-1);
      end
      

    
end







