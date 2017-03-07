function [data,parameters]=filter_fields(data,parameters);
%FILTER_FIELDS applys different filters on the vector fields. Private
%function, see inside file for documentation.
%
% This file is a copy of parts of the PIVlab toolbox, corrected and
% adapted for this toolbox use.
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
% LICENSE



warning('off','MATLAB:smoothn:SLowerBound')
%% FILTER 1 : Threshold on signal to noise.
    
    
    data.u=removeNAN(data.u);
    data.v=removeNAN(data.v);

    if parameters.current_pass<length(parameters.IntWin)+1
%% FILTER 2 : 
    
  
    
    stdthresh=4;
    meanu=nanmean(nanmean(data.u));
    meanv=nanmean(nanmean(data.v));
    std2u=nanstd(reshape(data.u,size(data.u,1)*size(data.u,2),1));
    std2v=nanstd(reshape(data.v,size(data.v,1)*size(data.v,2),1));
    minvalu=meanu-stdthresh*std2u;
    maxvalu=meanu+stdthresh*std2u;
    minvalv=meanv-stdthresh*std2v;
    maxvalv=meanv+stdthresh*std2v;
    data.u(data.u<minvalu)=NaN;
    data.u(data.u>maxvalu)=NaN;
    data.v(data.v<minvalv)=NaN;
    data.v(data.v>maxvalv)=NaN;
    
  
   %% FILTER 3 
    
   
    epsilon=0.02;
    thresh=2;
    [J,I]=size(data.u);
    %medianres=zeros(J,I);
    normfluct=zeros(J,I,2);
    b=1;
    %eps=0.1;
    for c=1:2
        if c==1;
            velcomp=data.u;
        else
            velcomp=data.v;
        end

        clear neigh
        for ii = -b:b;
            for jj = -b:b;
                neigh(:, :, ii+2*b, jj+2*b)=velcomp((1+b:end-b)+ii, (1+b:end-b)+jj);
            end
        end

        neighcol = reshape(neigh, size(neigh,1), size(neigh,2), (2*b+1)^2);
        neighcol2= neighcol(:,:, [(1:(2*b+1)*b+b) ((2*b+1)*b+b+2:(2*b+1)^2)]);
        neighcol2 = permute(neighcol2, [3, 1, 2]);
        med=median(neighcol2);
        velcomp = velcomp((1+b:end-b), (1+b:end-b));
        fluct=velcomp-permute(med, [2 3 1]);
        res=neighcol2-repmat(med, [(2*b+1)^2-1, 1,1]);
        medianres=permute(median(abs(res)), [2 3 1]);
        normfluct((1+b:end-b), (1+b:end-b), c)=abs(fluct./(medianres+epsilon));
    end
   
    
      info1=(sqrt(normfluct(:,:,1).^2+normfluct(:,:,2).^2)>thresh);
    data.u(info1==1)=NaN;
    data.v(info1==1)=NaN;
    %find typevector...
    %maskedpoints=numel(find((typevector)==0));
    %amountnans=numel(find(isnan(data.u)==1))-maskedpoints;
    %discarded=amountnans/(size(data.u,1)*size(data.u,2))*100;
    %disp(['Discarded: ' num2str(amountnans) ' vectors = ' num2str(discarded) ' %'])
    
    
    
    %replace nans
    data.u=inpaint_nans(data.u,4);
    data.v=inpaint_nans(data.v,4);
    %smooth predictor
     try
         
        if parameters.current_pass<length(parameters.IntWin)
            data.u = smoothn(data.u,0.6); %stronger smoothing for first passes
            data.v = smoothn(data.v,0.6);
        else
            data.u = smoothn(data.u); %weaker smoothing for last pass
            data.v = smoothn(data.v);
        end
   
    catch
        fprintf('can''t use smoothn\n')
        %old matlab versions: gaussian kernel
        h=fspecial('gaussian',5,1);
        data.u=imfilter(data.u,h,'replicate');
        data.v=imfilter(data.v,h,'replicate');
     end
  
    end
    
     
end
    

function data=removeNAN(data,patch_size);
if nargin<2
    patch_size=1;
end
[i,j]=find(isnan(data));
idx=find(isnan(data));

    s=size(data);
    newdata=zeros(1,length(i));
    if ~isempty(i)
for k=1:length(i);
    sample=data(max(1,i(k)-patch_size):min(s(1),i(k)+patch_size),max(1,j(k)-patch_size):min(s(2),j(k)+patch_size));
    sample=sample(~isnan(sample));
    if ~isempty(sample);
        newdata(k)=median(sample);
    else
        newdata=0;
    end
end
data(idx)=newdata;
    end
end
    
    
    