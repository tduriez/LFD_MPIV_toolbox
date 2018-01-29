function [idx_frames2]=order_frames(a,c_thres)

%%
idx_frames1=1:size(a,3);
idx_frames2=idx_frames1;

%%
images=make_images(a,idx_frames1,idx_frames2);
c=check_correlativity(images);
if nargin<2
    plot(c)
    [~,c_thres]=ginput(1);
end
for i=1:length(images)
    if c(i)<c_thres
        idx_end=length(images);
        for j=i+1:length(images)
            if c(j)>c_thres
                idx_end=j;break
            end
        end
        im_test(1).frameA=images(i).frameA;
        im_test(1).frameB=images(i).frameB;
        im_test(2).frameA=images(i).frameB;
        im_test(2).frameB=images(i+1).frameA;
        im_test(3).frameA=images(i).frameA;
        im_test(3).frameB=images(i+1).frameB;
        im_test(4).frameA=images(i).frameA;
        im_test(4).frameB=images(i+1).frameA;
        im_test(5).frameA=images(i).frameB;
        im_test(5).frameB=images(i+1).frameB;
        c1=check_correlativity(im_test);
        if any(c1>c_thres)
            idx=find(c1>c_thres);
            if numel(idx)>1
                [~,idx]=max(c1);
                %fprintf('(1) 1A/1B: %f\n(2) 1B/2A: %f\n(3) 1A/2B: %f\n(4) 1A/2A: %f\n(5) 1B/2B: %f\n',c1);
                %idx=input('Which one ?\n');
            end
            switch idx
                case 1
                    fprintf('Never thought it could happen. Good luck\n')
                    %keyboard
                case 2
                    fprintf('Never thought it could happen. Good luck\n')
                    %keyboard
                case 3
                    idx_frames2(idx_frames2(i):idx_end-1)=idx_frames2(i+1):idx_frames2(idx_end);
                    images=make_images(a,idx_frames1,idx_frames2);
                    c=check_correlativity(images);     
                case 4
                    fprintf('Never thought it could happen. Good luck\n')
                    %keyboard
                case 5
                    fprintf('Never thought it could happen. Good luck\n')
                    %keyboard
            end
        else
        end
    end
end


end

function images=make_images(a,idx_frames1,idx_frames2,~)
s=size(a);
if nargin<4
    for i=1:length(idx_frames1)
        if i==1
            images(1).frameA=a(s(1)/2-128:s(1)/2+128-1,s(2)/4-128:s(2)/4+128-1,idx_frames1(1));
            images(1).frameB=a(s(1)/2-128:s(1)/2+128-1,3*s(2)/4-128:3*s(2)/4+128-1,idx_frames2(1));
            images=repmat(images(1),[1 length(idx_frames1)]);
        else
            images(i).frameA=a(s(1)/2-128:s(1)/2+128-1,s(2)/4-128:s(2)/4+128-1,idx_frames1(i));
            images(i).frameB=a(s(1)/2-128:s(1)/2+128-1,3*s(2)/4-128:3*s(2)/4+128-1,idx_frames2(i));
        end
    end
else
    for i=1:length(idx_frames1)
        if i==1
            images(1).frameA=a(:,1:s(2)/2,idx_frames1(1));
            images(1).frameB=a(:,s(2)/2+1:end,idx_frames2(1));
            images=repmat(images(1),[1 length(idx_frames1)]);
        else
            images(i).frameA=a(:,1:s(2)/2,idx_frames1(i));
            images(i).frameB=a(:,s(2)/2+1:end,idx_frames2(i));
        end
    end
end
end

function mean_corr=check_correlativity(images)
data=LFD_MPIV_CommandLine(images,'IntWin',128,'CumulCross',0,'export_filename','');
mean_corr=squeeze(mean(mean(data.s2n,1),2));
end