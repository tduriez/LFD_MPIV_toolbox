function [cut_images]=LFD_MPIV_cut_images(images,varargin)
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
    
    
    allowed_args  = {'dire'   ,'rotation','flip_ver','flip_hor','roi'    };
    allowed_types = {'numeric','numeric' ,'numeric' ,'numeric' ,'numeric'};
    default       = {2        ,0         ,0         ,0         ,[]       };
    
    
    [options,errormsg]=parameters_parser(varargin,allowed_args,allowed_types,default,2);
    if ~isempty(errormsg)
        error(errormsg);
    end
    
    shiftblock=[circshift([1 2],[0 options.dire]) 3];
    
    images=permute(images,shiftblock);
    
    s=size(images);
    if numel(s)<3
        s=[s 1];
    end
    
    if s(options.dire)/2~=round(s(options.dire)/2)
        fprintf('Number of elements in direction #%i is not pair.\n',options.dire);
        return
    end
    
    
   % h=waitbar(0,sprintf('Cutting %d images in 2 frames',s(3)));
    for i=1:s(3)
    %    waitbar(i/s(3),h,sprintf('Cutting image %d of %d',i,s(3)));
        if i==1
        cut_images(1).frameA=rot90(permute(images(:,1:s(2)/2,i)',shiftblock),1+options.rotation);
        cut_images(1).frameB=rot90(permute(images(:,s(2)/2+1:end,i)',shiftblock),1+options.rotation);
        cut_images=repmat(cut_images,[1 s(3)]);
        else
            cut_images(i).frameA=rot90(permute(images(:,1:s(2)/2,i)',shiftblock),1+options.rotation);
            cut_images(i).frameB=rot90(permute(images(:,s(2)/2+1:end,i)',shiftblock),1+options.rotation);
        end
        
         if ~isempty( options.roi)
             roi=options.roi;
             s2=size(cut_images(i).frameA);
             
             x_range=max(1,roi(3)):min(roi(4),s2(1));
             y_range=max(1,roi(1)):min(roi(2),s2(2));
             [x_range(1) x_range(1) x_range(end) x_range(end)];
             [y_range(1) y_range(end) y_range(end) y_range(1)];
%              if i==1;
%                 imshow(imadjust(cut_images(i).frameA));
%                 hold on
%                 plot([x_range(1) x_range(1) x_range(end) x_range(end)],...
%                     [y_range(1) y_range(end) y_range(end) y_range(1)],...
%                     'color','r','linewidth',2,'linestyle','--')
%              end
            cut_images(i).frameA=cut_images(i).frameA(x_range,y_range);
            cut_images(i).frameB=cut_images(i).frameB(x_range,y_range);
            
            
            
        end
        
        if options.flip_ver
            cut_images(i).frameA=flipud(cut_images(i).frameA);
            cut_images(i).frameB=flipud(cut_images(i).frameB);
        end
        
        if options.flip_hor
            cut_images(i).frameA=fliplr(cut_images(i).frameA);
            cut_images(i).frameB=fliplr(cut_images(i).frameB);
        end
        
        
    end
    %close(h)
    