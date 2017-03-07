function new_images=reorder_frames(images);
    for i=1:numel(images)-1
        new_images(2*i-1).frameA=images(i).frameA;
        new_images(2*i-1).frameB=images(i+1).frameA;
        new_images(2*i).frameA=images(i).frameB;
        new_images(2*i).frameB=images(i+1).frameB;
    end
        