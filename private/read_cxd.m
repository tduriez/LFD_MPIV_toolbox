function [images,image_size,nb_frames,number_of_images]=read_cxd(file_name,indices,verb,mode,msg,avg)
%LFD_MPIV_READ_CXD function that reads CXD files. 
%   IMAGES=LFD_MPIV_READ_IMAGES(FILENAME);
%   IMAGES is a IxJxN uint16 matrix where IxJ is the image size and N the
%   number of images.
%   FILENAME is a string containing the path to the .cxd file. 
%
%   IMAGES=LFD_MPIV_READ_IMAGES(FILENAME,INDICES);
%   Only recover images specified in INDICES (integer array). The procedure
%   still reads the file from the beginning, but stops at the last required
%   image. Memory efficient, not speed efficient.
%
%   IMAGES=LFD_MPIV_READ_IMAGES(FILENAME,INDICES,VERB);
%   achieves the same as before, with adjustable verbosity:
%   VERB = 0: No output;
%   VERB = 1: Displays image size and number of images (default);
%   VERB = 2: Displays progression;
%   VERB = 3: Displays images as they get extracted;
%   VERB = 4: Debugging (step by step detection of features);
%
%   See also LFD_MPIV_COMMANDLINE, LFD_MPIV_INTERFACE
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


%% Undocumented option 'mode'
% 'mode' is set to 'normal' for most uses.
% when set to 'std' it will output the first buffer (be it single or double
% frame) in image(:,:,1) and the standart deviation of the buffers
% in image(:,:,2).

%% Undocumented option 'VERB=-1'
% if verb=-1 a waitbar is used for loading images and the message set in
% 'msg' is used.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAIN FUNCTION 
    % The main idea is to read the file little by little so the memory is
    % not swamped. A buffer is filled and emptied as features are detected.

    if nargin<3 
        verb=1; % set default
    end
    
    if nargin<4
        mode='normal';
    else
        if isempty(mode)
            mode='normal';
        end
    end
    
    if nargin<5
        msg='loading';
    end
    
    header_block_size=2048*5;
    block_size=512;
    
    %% Some info recollection and display.
    [image_size,nb_frames]=read_header_cxd(file_name,verb); % image_size is for 1 frame. 
    fid=fopen(file_name);
    
    file_info=dir(file_name);               % just to estimate file size
    
    %12 bits images coded on 16 bits (2 bytes) => factor 2.
    
    number_of_images=floor(file_info.bytes/(prod(image_size)*2*nb_frames)); 
    if nargin<2
        indices=1:number_of_images;
    else
        if isempty(indices)
            indices=1:number_of_images;
        end
    end
    
    
    
    %% initialize buffer and result matrix
    if strcmp(mode,'normal')
        images=uint16(zeros(image_size(2),image_size(1)*nb_frames,length(indices)));
    else
        images=uint16(zeros(image_size(2),image_size(1)*nb_frames,2));
    end
    
    if strcmp(mode,'std') && nargin <6
        avg=zeros(image_size(2),image_size(1)*nb_frames);
    end
    
    if strcmp(mode,'std') && nargin ==6
        std_dev=zeros(image_size(2),image_size(1)*nb_frames);
    end
    last_image=indices(end);
    k=0;
    
    %% Pass the header
    fread(fid,header_block_size,'uint16=>uint16','l'); 
    
    
    
    
    
    
    %% main loop (default mode)   
    if verb==-1;h=waitbar(0,msg);end
    the_verb=verb;
    for i=1:last_image
        if verb==-1;
            h=waitbar(i/last_image,h);
        else
            if intersect(indices,i)
                verb=the_verb;
            else
                verb=0;
            end
        end
        sample=fread(fid,block_size,'uint16=>uint16','l')';
        while detect_pattern(sample) || bullshit(sample) || detect_zero(sample)
            if verb>3
                figure(665)
                plot(sample)
                title('pattern')
                pause
            end
            sample=fread(fid,block_size,'uint16=>uint16','l')';
            if isempty(sample)
                break
            end
        end
        B=sample;    
         
        % A is also a buffer, it contains 10% image_size of what follows.
        try
        [im]=obtain_image(fid,B,image_size,block_size,nb_frames,  verb);
        if find(indices==i);
            k=k+1;
            if strcmp(mode,'normal') || k==1
                images(:,:,k)=im;
            end
            
            if strcmp(mode,'std') && nargin<6
                avg=avg+double(im);
            elseif strcmp(mode,'std') && nargin==6
                
                std_dev=std_dev+abs(double(im)-avg);
            end
            
        if verb>1;fprintf('obtained image %d\n',i);end
        end
        catch
            if verb>1;fprintf('End of file reached\n');end
            number_of_images=number_of_images-1;
            break
        end  
    end
  
    if strcmp(mode,'normal') 
        images=images(:,:,1:min(number_of_images,length(indices)));
        if verb>0;fprintf('%d images contained\n',number_of_images);end
    end
    
    if strcmp(mode,'std')
        images=double(images);
    end
    
    if strcmp(mode,'std') && nargin<6
        images(:,:,2)=(avg/number_of_images);
    elseif strcmp(mode,'std') && nargin==6
        images(:,:,2)=(std_dev/number_of_images)./avg;
    end
    
    
    
    
    %% Second call for std
    if strcmp(mode,'std') && nargin<6
        images=read_cxd(file_name,indices,verb,'std','Computing Standart Deviation',images(:,:,2));
    end
     if verb==-1;close(h);end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HEADER DATA EXTRACTION

