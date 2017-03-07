function removed_background=LFD_MPIV_remove_background(images,method)
        if nargin<2
            method='min';
        end
        
        switch method
            case 'min' 
                background=min(images,[],3);
            case 'mean'
                background=mean(images,3);
        end
        background=repmat(background,[1 1 size(images,3)]);
        removed_background=images-background;
        
        
    