function [data]=PIV(images,input_parameters)
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

%% transforming input_parameters in structure to add specfific fields
the_properties=properties(input_parameters);
parameters=struct;
for i=1:length(the_properties)
    parameters.(the_properties{i})=input_parameters.(the_properties{i});
end

parameters.proof=0;
parameters.Step=round(parameters.IntWin.*(parameters.overlap/100));
% data is a structure that will contain x,y,u and v
data=[];

for current_pass=1:length(parameters.IntWin)
    IntWin=parameters.IntWin(current_pass);
    
    if parameters.Verbose;tic;fprintf('Pass number %d: (%dx%d)\n',current_pass,IntWin,IntWin);end
    parameters.current_pass=current_pass;
    
    % Prepare images, get interrogation windows indices + image deformation
    if parameters.Verbose>1;tic;fprintf('Image preprocessing...        ');end
    [work_images,indices,data,parameters]=prepare_images(images,data,parameters);
    if parameters.Verbose>1;fprintf('ok (%.3f s)\n',toc);end
    
   
    % Cumulative cross correlation
    if parameters.Verbose>1;tic;fprintf('Cross correlation...          ');end
    correlation=cumulative_cross_correlation(work_images,indices,parameters);
    if parameters.Verbose>1;fprintf('ok (%.3f s)\n',toc);end
    
    
    
    % Determine raw vector field
    if parameters.Verbose>1;tic;fprintf('Vector field determination... ');end
    [data,parameters]=vector_field_determination(correlation,data,parameters);
    if parameters.Verbose>1;fprintf('ok (%.3f s)\n',toc);end
    
    
    
    % Filter vector field for next pass or final result
    if parameters.Verbose>1;tic;fprintf('Filtering...                  ');end
    [data,parameters]=filter_fields(data,parameters);
    if parameters.Verbose>1;fprintf('ok (%.3f s)\n\n',toc);end
    
    
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
        set(q,'color','y')
        
        
        
        [hg,bins]=hist(sqrt(data.u(~isnan(data.u)).^2+data.v(~isnan(data.u)).^2),1000);
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
if parameters.Verbose>0;fprintf('Total time (current PIV): %s\n',datestr(t2-t1,13));end
    
