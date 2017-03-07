function [ipeak1,jpeak1,index1,ipeak2,jpeak2,index2,s2n]=find_all_displacement(correlations)
% FIND_ALL_DISPLACEMENT     find all integer pixel displacement in a stack
% of correlation windows.
%
%   [IPEAK1,JPEAK1,INDEX1,IPEAK2,JPEAK2,INDEX2,S2N]=find_all_displacement(COR)
%   
%   CORR is a (N x N x N_corr) array where N is the size of the square
%   correlation maps, and N_corr the number of correlation maps, usually
%   the same number than interrogation windows. 
%
%   IPEAK1, JPEAK1 are the horizontal and vertical indices of the first
%   maximum for each slice of COR in the third dimension.
%
%   IPEAK2, JPEAK2 are the horizontal and vertical indices of the second
%   maximum for each slice of COR in the third dimension.
%
%   INDEX1 and INDEX2 are the absolute indexes of the maximums in COR(:).
%  
%   S2N is the ratio between the first and the second peak. 0 indicates non
%   confiable results (peaks at edges and absence of seconf peak).
%
%   No loop ! (Well, no explicit loop)
%   the matrix CORR contains all the intercorrelations, in different slices 
%   indexed in the third dimension of c. We do all the operations at once, 
%   for each slice.
%
%   LICENSE

%% find first pick
N=size(correlations,1);
who_is_the_max=max(max(correlations)); % that's a 1x1xnumber of interrogation window vector
we_are_the_max=(correlations==repmat(who_is_the_max,[N N 1])); % value of max
index1=find(we_are_the_max);              % absolute index in c(:)

[jpeak1,ipeak1,k]=ind2sub([N,N],index1);

% now what happen if you have two elements equals to the max ? Let's see if
% they are in the same layer ! Then we take the first one. Surely the
% second one will be the second peak. Anyway this would be a bad vector.
[~,idx]=unique(k);
index1=index1(idx);
ipeak1=ipeak1(idx);
jpeak1=jpeak1(idx);
%FIXME unmark possible other maximum equal to the first in we_are_the_max






%% find second pick
if N>=64
filt_size=9;
elseif N>=32;
    filt_size=4;
else
    filt_size=3;
end

r=imfilter(we_are_the_max,ones(filt_size));  % Most obvious implicit loop.
                                             % Still better than a parfor.

% Before: we_are_the_max(:,:,i)  | After: r(:,:,i)
%
% 000000000000000000000000000000 | 000000000000000000000000000000 
% 000000000000000000000000000000 | 000000000000000000000000000000
% 000000000000000000000000000000 | 000001111i_s000000000000000000
% 000000000000000000000000000000 | 000001111i_s000000000000000000
% 000000i_s000000000000000000000 | 000001111i_s000000000000000000-pixj1
% 000000000000000000000000000000 | 000001111i_s000000000000000000
% 000000000000000000000000000000 | 000001111i_s000000000000000000
% 000000000000000000000000000000 | 000000000000000000000000000000
% 000000000000000000000000000000 | 000000000000000000000000000000
% 000000000000000000000000000000 | 000000000000000000000000000000
% 000000000000000000000000000000 | 000000000000000000000000000000
% 000000000000000000000000000000 | 000000000000000000000000000000
% 000000000000000000000000000000 | 000000000000000000000000000000
%       |                                 |
%       pixi1                             pixi1

correlations=(1-r).*correlations;                                  % Mask out the peak. 
who_is_the_max2=max(max(correlations));
we_are_the_max2=(correlations==repmat(who_is_the_max2,[N N 1]));
index2=find(we_are_the_max2);



%% end debug

[jpeak2,ipeak2,k]=ind2sub([N,N],index2);
[~,idx]=unique(k);
index2=index2(idx);
ipeak2=ipeak2(idx);
jpeak2=jpeak2(idx);





%% Get signal to noise

s2n=zeros(1,size(who_is_the_max,3));
s2n(permute(who_is_the_max2,[1 3 2])~=0)=permute(who_is_the_max(who_is_the_max2~=0)./who_is_the_max2(who_is_the_max2~=0),[1 3 2]);
% Maximum at a border usually indicates that Max took the first one it
% found... Let's put it a shitty signal to noise, like 0 ;)
s2n(jpeak1==1)=0;
s2n(ipeak1==1)=0;
s2n(jpeak1==N)=0;
s2n(ipeak1==N)=0;
s2n(jpeak2==1)=0;
s2n(ipeak2==1)=0;
s2n(jpeak2==N)=0;
s2n(ipeak2==N)=0;




end

