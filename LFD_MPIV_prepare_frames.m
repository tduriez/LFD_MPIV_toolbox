function new_images=LFD_MPIV_prepare_frames(images,nb_frames,step,mode,varargin);
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
        


