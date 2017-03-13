function [data]=LFD_MPIV_PIV(images,varargin)
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

t1=now;
% parameters contains all possible option

[parameters,errormsg]=get_options(varargin);



if ~isempty(errormsg)
    error(errormsg)
end

parameters.proof=0;

% data is a structure that will contain x,y,u and v
data=[];

for current_pass=1:length(parameters.IntWin)
    IntWin=parameters.IntWin(current_pass);
    
    if parameters.Verbose;tic;fprintf('Pass number %d: (%dx%d)\n',current_pass,IntWin,IntWin);end
    parameters.current_pass=current_pass;
    
    % Prepare images, get interrogation windows indices + image deformation
    if parameters.Verbose;tic;fprintf('Image preprocessing...        ');end
    [work_images,indices,data,parameters]=prepare_images(images,data,parameters);
    if parameters.Verbose;fprintf('ok (%.3f s)\n',toc);end
    
   
    % Cumulative cross correlation
    if parameters.Verbose;tic;fprintf('Cross correlation...          ');end
    correlation=cumulative_cross_correlation(work_images,indices,parameters);
    if parameters.Verbose;fprintf('ok (%.3f s)\n',toc);end
    
    
    
    % Determine raw vector field
    if parameters.Verbose;tic;fprintf('Vector field determination... ');end
    [data,parameters]=vector_field_determination(correlation,data,parameters);
    if parameters.Verbose;fprintf('ok (%.3f s)\n',toc);end
    
    
    
    % Filter vector field for next pass or final result
    if parameters.Verbose;tic;fprintf('Filtering...                  ');end
    [data,parameters]=filter_fields(data,parameters);
    if parameters.Verbose;fprintf('ok (%.3f s)\n\n',toc);end
    
    
    try %check if used from GUI
        if  ~exist('handles','var')
            handles=guihandles(getappdata(0,'LFD_MPIV_gui'));
        end
        axes(handles.axes1);
    
    catch %#ok<CTCH>
       
    end
    surf(data.x,data.y,data.x*0-1,sqrt(data.u.^2+data.v.^2));hold on
        vector_concentration=50;
        if max(data.x(:))>=max(data.y(:))
        ny_vectors=vector_concentration;
        nx_vectors=round(vector_concentration/max(data.x(:))*max(data.y(:)));
        else
            nx_vectors=vector_concentration;
        ny_vectors=round(vector_concentration/max(data.y(:))*max(data.x(:)));
        end
        ix_vectors=round(linspace(1,size(data.x,1),nx_vectors));
        iy_vectors=round(linspace(1,size(data.x,2),ny_vectors));
        q=quiver(data.x(ix_vectors,iy_vectors),data.y(ix_vectors,iy_vectors),...
            data.u(ix_vectors,iy_vectors),data.v(ix_vectors,iy_vectors),5);shading interp;view(0,90);
        set(q,'color','k')
        
        [hg,bins]=hist(sqrt(data.u(:).^2+data.v(:).^2),1000);
        levels=cumsum(hg)/sum(hg);
        p_threshold=0.05;
        [~,idx_minclim]=min(abs(p_threshold-levels));
        [~,idx_maxclim]=min(abs(1-p_threshold-levels));
        set(gca,'clim',[bins(idx_minclim) bins(idx_maxclim)])
        
        set(gca,'xlim',[min(data.x(:)) max(data.x(:))],'ylim',[min(data.y(:)) max(data.y(:))])
        daspect([1 1 1])
        hold off
        colormap default
        drawnow






end
data.x=data.x';
data.y=data.y';
data.u=data.u';
data.v=data.v';
data.s2n=data.s2n';

t2=now;
fprintf('Total time (current PIV): %s\n',datestr(t2-t1,13));
end
    


function [parameters,errormsg]=get_options(varargin)
%% Default behaviour
parameters.IntWin=[64 32 16 16];
overlap=50;
parameters.SubPixMode=1;
parameters.ImDeform='linear';
parameters.Verbose=1;
errormsg=[];
varargin=varargin{1};

%% Get arguments
if length(varargin)/2~=round(length(varargin)/2) % check validity
    errormsg='arguments must be a parameter (string) - value pair';
