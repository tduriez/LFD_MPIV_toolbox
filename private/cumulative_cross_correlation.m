%CUMULATIVE_CROSS_CORRELATION averages correlation maps from an image stack
%      Private function, see inside file for documentation.
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


function suma_correlation=cumulative_cross_correlation(work_images,indices,parameters)
    IntWin=parameters.IntWin(parameters.current_pass);
    for cur_image=1:length(work_images)
        % INDICES is created by private function prepare_image.
        % It is a [IntWin x IntWin x N] stack where N is the number of
        % interrogation windows. If a displacement is already known, then
        % the second frame is moved and deformed, then other indices are
        % used in INDICES{2}. A and B are stacks of interrogation windows.
        
        A = work_images(cur_image).frameA(indices{1});
        if length(indices)<2
            B = work_images(cur_image).frameB(indices{1}); 
        else
            B = work_images(cur_image).frameB(indices{2});
        end
        correlation=cross_correlate(A,B,IntWin);
        
        % If normalization is not achieved at that point, one faulty image
        % can really mess the average correlation map.
        correlation=normalize_correlation_map(correlation);
        if cur_image==1
            suma_correlation=correlation/length(work_images);
        else
            suma_correlation=suma_correlation+correlation/length(work_images);
        end
    end
end

function normalized_correlation=normalize_correlation_map(correlation)
   normalized_resolution=2^8;
   min_correl=repmat(min(min(correlation,[],1),[],2),[size(correlation, 1) size(correlation, 2) 1]);
   max_correl=repmat(max(max(correlation,[],1),[],2),[size(correlation, 1) size(correlation, 2) 1]);
   normalized_correlation = (correlation-min_correl)./(max_correl-min_correl)*(normalized_resolution-1);
end

function c=cross_correlate(A,B,N)
    A=single(A);B=single(B);
    fftA=fft2(A);
    fftB=fft2(B);
    c=fftshift(fftshift(real(ifft(ifft(conj(fftA).*fftB,N,2),N,1)),2),1);
    c(c<0)=0;
end


