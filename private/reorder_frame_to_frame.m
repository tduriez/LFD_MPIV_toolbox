function new_dbl_frame=reorder_frame_to_frame(dbl_frame,step,mode)
nImages=numel(dbl_frame);

if nargin<2
    step=1;
else
    if isempty(step)
        step=1;
    end
end



if nargin<3
    mode='AA';
    else
    if isempty(mode)
        mode='AA';
    end
end


if ~any(strcmpi({'AA','AB'},mode))
    error('Mode can only be ''AA'' or ''AB''.');
end



switch mode
    case 'AB'
        new_dbl_frame=dbl_frame;  %% useless, but avoids unnecessary condition outside this file
    case 'AA'
        
        new_dbl_frame=repmat(dbl_frame(1),[1 2*(nImages-step)]);
        for i=1:nImages-step
            new_dbl_frame(2*i-1).frameA=dbl_frame(i).frameA;
            new_dbl_frame(2*i-1).frameB=dbl_frame(i+step).frameA;
            new_dbl_frame(2*i).frameA=dbl_frame(i).frameB;
            new_dbl_frame(2*i).frameB=dbl_frame(i+step).frameB;
        end
end


        
        
        