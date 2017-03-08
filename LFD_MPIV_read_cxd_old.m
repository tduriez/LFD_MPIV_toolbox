function [images]=LFD_MPIV_read_cxd_old(file_name,indices,verb)
%READ_CXD function that reads CXD files. Obviously.
%
%   IMAGES=READ_CXD(FILENAME);
%   IMAGES is a IxJxN uint16 matrix where IxJ is the image size and N the
%   number of images.
%   FILENAME is a string containing the path to the .cxd file. 
%
%   IMAGES=READ_CXD(FILENAME,INDICES);
%   Only recover images specified in INDICES (integer array). The procedure
%   still reads the file from the beginning, but stops at the last required
%   image. Memory efficient, not speed efficient.
%
%   IMAGES=READ_CXD(FILENAME,INDICES,VERB);
%   achieves the same as before, with adjustable verbosity:
%   VERB = 0: No output;
%   VERB = 1: Displays image size and number of images (default);
%   VERB = 2: Displays progression;
%   VERB = 3: Displays images as they get extracted;
%   VERB = 4: Debugging (step by step detection of features);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAIN FUNCTION 
    % The main idea is to read the file little by little so the memory is
    % not swamped. A buffer is filled and emptied as features are detected.

    if nargin<3 
        verb=1; % set default
    end
    
    %% Some info recollection and display
    
    [image_size]=read_header_cxd(file_name,verb); % image_size is for 1 frame. In fact image size is 2ximage_size.
    fid=fopen(file_name);
    file_info=dir(file_name);               % just to get file size
    
    %12 bits images coded on 16 bits (2 bytes) => factor 2x2
    number_of_images=floor(file_info.bytes/(prod(image_size)*4)); 
    if nargin<2
        indices=1:number_of_images;
    else
        if isempty(indices)
            indices=1:number_of_images;
        end
    end
    
    if verb;fprintf('%d images contained\n',number_of_images);end
    
    %% initialize buffer and result matrix
    
    images=uint16(zeros(image_size(2),image_size(1)*2,length(indices)));
    last_image=indices(end);
    k=0;
    
    %% Pass the header
    fread(fid,5*2048,'uint16=>uint16','l'); %First 2048
    
    
    
    
    
    
    
    
    %% main loop    
    for i=1:last_image
        sample=fread(fid,2048,'uint16=>uint16','l')';
        while detect_pattern(sample) || bullshit(sample)
            if verb>3
                plot(sample)
                title('pattern')
                pause
            end
            sample=fread(fid,2048,'uint16=>uint16','l')';
        end
        B=sample;    
         
        % A is also a buffer, it contains 10% image_size of what follows.
        [im]=obtain_image(fid,B,image_size,verb);
        if find(indices==i);
            k=k+1;
            images(:,:,k)=im;
        if verb>1;fprintf('obtained image %d\n',i);end
        end
        
    end
    fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HEADER DATA EXTRACTION

function [image_size]=read_header_cxd(file_name,verb)
    %% Main hypothesis

size_of_header_sections=2^12;                           %% There should be at least 5 times 2^12 uint8 in the header


%% Read header and get image size
fid=fopen(file_name);if fid==-1;error('Cannot open specified CXD (%s). Does it even exist? Seriously...',file_name);end
fread(fid,size_of_header_sections*4,'uint8=>char');     %% Moving to the fifth section
A=fread(fid,size_of_header_sections*1,'uint8=>char');   %% Getting the fifth section
fclose(fid);
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

if verb;fprintf('Image size: %d x %d\n',image_size(1),image_size(2));end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMAGE EXTRACTION

function [image]=obtain_image(fid,A,image_size,verb)
    % The buffer contains the beginning of the image. So we read 110% of
    % the next image to get the image and the following buffer. This might
    % break for small images (smaller than 200000 elements);
    A=[A fread(fid,2*prod(image_size)-length(A),'uint16=>uint16','l')'];
    
    if any(strfind(A,zeros([1 2048]))) % Detect possible WTF block of 2048 null elements.
        A=[A fread(fid,2048,'uint16=>uint16','l')'];
        idx=strfind(A,zeros([1 2048])); % in the image
        A=[A(1:idx-1) A(idx+2048:end)]; % and bypass it
    end
    
    if verb>3
        
        plot(A)
        title('image')
        pause
    end
        
    image=reshape(A(1:2*prod(image_size)),image_size(1)*2,image_size(2))';
    if verb>2
    figure(2)
    imshow(imadjust(image));drawnow
    end
   
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NON-IMAGE DETECTION
function out=bullshit(A)
% the main hypothesis here is that cxd file is made of blocks of 2048
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
    A=A(:)';
    pattern=1:1024;
    b=double(A(1:2:2048));
    s=sum(mod(b(1:1024)-1,1024)+1-pattern==0);
    if s>=1000
        out=1;
    else
        out=0;
    end
end
