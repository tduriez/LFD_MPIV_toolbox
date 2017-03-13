classdef LFD_MPIV_parameters < handle
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

    properties (SetObservable)
        
    %% File options
    cxd_file
    ttl_folder
    
    %% Image import options
    im_step
    im_mode
    source_frames
    
    %% Image display options
    roi
    dire
    flip_hor
    flip_ver
    rotation
    
    %% PIV options
    IntWin
    overlap
    cumulcross
    deltat
    scale
    SubPixMode
    ImDeform
    
    %% Synchronization options
    acq_freq
    act_freq
    nb_phases
     
    %% Tomography option
    case_name
    height
    
    %% Global options    
    Verbose
    
    end
    
    methods
        
            
        
        
        function obj=LFD_MPIV_parameters(varargin)
            [allowed_args,default_args]=default_parameters();
            for i=1:length(allowed_args)
                obj.(allowed_args{i})=default_args{i};
            end
            addlistener(obj,'IntWin','PostSet',@LFD_MPIV_parameters.IntWinChange);
            addlistener(obj,'overlap','PostSet',@LFD_MPIV_parameters.IntWinChange);
        end
        
        function obj=update(obj,varargin)
            [allowed_args,~,allowed_classes]=default_parameters();
            params=parameters_parser(varargin, allowed_args, allowed_classes,obj,1);
            thefields=fieldnames(params);
            for i=1:length(thefields)
                obj.(thefields{i})=params.(thefields{i});
            end
        end
            
    end
    
    methods (Static) %% all ####ing checks 
        function IntWinChange(metaProp,eventData)
            h=eventData.AffectedObject;
            h.overlap=50*ones(1,length(h.IntWin));
        end
         
        
    end
            
    
end

