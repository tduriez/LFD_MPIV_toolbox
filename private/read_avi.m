function [images,image_size,nb_frames,number_of_images]=read_avi(file_name,indices,verb,mode,msg,avg)

  if nargin<3 
        verb=1; % set default
    end
    
    if nargin<4
        mode='normal';
    else
        if isempty(mode)
            mode='normal';
        end
    end
    
    if nargin<5
        msg='loading';
    end
    
    %% Some info recollection and display.
    
      Movie=VideoReader(file_name);
    number_of_images=round(Movie.FrameRate*Movie.Duration);
    nb_frames=1;
    image_size=[Movie.Width Movie.Height];
    
    
    
    if nargin<2
        indices=1:number_of_images;
    else
        if isempty(indices)
            indices=1:number_of_images;
        end
    end
    
    %% initialize buffer and result matrix
    if strcmp(mode,'normal')
        images=uint16(zeros(image_size(2),image_size(1)*nb_frames,length(indices)));
    else
        images=uint16(zeros(image_size(2),image_size(1)*nb_frames,2));
    end
    
    if strcmp(mode,'std') && nargin <6
        avg=zeros(image_size(2),image_size(1)*nb_frames);
    end
    
    if strcmp(mode,'std') && nargin ==6
        std_dev=zeros(image_size(2),image_size(1)*nb_frames);
    end
    last_image=indices(end);
    
    
    
    %% main loop (default mode)   
    if verb==-1;h=waitbar(0,msg);end
     the_verb=verb;
     for i=1:last_image
         if verb==-1;
            h=waitbar(i/last_image,h);
        else
            if intersect(indices,i)
                verb=the_verb;
            else
                verb=0;
            end
         end
         A=Movie.readFrame;
         if strcmp(mode,'normal') || i==1
            images(:,:,i)=A;
         end
         
         if strcmp(mode,'std') && nargin<6
             avg=avg+double(A);
         elseif strcmp(mode,'std') && nargin==6
             std_dev=std_dev+abs(double(A)-avg);
         end
         
         if verb>1;fprintf('obtained image %d\n',i);end
     end
     
     if strcmp(mode,'normal') 
        images=images(:,:,1:min(number_of_images,length(indices)));
        if verb>0;fprintf('%d images contained\n',number_of_images);end
     end
    
     if strcmp(mode,'std')
        images=double(images);
     end
     
    if strcmp(mode,'std') && nargin<6
        images(:,:,2)=(avg/number_of_images);
    elseif strcmp(mode,'std') && nargin==6
        images(:,:,2)=(std_dev/number_of_images)./avg;
    end
    
     %% Second call for std
    if strcmp(mode,'std') && nargin<6
        images=read_avi(file_name,indices,verb,'std','Computing Standart Deviation',images(:,:,2));
    end
     if verb==-1;close(h);end
     end
         
         
         
     
    
    
    
    
    
    
    
    
    