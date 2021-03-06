function [shown_image_size,parameters]=display_image(cxd,parameters,my_axes,mode);
    %% M.O.D.E.
    %  | | | |
    %  | | | ---> Show M.O.D.E.    (2^0)
    %  | | -----> Frame A/B switch (2^1)
    %  | -------> Mask switch      (2^2)
    %  ---------> R.O.I. Switch    (2^3)

warning('off','MATLAB:contour:ConstantData');
    if nargin < 2
        parameters=LFD_MPIV_parameters;
    end
    if nargin < 3
        my_axes=gca;
    end
    if nargin < 4
        mode=dec2bin(0,4)-48;
    else
        mode=dec2bin(mode,4)-48;
    end
    
    if mode(4)==1
        fprintf('M.O.D.E:\n')
        fprintf('%d ',mode)
        fprintf('\n')
    end
    
    n_necessary=parameters.frame_skip+1;
    [images,image_size,nb_frames]=LFD_MPIV_read_images(cxd,1:n_necessary,0);
    parameters.source_frames=nb_frames;
    
    roi=parameters.roi;
    if mode(1)==0
        parameters.roi=[1 image_size(1) 1 image_size(2)];
    end
    
    
    
    images=prepare_frames(images,parameters);
    images=images(1);
    parameters.roi=roi;
    
    
     axes(my_axes);
     
     if mode(3)==0
        the_frame=images.frameA;
     else
         the_frame=images.frameB;
     end
     
     the_frame(the_frame==0)=min(min(the_frame(the_frame~=0)));
     imshow(imadjust((the_frame)));set(gca,'ydir','normal');
     
     shown_image_size=size(the_frame);
     if mode(1)==0
     if ~isempty(roi)
           
    
         
           if parameters.rotation
               rangey=sort([max(1,shown_image_size(1)-roi(1)+1),min(shown_image_size(1),shown_image_size(1)-roi(2)+1)]);
               rangex=sort([max(1,roi(3)+1),min(shown_image_size(2),roi(4)+1)]); 
           else
               rangex=sort([max(1,roi(1)),min(shown_image_size(2),roi(2))]);
               rangey=sort([max(1,roi(3)),min(shown_image_size(1),roi(4))]);   
           end
           
           if parameters.flip_hor
               rangex=sort(shown_image_size(2)+1-rangex);
           end
           
           if parameters.flip_ver
               rangey=sort(shown_image_size(1)+1-rangey);
           end
           
           
           hold on
           plot([rangex(1) rangex(2) rangex(2) rangex(1) rangex(1)],...
           [rangey(1) rangey(1) rangey(2) rangey(2) rangey(1)],...
                '--r',...
                'linewidth',2);
            hold off 
     end
     end
     
    if mode(2)==1
        if ~isempty(parameters.apparrent_mask)
         hold on
         contour(parameters.apparrent_mask,'b');
         hold off

     end  
    end       
     
end
        