else
    for i=1:length(varargin)/2
        if ischar(varargin{i*2-1})
            switch lower(varargin{i*2-1})
                case 'intwin'
                    parameters.IntWin=varargin{i*2}(:);
                case 'overlap'
                    overlap=varargin{i*2}(:);
                case 'subpixmode'
                    parameters.SubPixMode=varargin{i*2};
                case 'imdeform'
                    parameters.ImDeform=varargin{i*2};
                case 'verbose'
                    parameters.Verbose=varargin{i*2};
                otherwise
                    errormsg=sprintf('Parameter ''%s'' unknown. Known parameters: IntWin, Overlap, SubPixMode, ImDeform, Verbose.',varargin{i*2-1});             
            end
        else
            errormsg='Parameters must be a string. Known parameters: IntWin, Overlap, SubPixMode, ImDeform, Verbose.';
        end
    end
end



%% Check Arguments 

% Overlap reliable only at 50%
if any(overlap~=50)
    errormsg=('Sorry, overlap can only be fixed at 50 for now');
end

if ~ischar(parameters.ImDeform)
    errormsg='''ImDeform'' can only be ''linear'' (Default), ''spline'' or ''cubic''.';
else
    if ~any(strcmp({'linear','spline','cubic'},parameters.ImDeform))
        errormsg='''ImDeform'' can only be ''linear'' (Default), ''spline'' or ''cubic''.';
    end
end

if ~isnumeric(parameters.IntWin)
    errormsg=('''IntWin'' can only be positive integer(s). Ex: [64 32 16 16]');
else
    if any(parameters.IntWin<0)
        errormsg=('''IntWin'' can only be positive integer(s). Ex: [64 32 16 16]');
    end
    if any(parameters.IntWin~=round(parameters.IntWin))
        errormsg=('''IntWin'' can only be positive integer(s). Ex: [64 32 16 16]');
    end
    if any(diff(parameters.IntWin)>0)
        errormsg=('''IntWin'' can only decrease. Ex: [64 32 16 16]');
    end
end


if ~isnumeric(overlap)
    errormsg=('''Overlap'' can only be positive integers between 0 and 100. Ex: 50');
    else
    if any(overlap<0)
         errormsg=('''Overlap'' can only be positive integers between 0 and 100. Ex: 50');
    end
    if any(overlap>100)
         errormsg=('''Overlap'' can only be positive integers between 0 and 100. Ex: 50');
    end
    if any(diff(overlap)<0)
        errormsg=('''Overlap'' cannot decrease. Ex: [0 0 50 50]');
    end
end

if ~isnumeric(parameters.SubPixMode)
    errormsg=('''SubPixMode'' can only be 1 (default) or 2. Ex: 1');
    else
    if numel(parameters.SubPixMode)~=1
         errormsg=('''SubPixMode'' can only be 1 (default) or 2. Ex: 1');
    else
        if parameters.SubPixMode~=1 
         errormsg=('Sorry, ''SubPixMode'' can only be 1 (default) the other mode is not working. Ex: 1');
        end
    end
end

if ~isnumeric(parameters.Verbose)
    errormsg=('''Verbose'' can only be 0, 1 (default) or 2. Ex: 1');
    else
    if numel(parameters.Verbose)~=1
         errormsg=('''Verbose'' can only be 0, 1 (default) or 2. Ex: 1');
    else
        if all([0 1 2]~=parameters.Verbose)
         errormsg=('''Verbose'' can only be 0, 1 (default) or 2. Ex: 1');
        end
    end
end
         

    
        
        





    
%% Set Step
if length(overlap)==1 || length(overlap)==length(parameters.IntWin)
    parameters.Step=round(parameters.IntWin.*(1-overlap/100));
else
     parameters.Step=round(parameters.IntWin.*(1-0.5/100));
    errormsg='''Overlap must be singleton or same size as ''IntWin''';
end

%% Display Arguments

if parameters.Verbose>0 || ~isempty(errormsg)
    fprintf('Parameters in use:\n')
    fprintf(['\tIntWin:    ' repmat(' %d,',[1 length(parameters.IntWin)-1])  ' %d\n'],parameters.IntWin)
    fprintf(['\tStep:      ' repmat(' %d,',[1 length(parameters.IntWin)-1])  ' %d\n'],parameters.Step)
    fprintf('\tSubPixMode: %d\n',parameters.SubPixMode)
    fprintf('\tImDeform:   %s\n',parameters.ImDeform)
    fprintf('\tVerbose:    %d\n',parameters.Verbose) 
end





end
