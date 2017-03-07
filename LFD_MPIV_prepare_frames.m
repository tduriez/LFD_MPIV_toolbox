function new_images=LFD_MPIV_prepare_frames(images,nb_frames,step,mode,varargin);
if nargin<2
    nb_frames=2;
else
    if isempty(nb_frames)
        nb_frames=2;
    end
end

if nargin<3
    step=1;
else
    if isempty(step)
        step=1;
    end
end

if nargin<4
    if nb_frames==2;
        mode='AB';
    else
        mode='TimeSeries';
    end
else
    if isempty(mode)
        if nb_frames==2;
            mode='AB';
        else
            mode='TimeSeries';
        end
    end
end

images=LFD_MPIV_remove_background(images);

switch nb_frames
    case 1
        new_images=single_to_double_frame(images,step,mode);
    case 2
        new_images=LFD_MPIV_cut_images(images,varargin{:});
        new_images=reorder_frame_to_frame(new_images,step,mode);
end
        


