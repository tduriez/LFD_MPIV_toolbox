function [allowed_args,default_args,allowed_types]=default_parameters(indices);
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
    i=1;
    
    
    
    %% Image import options
    args(:,i)={'cxd_file','','char'};i=i+1;
    args(:,i)={'frame_skip',1,'numeric'};i=i+1;
    args(:,i)={'frame_mode','AB','char'};i=i+1;
    args(:,i)={'source_frames',2,'numeric'};i=i+1;
    args(:,i)={'image_indices',[],'numeric'};i=i+1;
    args(:,i)={'dire',2,'numeric'};i=i+1;
    args(:,i)={'background','auto','char'};i=i+1;
    
    
    %% Image display options
    args(:,i)={'roi',[],'numeric'};i=i+1;
    
    args(:,i)={'flip_hor',0,'numeric'};i=i+1;
    args(:,i)={'flip_ver',0,'numeric'};i=i+1;
    args(:,i)={'rotation',0,'numeric'};i=i+1;
    args(:,i)={'mask',[],'numeric'};i=i+1;
    args(:,i)={'apparrent_mask',[],'numeric'};i=i+1;
    
    %% PIV options
    args(:,i)={'IntWin',[64 32 16],'numeric'};i=i+1;
    args(:,i)={'overlap',[50 50 50],'numeric'};i=i+1;
    args(:,i)={'cumulcross',1,'numeric'};i=i+1;
    args(:,i)={'deltat',1,'numeric'};i=i+1;
    args(:,i)={'scale',1,'numeric'};i=i+1;
    args(:,i)={'SubPixMode',1,'numeric'};i=i+1;
    args(:,i)={'ImDeform','linear','char'};i=i+1;
    
    %% Synchronization options
    args(:,i)={'ttl_folder','','char'};i=i+1;
    args(:,i)={'acq_freq',1,'numeric'};i=i+1;
    args(:,i)={'act_freq',1,'numeric'};i=i+1;
    args(:,i)={'nb_phases',1,'numeric'};i=i+1;
     
    %% Tomography option
    args(:,i)={'height',0,'numeric'};i=i+1;
    
    %% Export options
    args(:,i)={'case_name','data','char'};i=i+1;
    args(:,i)={'the_date',datestr(now,'yyyymmdd-HHMMSS'),'char'};i=i+1;
    args(:,i)={'export_folder',pwd,'char'};i=i+1;
    args(:,i)={'export_filename',sprintf('%s_%s',datestr(now,'yyyymmdd-HHMMSS'),'data'),'char'};i=i+1;
    
    
    %% Global options    
    args(:,i)={'Verbose',2,'numeric'};i=i+1;

    
    if nargin<1;
        indices=1:size(args,2);
    else
        if isempty(indices)
            indices=1:size(args,2);
        end
    end
    
    
    allowed_args=args(1,indices);
    default_args=args(2,indices);
    allowed_types=args(3,indices);
end
    
    
    
 
