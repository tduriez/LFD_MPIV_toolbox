   function s=display_image(my_axes,cxd,parameters);
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
        
        %% Initial try with actual parameters. 
        
        
        n_necessary=parameters.frame_skip+1;
        if strcmp(parameters.frame_mode,'AB')
            n_necessary=1;
        end
         
        [images,~,nb_frames]=LFD_MPIV_read_cxd(cxd,1:n_necessary,0);
        if nb_frames~=parameters.source_frames;
            parameters.source_frames=nb_frames;
            n_necessary=parameters.frame_skip+1;
            if strcmp(parameters.frame_mode,'Ab')
                n_necessary=1;
            end
            images=LFD_MPIV_read_cxd(cxd,1:n_necessary,0);
        end
        
        roi=parameters.roi;
        parameters.roi=[];
        images=LFD_MPIV_prepare_frames(images,parameters,0);
        
        
        axes(my_axes);
        imshow(imadjust(images.frameA));
        s=size(images.frameA);
        if ~isempty(roi)
           
           rangex=[max(1,roi(3)):min(s(1),roi(4))];
           rangey=[max(1,roi(1)):min(s(2),roi(2))];
           
            %cut_images=images.frameA(rangex,rangey);
            
           
           
           hold on
           plot([rangey(1) rangey(end) rangey(end) rangey(1) rangey(1)],...
           [rangex(1) rangex(1) rangex(end) rangex(end) rangex(1)],...
                '--r',...
                'linewidth',2);
            hold off
             
            
        end
        parameters.roi=roi;
        