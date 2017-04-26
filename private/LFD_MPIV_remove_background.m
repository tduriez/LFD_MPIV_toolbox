function removed_background=LFD_MPIV_remove_background(images,method)
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
            method='auto';
        end
        
        
        
        if strcmp(method,'auto')
            s=size(images);
            s=[s 1];
            if s(3)>=10;
                method='min';
            else
                method='none';
            end
        end
            
        
       if strcmp(method,'none')
            removed_background=images;
            return
        end
        
        switch method
            case 'min' 
                background=min(images,[],3);
            case 'avg'
                background=mean(images,3);
        end
      
        background=repmat(background,[1 1 size(images,3)]);
        removed_background=images-uint16(background);
        
        
    