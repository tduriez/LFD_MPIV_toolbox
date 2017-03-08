function [dbl_frame] = single_to_double_frame(sgl_frame,step,mode)
%SINGLE_TO_DOUBLE_FRAME Transforms image time series in successive double
%frame buffers.
%   DBL_FRAME=SINGLE_TO_DOUBLE_FRAME(SGL_FRAME)
%   DBL_FRAME=SINGLE_TO_DOUBLE_FRAME(SGL_FRAME,STEP)
%   DBL_FRAME=SINGLE_TO_DOUBLE_FRAME(SGL_FRAME,STEP,MODE)
%
%   SGL_FRAME is a [nI,nJ,nImages] 3D-array containing all images.
%   STEP is an integer (Default 1).
%   MODE is a string. Only 'TimeSeries' (default) and 'Successive' are 
%   allowed
%
%   In 'TimeSeries' mode, the images are transformed as follows (STEP=1):
%
%   1 2 3 4 5 6 7 8 9  => 9 images, 8 double frame buffers.
%   A A A A A A A A
%     B B B B B B B B
%
%   In 'Successive' mode, the images are transformed as follows (STEP=1):
%
%   1 2 3 4 5 6 7 8 9  => 9 images, 4 double frame buffers.
%   A   A   A   A   
%     B   B   B   B 
%
%   Each unit of step shifts the B frame one unit further. In successive
%   modes this automatically shifts the next A frame too. With STEP=3:
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

if nargin<2
    step=1;
else
    if isempty(step)
        step=1;
    end
end



if nargin<3
    mode='TimeSeries';
    else
    if isempty(mode)
        mode='TimeSeries';
    end
end


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
for i=1:length(idxFrameA);
dbl_frame(i).frameA=sgl_frame(:,:,idxFrameA(i));
dbl_frame(i).frameB=sgl_frame(:,:,idxFrameB(i));
end


end

