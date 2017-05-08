classdef LFD_MPIV_parameters < handle
    %LFD_MPIV_PARAMETERS. Class handling the LFD_MPIV Toolbox options.
    %
    % options=LFD_MPIV_parameters returns an object with default parameters.
    %
    % The fields of this object list all options that can be passed either
    % through this object, either as a parameter-value pair to any LFD_MPIV
    % function. ( Ex: LFD_MPIV_CommandLine('my_file.cxd','IntWin',64) )
    %
    % List of parameters that can be used with the LFD_MPIV functions:
    %
    % -- Image import options -------------------------------------------------
    %    parameter    |  type   | default |          comments
    % cxd_file        | char    |  ''     | route to the cxd file
    % source_frames   | integer | 2       | Number of frames/buffer. Can be
    %                 |         |         | collected as an output of
    %                 |         |         | LFD_MPIV_read_images. Automatically
    %                 |         |         | corrected by most LFD_MPIV
    %                 |         |         | functions.
    % frame_mode      | char    | 'AB'    | Double frame buffers have acces to
    %                 |         |         | 'AB' and 'AA' modes. 'AB'
    %                 |         |         | correlates frame A and B of same
    %                 |         |         | buffer, 'AA' correlates same frames
    %                 |         |         | from different buffers.
    %                 |         |         | Single frame buffers have acces to
    %                 |         |         | 'TimeSeries' and 'Consecutive'. You
    %                 |         |         | only want to use the first one. See
    %                 |         |         | <a href="matlab:help private/single_to_double_frame">here</a> for more details.
    % frame_skip      | integer | 1       | Buffers to skip for correlation.
    %                 |         |         | Can't apply to 'AB' mode.
    % image_indices   | integer | []      | Indices of the images to use from
    %                 |         |         | the CXD file. [] uses the whole
    %                 |         |         | file.
    % dire            | integer |  2      | In case of two frames in one buffer
    %                 |         |         | specifies the direction of the cut.
    %                 |         |         | 1: horizontaly
    %                 |         |         | 2: verticaly
    % background      | char    | 'auto'  | Removes background. 'auto'
    %                 |         |         | removes minimum of images if
    %                 |         |         | there is more than 10 images
    %                 |         |         | 'min' removes the minimum
    %                 |         |         | 'avg' removes the average
    %                 |         |         | 'none' does nothing.
    %
    % -- Frame display options ------------------------------------------------
    %    parameter    |  type   | default |          comments
    % roi             | integer |  []     | Region Of Interest. Determines in
    %                 |         |         | pixels how to cut the image in the
    %                 |         |         | form [h_start h_end v_start v_end].
    %                 |         |         | [10 150 3 950] cuts the image from
    %                 |         |         | the 10th pixel horizontaly to the
    %                 |         |         | 150th pixel horizontaly. And from
    %                 |         |         | the 3rd vertically to the 950th.
    %                 |         |         | An empty value ([], default) will
    %                 |         |         | make use of the whole image.
    % flip_hor        | logical |  0      | Flips the image horizontaly when
    %                 |         |         | True
    % flip_ver        | logical |  0      | Flips the image verticaly when
    %                 |         |         | True
    % rotation        | integer |  0      | Rotates the image by ROTATION x 90
    %                 |         |         | degrees.
    % mask            | logical |  []     | Same size as the original image.
    %                 |         |         | Zeros indicates where no vectors
    %                 |         |         | should be computed.
    % apparrent_mask  | uint16  |  []     | Mask after transformations.
    %
    % -- PIV options ------------------------------------------d----------------
    %    parameter    |  type   | default    |          comments
    % IntWin          | integer | [64 32 16] | Successive interrogation window
    %                 |         |            | sizes. Sets the number of
    %                 |         |            | passes.
    % overlap         | double  |    50      | Percentage of overlaping between
    %                 |         |            | interrogation windows. Only
    %                 |         |            | works with 50 for now. #FIXME.
    % cumulcross      | logical |  1 / True  | Activates the cumulative cross-
    %                 |         |            | correlation. When activated all
    %                 |         |            | fields belonging to the same
    %                 |         |            | phase are achieved through an
    %                 |         |            | averaging of the correlation
    %                 |         |            | maps. This applies to all fields
    %                 |         |            | when there is no phase averaging
    %                 |         |            | ('nb_phases=1'). When deactivated
    %                 |         |            | all fields are computed and
    %                 |         |            | phase averaging is disabled.
    % deltat          | double  |    1       | Time between two frames in
    %                 |         |            | seconds.
    % scale           | double  |    1       | Space scaling factor in m/pixel.
    % SubPixMode      | integer |    1       | Well the other method don't work
    %                 |         |            | #FIXME
    % ImDeform        | char    | 'linear'   | Image deformation method.
    %                 |         |            | Also works with 'cubic' and
    %                 |         |            | 'spline', but you don't want to
    %                 |         |            | change. Trust me.
    %
    % -- Synchronization options ----------------------------------------------
    %    parameter    |  type   | default |          comments
    % ttl_folder      | char    |  ''     | folder with TTL files. If this is
    %                 |         |         | empty the 'acq_freq' propertie
    %                 |         |         | is used.
    % nb_phases       | integer | 1       | Number of phases to reconstruct. If
    %                 |         |         | set to 1, no phase reconstruction
    %                 |         |         | is achieved.
    % acq_freq        | double  | 1       | In case no TTL file is used, this
    %                 |         |         | frequency (in Hertz) is used to
    %                 |         |         | determine when pictures are taken.
    %                 |         |         | Has an effect only if phase
    %                 |         |         | reconstruction is achieved.
    % act_freq        | double  | 1       | Actuation frequency, in Hertz.
    %                 |         |         | Has an effect only if phase
    %                 |         |         | reconstruction is achieved.
    %
    % -- Tomography option ----------------------------------------------------
    %    parameter    |  type   | default |          comments
    % height          | double  | 0       | Height of a given PIV slice. In an
    %                 |         |         | array of LFD_MPIV_parameters
    %                 |         |         | objects, two slices with the same
    %                 |         |         | 'case_name' and 'height' will
    %                 |         |         | return an error.
    %
    % -- Export options -------------------------------------------------------
    %    parameter    |  type   | default |          comments
    % case_name       | char    | 'data'  | This will be used to specify how
    %                 |         |         | data is saved. It is also used to
    %                 |         |         | determine in an array of
    %                 |         |         | LFD_MPIV_parameters objects, which
    %                 |         |         | files belong to which tomography.
    %                 |         |         | All sets of parameters with same
    %                 |         |         | 'case_name' will be used to achieve
    %                 |         |         | 3D reconstruction.
    % the_date        | char    | now     | as datestr(now,'yyyymmdd-HHMMSS')
    % export_folder   | char    | pwd     | where data is saved.
    %                 |         |         | Ex: '/home/user1/Documents/Data/'
    % export_filename | char    | see ->  | Unless explicitely user specified,
    %                 |         |         | any change to 'case_name' and
    %                 |         |         | 'the_date' will change this field
    %                 |         |         | as [the_date '-' case_name]. If the
    %                 |         |         | date is empty then this field is
    %                 |         |         | same as 'case_name'.
    %
    % -- Global options -------------------------------------------------------
    %    parameter    |  type   | default |          comments
    % Verbose         | integer | 1       |   How much information you get.
    %                 |         |         |   Debugging starts at 3.
    % release         | char    | N/A     |   Release number of the toolbox
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
    

    properties (SetObservable)
       
    
    %% Image import options
    cxd_file
    frame_mode
    frame_skip
    source_frames
    image_indices
    dire
    background
    
    %% Frames display options
    roi
    flip_hor
    flip_ver
    rotation
    mask
    apparrent_mask
    
    %% PIV options
    IntWin
    overlap
    cumulcross
    deltat
    scale
    SubPixMode
    ImDeform
    
    %% Synchronization options
    ttl_folder
    acq_freq
    act_freq
    nb_phases
     
    %% Tomography option
    height
    
    %% Export options
    case_name
    the_date
    export_folder
    export_filename
    
    %% Global options    
    Verbose
    
	
    
    end
    
    properties (SetAccess=immutable)
    release='2.0'
    end
    
    methods
        
