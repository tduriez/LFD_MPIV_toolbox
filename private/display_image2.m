function [shown_image_size,parameters]=display_image2(cxd,parameters,my_axes,mode);
    if nargin < 2
        parameters=LFD_MPIV_parameters;
    end
    if nargin < 3
        my_axes=gca;
    end
    if nargin < 4
        mode=dec2bin(0,5)-48;
    else
        mode=dec2bin(mode,5)-48;
    end
    
    fprintf('M.O.D.E:\n')
    fprintf('%d ',mode)
    
    n_necessary=parameters.frame_skip+1;
    [images,image_size,nb_frames]=LFD_MPIV_read_cxd(cxd,1:n_necessary,0);
    parameters.source_frames=nb_frames;
    
    roi=parameters.roi;
    if mode(1)==0
        parameters.roi=[1 image_size(1) 1 image_size(2)];
    end
    
    
    
    images=LFD_MPIV_prepare_frames(images,parameters,0);
    images=images(1);
    parameters.roi=roi;
    if mode(2)==0
        if isempty(parameters.mask)
            parameters.mask=ones(fliplr(image_size));
        end
        images.frameA=images.frameA.*uint16(parameters.mask);
        images.frameB=images.frameB.*uint16(parameters.mask);
    end
    
     axes(my_axes);
     
     if mode(3)==0
        the_frame=images.frameA;
     else
         the_frame=images.frameB;
     end
     
     imshow(imadjust(the_frame));
     shown_image_size=size(the_frame);
     if ~isempty(roi)
         
           rangex=[max(1,roi(1)):min(shown_image_size(2),roi(2))];
           rangey=[max(1,roi(3)):min(shown_image_size(1),roi(4))];
           
            %cut_images=images.frameA(rangex,rangey);
            
           hold on
           plot([rangex(1) rangex(end) rangex(end) rangex(1) rangex(1)],...
           [rangey(1) rangey(1) rangey(end) rangey(end) rangey(1)],...
                '--r',...
                'linewidth',2);
            hold off 
     end
        
     if ~isempty(parameters.mask)
         hold on
         contour(parameters.mask,'b');
         hold off

     end
end
        

