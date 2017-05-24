function LFD_MPIV_Daemon(the_folder)
    if nargin<1
        the_folder=uigetdir;
    end
    
    fprintf('LFD MPIV Daemon\n');
    
    fprintf('Intialisation......');
    known_cxd=check_directory(the_folder,{},1);
    fprintf('%d cxd files already present.\n',length(known_cxd));
    
    figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal',...
       'position',[50 50 800 400])
   subplot(1,2,2);
   subplot(1,2,1);
    fprintf('Daemon started\n');
    fprintf('Focus figure and press ESC to stop.\n');
    title('Waiting for next cxd');
    while  double(get(gcf,'CurrentCharacter'))~=27
        known_cxd=check_directory(the_folder,known_cxd,0);
        pause(1);
    end
    fprintf('Closing daemon\n')
    close(gcf)
end
    
    
    
    


function known_cxd=check_directory(the_folder,known_cxd,init)
    d=dir(fullfile(the_folder,'*.cxd'));
    present_cxd=cell(1,length(d));
    for i=1:length(d)
        present_cxd{i}=d(i).name;
    end
    
    
    if init==1
        known_cxd=present_cxd;
        return
    end
    
    
    new_cxd=setdiff(present_cxd,known_cxd);
    
    
    if isempty(new_cxd)
        return
    end
    if length(new_cxd)>1
        fprintf('More than one new CXD\nReading the last one...\nWhat the heck are you doing ?\n')
    end
    
    display_cxd=new_cxd{end};
    fprintf('Detected new cxd: %s\n',display_cxd);
    
    check_size(display_cxd);
    
    title(display_cxd);
    quick_PIV(fullfile(the_folder,display_cxd));
    
    known_cxd=present_cxd;
end
    
function check_size(cxd)
end

function quick_PIV(cxd_file)
    data=LFD_MPIV_CommandLine(cxd_file,'image_indices',2,'IntWin',64,'Verbose',0,'background','none');
    subplot(1,2,2);
    desp=sqrt(data.u.^2+data.v.^2);
    hist(desp(:),1000);
    subplot(1,2,1);
    
    
    
end