%% Overload Display        
        function varargout=display(obj,mode)
            if nargin<2
                mode='short';
            end
            
            
           output_text=parameters_display(obj,mode,inputname(1));
            
            
            if nargout<1
                fprintf(output_text);
            else
                varargout{1}=output_text;
            end
            
            
        end
        
        %% Constructor     
        
        function obj=LFD_MPIV_parameters()
            [allowed_args,default_args]=default_parameters();
            for i=1:length(allowed_args)
                obj.(allowed_args{i})=default_args{i};
            end
            addlistener(obj,'IntWin','PostSet',@LFD_MPIV_parameters.IntWinChange);
            addlistener(obj,'overlap','PostSet',@LFD_MPIV_parameters.IntWinChange);
            addlistener(obj,'the_date','PostSet',@LFD_MPIV_parameters.FileNameChange);
            addlistener(obj,'case_name','PostSet',@LFD_MPIV_parameters.FileNameChange);
	    addlistener(obj,'source_frames','PostSet',@LFD_MPIV_parameters.FrameChange);
        end
        
        %% Update the object
        
        function obj=update(obj,varargin)
            [allowed_args,~,allowed_classes]=default_parameters();
            params=parameters_parser(varargin, allowed_args, allowed_classes,obj,1);
            thefields=fieldnames(params);
            for i=1:length(thefields)
                obj.(thefields{i})=params.(thefields{i});
            end
        end
        
        %% Create new handle with same values
        function obj2=copy(obj)
            obj2=LFD_MPIV_parameters;
            obj2.update(obj);
        end
        

            
        
    end
    
    %% all ####ing checks
    
    methods (Static) 
        function IntWinChange(metaProp,eventData)
            h=eventData.AffectedObject;
            h.overlap=50*ones(1,length(h.IntWin));
        end
        
        function FileNameChange(metaProp,eventData)
            h=eventData.AffectedObject;
            if ~isempty(h.the_date)
                h.export_filename=sprintf('%s_%s',h.the_date,h.case_name);
            else
                h.export_filename=h.case_name;
            end
            
        end
        
        function FrameChange(metaProp,eventData)
            h=eventData.AffectedObject;
            if h.source_frames==1
                if strcmp(h.frame_mode,'AA') || strcmp(h.frame_mode,'Successive')
                    h.frame_mode='Successive';
                else
                    h.frame_mode='TimeSeries';
                end
            else
                if strcmp(h.frame_mode,'AA') || strcmp(h.frame_mode,'Successive')
                    h.frame_mode='AA';
                else
                    h.frame_mode='AB';
                end
            end
        end
        
        
    end
    
    
end

