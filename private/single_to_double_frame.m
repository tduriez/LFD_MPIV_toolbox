function [dbl_frame,apparent_mask] = single_to_double_frame(sgl_frame,options)
%SINGLE_TO_DOUBLE_FRAME Transforms image time series in successive double
%frame buffers.
%   DBL_FRAME=SINGLE_TO_DOUBLE_FRAME(SGL_FRAME,OPTIONS)
%
%   SGL_FRAME is a [nI,nJ,nImages] 3D-array containing all images.
%   OPTIONS.FRAME_SKIP is an integer (Default 1).
%   OPTIONS.FRAME_MODE is a string. Only 'TimeSeries' (default) and 'Successive'
%   are allowed.
%
%   In 'TimeSeries' mode, the images are transformed as follows (FRAME_SKIP=1):
%
%   1 2 3 4 5 6 7 8 9  => 9 images, 8 double frame buffers.
%   A A A A A A A A
%     B B B B B B B B
%
%   In 'Successive' mode, the images are transformed as follows (FRAME_SKIP=1):
%
%   1 2 3 4 5 6 7 8 9  => 9 images, 4 double frame buffers.
%   A   A   A   A
%     B   B   B   B
%
%   Each unit of step shifts the B frame one unit further. In successive
%   modes this automatically shifts the next A frame too. With FRAME_SKIP=3:
%
%   'TimeSeries'
%
%   1 2 3 4 5 6 7 8 9  => 9 images, 6 double frame buffers.
%   A A A A A A
%         B B B B B B
%
%   'Successive'
%
%   1 2 3 4 5 6 7 8 9  => 9 images, 2 double frame buffers.
%   A       A
%         B       B
%
%   Copyright (c) 2017, Thomas Duriez (Distributed under GPLv3)

%% Copyright
%    Copyright (c) 2017, Thomas Duriez
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

nImages=size(sgl_frame,3);


step=options.frame_skip;
mode=options.frame_mode;



if ~any(strcmpi({'TimeSeries','Successive'},mode))
    error('Mode can only be ''TimeSeries'' or ''Successive''.');
end

switch mode
    case 'TimeSeries'
        idxFrameA=1:(nImages-step);
    case 'Successive'
        idxFrameA=1:(step+1):(nImages-step-1);
end
idxFrameB=idxFrameA+step;

if isempty(options.mask)
    options.mask=ones(size(sgl_frame(:,:,1)));
else
        if ~all(size(options.mask)~=size(sgl_frame(:,:,1)))
            options.mask=ones(size(sgl_frame(:,:,1)));
        end
end

for i=1:length(idxFrameA);
    dbl_frame(i).frameA=sgl_frame(:,:,idxFrameA(i));
    dbl_frame(i).frameB=sgl_frame(:,:,idxFrameB(i));
    if i==1
        masked_image=sgl_frame(:,:,idxFrameA(i))+uint16((1-options.mask)*2^16);
        dbl_frame=repmat(dbl_frame,[1 length(idxFrameA)]);
    end
    
    if ~isempty(options.roi)
        roi=options.roi;
        s2=size(dbl_frame(i).frameA);
        
        x_range=max(1,roi(3)):min(roi(4),s2(1));
        y_range=max(1,roi(1)):min(roi(2),s2(2));
        [x_range(1) x_range(1) x_range(end) x_range(end)];
        [y_range(1) y_range(end) y_range(end) y_range(1)];
        %              if i==1;
        %                 imshow(imadjust(dbl_frame(i).frameA));
        %                 hold on
        %                 plot([x_range(1) x_range(1) x_range(end) x_range(end)],...
        %                     [y_range(1) y_range(end) y_range(end) y_range(1)],...
        %                     'color','r','linewidth',2,'linestyle','--')
        %              end
        if i==1
            masked_image=masked_image(x_range,y_range);
        end
        dbl_frame(i).frameA=dbl_frame(i).frameA(x_range,y_range);
        dbl_frame(i).frameB=dbl_frame(i).frameB(x_range,y_range);
    end
    
    if options.rotation
        if i==1
            masked_image=rot90(masked_image,options.rotation);
        end
        dbl_frame(i).frameA=rot90(dbl_frame(i).frameA,options.rotation);
        dbl_frame(i).frameB=rot90(dbl_frame(i).frameB,options.rotation);
    end
    
    
    if options.flip_ver
        if i==1
            masked_image=flipud(masked_image);
        end
        dbl_frame(i).frameA=flipud(dbl_frame(i).frameA);
        dbl_frame(i).frameB=flipud(dbl_frame(i).frameB);
    end
    
    if options.flip_hor
        if i==1
            masked_image=fliplr(masked_image);
        end
        dbl_frame(i).frameA=fliplr(dbl_frame(i).frameA);
        dbl_frame(i).frameB=fliplr(dbl_frame(i).frameB);
    end
    
    
    
end
apparent_mask=uint16(masked_image~=uint16(2^16));

end

