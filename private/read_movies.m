function [images,image_size,nb_frames,number_of_images]=read_movies(file_name,indices,verb,mode,msg,avg);

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



nb_frames=1;
if ~exist('temp','dir')
    mkdir temp
end
timestamp=datestr(now,'HHMMSS');


if isempty(indices)
    system(sprintf('ffmpeg -i %s temp/%s-images%%04d.png',file_name,timestamp));
    d=dir(sprintf('temp/%s-images*.png',timestamp));
    indices=1:length(d);
else
    system(sprintf('ffmpeg -i %s -vframes %d temp/%s-images%%04d.png',file_name,max(indices),timestamp));
    d=dir(sprintf('temp/%s-images*.png',timestamp));
end


indices=unique(min(indices,length(d)));
number_of_images=numel(indices);

if verb==-1;h=waitbar(0,msg);end

if strcmp(mode,'normal')
    
    for i=indices
        if verb==-1;h=waitbar(find(indices==i)/numel(indices),h);end
        image=uint16(sum(imread(sprintf('temp/%s-images%04d.png',timestamp,i)),3));
        if ~exist('images','var');
            images=repmat(image,[1 1 numel(indices)]);
        else
            images(:,:,i)=image;
        end
    end
elseif strcmp(mode,'std') && nargin <6
    for i=indices
        if verb==-1;h=waitbar(find(indices==i)/numel(indices),h);end
        avg=double(sum(imread(sprintf('temp/%s-images%04d.png',timestamp,i)),3));
        if ~exist('avg','var');
            avg=double(sum(imread(sprintf('temp/%s-images%04d.png',timestamp,i)),3));
        else
            avg=avg+double(sum(imread(sprintf('temp/%s-images%04d.png',timestamp,i)),3));
        end
    end
    avg=avg/number_of_images;
    images=read_movies(file_name,indices,verb,'std','Computing Standart Deviation',avg);
elseif strcmp(mode,'std') && nargin == 6
    for i=indices
        if verb==-1;h=waitbar(find(indices==i)/numel(indices),h);end
        image=double(sum(imread(sprintf('temp/%s-images%04d.png',timestamp,i)),3));
        if ~exist('images','var');
            images=repmat(image,[1 1 2]);
            images(:,:,2)=abs(avg-image);
        else
            images(:,:,2)=images(:,:,2)+abs(avg-image);
        end
    end
    images(:,:,2)=(images(:,:,2)./avg)/number_of_images;
end

cd('temp')
delete('*.*');
cd ..
rmdir temp

image_size=[size(images,2) size(images,1)];
if verb==-1;close(h);end





