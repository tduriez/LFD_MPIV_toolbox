function [cut_images,apparent_mask]=cut_images_to_double_frames(images,varargin)
% part data along one dimension. Hope you deal with pair numbers.
% FIXME: try to come with general dimension handling
% FIXME: maybe check data conformity
% FIXME: redact help
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

    if nargin>1
        if isa(varargin{1},'LFD_MPIV_parameters')
            parameters=varargin{1};
        else
            parameters=LFD_MPIV_parameters;
            parameters.update(varargin{:});
        end
    else
        parameters=LFD_MPIV_parameters;
    end
    
    
    shiftblock=[circshift([1 2],[0 parameters.dire]) 3];
    
    images=permute(images,shiftblock);
    
    s=size(images);
    if numel(s)<3
        s=[s 1];
    end
    
    if s(parameters.dire)/2~=round(s(parameters.dire)/2)
        fprintf('Number of elements in direction #%i is not pair.\n',parameters.dire);
        return
    end
    
    
        
    
    if isempty(parameters.mask)
        parameters.mask=ones(size(permute(images(:,1:s(2)/2,1),shiftblock)));
    else
        
        if ~all(size(parameters.mask)==size(permute(images(:,1:s(2)/2,1),shiftblock)))
            parameters.mask=ones(size(permute(images(:,1:s(2)/2,1),shiftblock)));
        end
    end
    
  
    for i=1:s(3)
    
        if i==1
        masked_image=permute(images(:,1:s(2)/2,i),shiftblock)+uint16((1-parameters.mask)*2^16);
        cut_images(1).frameA=permute(images(:,1:s(2)/2,i),shiftblock);
        cut_images(1).frameB=permute(images(:,s(2)/2+1:end,i),shiftblock);
        cut_images=repmat(cut_images,[1 s(3)]);
        else
            cut_images(i).frameA=permute(images(:,1:s(2)/2,i),shiftblock);
            cut_images(i).frameB=permute(images(:,s(2)/2+1:end,i),shiftblock);
        end
        
         if ~isempty( parameters.roi)
             roi=parameters.roi;
             s2=size(cut_images(i).frameA);
             
             x_range=max(1,roi(3)):min(roi(4),s2(1));
             y_range=max(1,roi(1)):min(roi(2),s2(2));
             [x_range(1) x_range(1) x_range(end) x_range(end)];
             [y_range(1) y_range(end) y_range(end) y_range(1)];
            if i==1
                masked_image=masked_image(x_range,y_range);
            end
            cut_images(i).frameA=cut_images(i).frameA(x_range,y_range);
            cut_images(i).frameB=cut_images(i).frameB(x_range,y_range);
            
            
            
         end
        
        if parameters.rotation
            if i==1
                masked_image=rot90(masked_image,parameters.rotation);
            end
            cut_images(i).frameA=rot90(cut_images(i).frameA,parameters.rotation);
            cut_images(i).frameB=rot90(cut_images(i).frameB,parameters.rotation);
        end
    
         
        if parameters.flip_ver
            if i==1
                masked_image=flipud(masked_image);
            end
            cut_images(i).frameA=flipud(cut_images(i).frameA);
            cut_images(i).frameB=flipud(cut_images(i).frameB);
        end
        
        if parameters.flip_hor
            if i==1
                masked_image=fliplr(masked_image);
            end
            cut_images(i).frameA=fliplr(cut_images(i).frameA);
            cut_images(i).frameB=fliplr(cut_images(i).frameB);
        end
        
        
    end
    
    apparent_mask=uint16(masked_image~=uint16(2^16));
    
    