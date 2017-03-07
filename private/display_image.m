   function s=display_image(my_axes,cxd,parameters);
        images=LFD_MPIV_read_cxd(cxd,1,0);
        roi=parameters.roi;
        parameters.roi=[];
        images=LFD_MPIV_cut_images(images,parameters);
        axes(my_axes);
        imshow(imadjust(images.frameA));
        s=size(images.frameA);
        if ~isempty(roi)
           
           rangex=[max(1,roi(3)):min(s(1),roi(4))];
           rangey=[max(1,roi(1)):min(s(2),roi(2))];
           
            cut_images=images.frameA(rangex,rangey);
            
           
           
           hold on
           plot([rangey(1) rangey(end) rangey(end) rangey(1) rangey(1)],...
           [rangex(1) rangex(1) rangex(end) rangex(end) rangex(1)],...
                '--r',...
                'linewidth',2);
            hold off
             
            
        end