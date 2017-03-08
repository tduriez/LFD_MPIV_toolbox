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
    
    %% File options
    args(:,i)={'cxd_file','','char'};i=i+1;
    args(:,i)={'ttl_folder','','char'};i=i+1;
    
    %% Image import options
    args(:,i)={'im_step',1,'numeric'};i=i+1;
    args(:,i)={'im_mode','AB','char'};i=i+1;
    args(:,i)={'source_frames',2,'numeric'};i=i+1;
    
    %% Image display options
    args(:,i)={'roi',[],'numeric'};i=i+1;
    args(:,i)={'dire',2,'numeric'};i=i+1;
    args(:,i)={'flip_hor',0,'numeric'};i=i+1;
    args(:,i)={'flip_ver',0,'numeric'};i=i+1;
    
    %% PIV options
    args(:,i)={'IntWin',[64 32 16],'numeric'};i=i+1;
    args(:,i)={'overlap',[50 50 50],'numeric'};i=i+1;
    args(:,i)={'cumulcross',1,'numeric'};i=i+1;
    args(:,i)={'deltat',1,'numeric'};i=i+1;
    args(:,i)={'scale',1,'numeric'};i=i+1;
    args(:,i)={'SubPixMode',1,'numeric'};i=i+1;
    args(:,i)={'ImDeform','linear','char'};i=i+1;
    
    %% Synchronization options
    args(:,i)={'acq_freq',1,'numeric'};i=i+1;
    args(:,i)={'act_freq',1,'numeric'};i=i+1;
    args(:,i)={'nb_phases',1,'numeric'};i=i+1;
     
    %% Tomography option
    args(:,i)={'case_name',sprintf('%s_default',...
        datestr(now,'yyyymmdd-HHMMSS')),'char'};i=i+1;
    args(:,i)={'height',0,'numeric'};i=i+1;
    
    %% Global options    
    args(:,i)={'Verbose',1,'numeric'};i=i+1;
    
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
    
    
    
 