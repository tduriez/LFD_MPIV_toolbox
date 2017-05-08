function new_images=LFD_MPIV_prepare_frames(images,parameters)
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


images=LFD_MPIV_remove_background(images,parameters.background);
images=flipud(images); 

switch parameters.source_frames
    case 1
        [new_images,apparrent_mask]=single_to_double_frame(images,parameters);
    case 2
        [new_images,apparrent_mask]=LFD_MPIV_cut_images(images,parameters);
        new_images=reorder_frame_to_frame(new_images,parameters.frame_skip,parameters.frame_mode);
end

parameters.apparrent_mask=apparrent_mask;
