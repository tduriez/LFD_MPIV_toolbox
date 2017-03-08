function new_dbl_frame=reorder_frame_to_frame(dbl_frame,step,mode)
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


        
        
        