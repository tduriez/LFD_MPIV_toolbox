function [data,parameters]=vector_field_determination(correlation,data,parameters,is_it_last);
% This file contains a copy of parts of the PIVlab toolbox, modified for this toolbox use.
%
% PIVlab copyright:
% Copyright (c) 2016, William Thielicke
% Copyright (c) 2006, David Long
% Copyright (c) 2016, The MathWorks, Inc.
% Copyright (c) 2009, John D'Errico
% Copyright (c) 2007, Douglas M. Schwarz
% Copyright (c) 2016, Damien Garcia
% Copyright (c) 2008, Duane Hanselman
% All rights reserved.
%
% filter_fields.m copyright:
%    
% Copyright (c) 2017, Thomas Duriez

% PIVlab copyright:
% Copyright (c) 2016, William Thielicke
% Copyright (c) 2006, David Long
% Copyright (c) 2016, The MathWorks, Inc.
% Copyright (c) 2009, John D'Errico
% Copyright (c) 2007, Douglas M. Schwarz
% Copyright (c) 2016, Damien Garcia
% Copyright (c) 2008, Duane Hanselman
% All rights reserved.
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
%     * Neither the name of the RUBIC - Research Unit of Biomechanics & Imaging in Cardiology nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%
% 
%    filter_fields copyright:
%    
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
    if nargin<4
        is_it_last=0;
    end
    
    try
        s2n_threshold=parameters.s2n;
    catch
        s2n_threshold=1;
    end
    
    

    IntWin=parameters.IntWin(parameters.current_pass);
    minix= parameters.minix;
    maxix= parameters.maxix;
    miniy=parameters.miniy;
    maxiy=parameters.maxiy;
    step=parameters.Step(parameters.current_pass);

    %% Normalize result
    minres = permute(repmat(squeeze(min(min(correlation))), [1, size(correlation, 1), size(correlation, 2)]), [2 3 1]);
    deltares = permute(repmat(squeeze(max(max(correlation))-min(min(correlation))), [1, size(correlation, 1), size(correlation, 2)]), [2 3 1]);
    correlation = ((correlation-minres)./deltares)*255;

    %% Find first and second peak
    [x1,y1,index1,x2,y2,index2,s2n]=find_all_displacement(correlation);


    %% Sub-pixel determination

    if (rem(IntWin,2) == 0) %for the subpixel displacement measurement
        SubPixOffset=1;
    else
        SubPixOffset=0.5;
    end

    if parameters.SubPixMode==1
        [vector] = SUBPIXGAUSS (correlation,IntWin, x1, y1, index1,SubPixOffset);
    elseif parameters.SubPixMode==2 %% prone to errors
        [vector] = SUBPIX2DGAUSS (correlation,IntWin, x1, y1, index1,SubPixOffset);
    end
    
    
    
    %% Create data 
    
    data_empty=1;
    if ~isempty(data)
        data_empty=0;
    end
 
    
    
    data.x = repmat((minix:step:maxix)+IntWin/2, length(miniy:step:maxiy), 1);
    data.y = repmat(((miniy:step:maxiy)+IntWin/2)', 1, length(minix:step:maxix));
    vector = permute(reshape(vector, [size(data.x') 2]), [2 1 3]);
    
     
    
    s2n=s2n(reshape((1:numel(data.x)),size(data.x,2),size(data.x,1)))';
    
    %% signal to noise filter
    if is_it_last
    vector(:,:,1)=vector(:,:,1).*(s2n>s2n_threshold);
    vector(:,:,2)=vector(:,:,2).*(s2n>s2n_threshold);
    end
    
    %% assignement
    if ~data_empty
        
        data.u=data.u + vector(:,:,1);
        data.v=data.v + vector(:,:,2);
    else
        data.u=vector(:,:,1);
        data.v=vector(:,:,2);
    end
    data.x = repmat((minix:step:maxix)+IntWin/2, length(miniy:step:maxiy), 1);
    data.y = repmat(((miniy:step:maxiy)+IntWin/2)', 1, length(minix:step:maxix));
    data.s2n=s2n;
    
    if parameters.current_pass==length(parameters.IntWin)
        data.x=data.x-IntWin/2;
        data.y=data.y-IntWin/2;
    end
    
end
   

function [vector] = SUBPIXGAUSS(result_conv, IntWin, x, y, idx, SubPixOffset)
    z= (1:length(idx))';
    xi = find(~((x <= (size(result_conv,2)-1)) & (y <= (size(result_conv,1)-1)) & (x >= 2) & (y >= 2)));
    x(xi) = [];
    y(xi) = [];
    z(xi) = [];
    xmax = size(result_conv, 2);
    vector = NaN(size(result_conv,3), 2);
  
    if(numel(x)~=0)
        ip = sub2ind(size(result_conv), y, x, z);
        
        %the following 8 lines are copyright (c) 1998, Uri Shavit, Roi Gurka, Alex Liberzon, Technion � Israel Institute of Technology
        %http://urapiv.wordpress.com
        f0 = log(result_conv(ip));
        f1 = log(result_conv(ip-1));
        f2 = log(result_conv(ip+1));
        peaky = y + (f1-f2)./(2*f1-4*f0+2*f2);
        f0 = log(result_conv(ip));
        f1 = log(result_conv(ip-xmax));
        f2 = log(result_conv(ip+xmax));
        peakx = x + (f1-f2)./(2*f1-4*f0+2*f2);

        SubpixelX=peakx-(IntWin/2)-SubPixOffset;
        SubpixelY=peaky-(IntWin/2)-SubPixOffset;
        vector(z, :) = [SubpixelX, SubpixelY];  
    end
end
    
    function [vector] = SUBPIX2DGAUSS(result_conv, IntWin, x, y, idx, SubPixOffset)
    z= (1:length(idx))';
    xi = find(~((x <= (size(result_conv,2)-1)) & (y <= (size(result_conv,1)-1)) & (x >= 2) & (y >= 2)));
    x(xi) = [];
    y(xi) = [];
    z(xi) = [];
    xmax = size(result_conv, 2);
    vector = NaN(size(result_conv,3), 2);
    if(numel(x)~=0)
        c10 = zeros(3,3, length(z));
        c01 = c10;
        c11 = c10;
        c20 = c10;
        c02 = c10;
        ip = sub2ind(size(result_conv), y, x, z);

        for i = -1:1
            for j = -1:1
                %following 15 lines based on
                %H. Nobach � M. Honkanen (2005)
                %Two-dimensional Gaussian regression for sub-pixel displacement
                %estimation in particle image velocimetry or particle position
                %estimation in particle tracking velocimetry
                %Experiments in Fluids (2005) 38: 511�515
                c10(j+2,i+2, :) = i*log(result_conv(ip+xmax*i+j));
                c01(j+2,i+2, :) = j*log(result_conv(ip+xmax*i+j));
                c11(j+2,i+2, :) = i*j*log(result_conv(ip+xmax*i+j));
                c20(j+2,i+2, :) = (3*i^2-2)*log(result_conv(ip+xmax*i+j));
                c02(j+2,i+2, :) = (3*j^2-2)*log(result_conv(ip+xmax*i+j));
                %c00(j+2,i+2)=(5-3*i^2-3*j^2)*log(result_conv_norm(maxY+j, maxX+i));
            end
        end
        c10 = (1/6)*sum(sum(c10));
        c01 = (1/6)*sum(sum(c01));
        c11 = (1/4)*sum(sum(c11));
        c20 = (1/6)*sum(sum(c20));
        c02 = (1/6)*sum(sum(c02));
        %c00=(1/9)*sum(sum(c00));

        deltax = squeeze((c11.*c01-2*c10.*c02)./(4*c20.*c02-c11.^2));
        deltay = squeeze((c11.*c10-2*c01.*c20)./(4*c20.*c02-c11.^2));
        peakx = x+deltax;
        peaky = y+deltay;

        SubpixelX = peakx-(IntWin/2)-SubPixOffset;
        SubpixelY = peaky-(IntWin/2)-SubPixOffset;

        vector(z, :) = [SubpixelX, SubpixelY];
    end
    end
    
  