function [image_size,nb_frames]=read_header_cxd(file_name,verb)
    %% Main hypothesis

size_of_header_sections=2^12;                           %% There should be at least 5 times 2^12 uint8 in the header
block_size=512;

%% Read header and get image size
fid=fopen(file_name);if fid==-1;error('Cannot open specified CXD (%s). Does it even exist? Seriously...',file_name);end
fread(fid,size_of_header_sections*4,'uint8=>char');     %% Moving to the fifth section
A=fread(fid,size_of_header_sections*1,'uint8=>char');   %% Getting the fifth section

%fprintf('%s\n',A');                                    %% Display fifth section (commented)

idx1=strfind(A','Capture Region');                      %% Beginning of interresting things
idx2=strfind(A','Display Depth');                       %% End of interresting things
capt=A(idx1:idx2-1)';                                   %% Get image size
idxop=strfind(capt,'(');                                %% |                                              
idxcl=strfind(capt,')');                                %% |
capt=capt(idxop+1:idxcl-1);                             %% |
idxvir=strfind(capt,',');                               %% |
image_size=[str2double(capt(idxvir(2)+1:...             %% | 
    idxvir(3)-1)),str2double(capt(idxvir(3)+1:end))];   %% Here we are.

%% Read first Image
sample=fread(fid,block_size,'uint16=>uint16','l')';
        while detect_pattern(sample) || bullshit(sample)
            if verb>3
                figure(665)
                plot(sample)
                title('pattern')
                pause
            end
            sample=fread(fid,block_size,'uint16=>uint16','l')';
        end
        A=sample;
        A=[A fread(fid,2*prod(image_size)-length(A),'uint16=>uint16','l')'];
        fclose(fid);
        
        sample=A(prod(image_size)+1:prod(image_size)+block_size);
        
        if bullshit(sample) || detect_pattern(sample) || detect_zero(sample)
            nb_frames=1;
        else
            nb_frames=2;
        end
        
         
        


if verb>0;fprintf('Image size: %d x %d\n',image_size(1),image_size(2));end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMAGE EXTRACTION

function [image]=obtain_image(fid,A,image_size,block_size,nb_frames,verb)
    % The buffer contains the beginning of the image. So we read 110% of
    % the next image to get the image and the following buffer. This might
    % break for small images (smaller than 200000 elements);
    A=[A fread(fid,nb_frames*prod(image_size)-length(A),'uint16=>uint16','l')'];
   
    while any(strfind(A,zeros([1 block_size]))) % Detect possible WTF block of block_size null elements. 
        A=[A fread(fid,block_size,'uint16=>uint16','l')'];
        idx=strfind(A,zeros([1 block_size])); % in the image
        A=[A(1:idx-1) A(idx+block_size:end)]; % and bypass it
    end
    
    if verb>3
        figure(665)
        plot(A)
        title('image')
        pause
    end
        
    image=reshape(A(1:nb_frames*prod(image_size)),image_size(1)*nb_frames,image_size(2))';
    if verb>2
    figure(666)
    warning('off','images:initSize:adjustingMag')

    imshow(imadjust(image));drawnow
    end
   
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NON-IMAGE DETECTION
function out=bullshit(A)
% the main hypothesis here is that cxd file is made of blocks of block_size
% elements in between 12 bits images. 
out=0;  
if any(A>2^12)
    out=1;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PATTERN DETECTION
function out=detect_pattern(A)
    % We just look for similarity, not exact pattern as some FEFF blocks 
    % can appear.
    block_size=numel(A);
    A=A(:)';
    pattern=1:block_size/2;
    b=double(A(1:2:block_size));
    s=sum(mod(b(1:block_size/2)-1,block_size/2)+1-pattern==0);
    if s>=block_size/2*0.66
        out=1;
    else
        out=0;
    end
  %  keyboard
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ZERO BLOCK
    function out=detect_zero(A)
        if all(A==0)
            out=1;
        else
            out=0;
        end
    end
