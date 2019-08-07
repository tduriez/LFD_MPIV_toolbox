function [images,image_size,nb_frames,number_of_images]=LFD_MPIV_read_images(varargin)
%LFD_MPIV_READ_IMAGES function that dispatch files to the correct reader. 
%  
%% Copyright
%    Copyright (c) 2019, Thomas Duriez
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

[~,~,EXT] = fileparts(varargin{1});
if strcmpi(EXT,'.cxd')
    fprintf('cxd file detected.\n')
    [images,image_size,nb_frames,number_of_images]=read_cxd(varargin{:});
elseif strcmpi(EXT,'.avi')
    fprintf('avi file detected.\n')
    [images,image_size,nb_frames,number_of_images]=read_avi(varargin{:});
else 
    keyboard
end
    
    
    






