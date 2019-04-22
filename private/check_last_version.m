function msg=check_last_version(parameters)

%% version checker
check_needed=1;
msg='';
toolbox_folder=fileparts(mfilename('fullpath'));
check_file=fullfile(toolbox_folder,'last_version_check.dat');

if exist(check_file,'file');
    last_check=importdata(check_file);
    if now-last_check.data <1
        msg=['Last version already checked in the last 24 hours.'];
        msg=sprintf('%s\nYour toolbox is %s.\n',msg,last_check.textdata{1});
        check_needed=0;
    end
end
check_needed=0;
if check_needed 
    fprintf('Checking last available stable version... ');
    actual_version=get_last_version;
    fprintf('v%3.2f\n',actual_version);
    fid=fopen(check_file,'w');
    
    
    if actual_version>str2double(parameters.release)
        Please_Update;
        fprintf(fid,'outdated %20e\n',now);
        msg=sprintf('Version %3.2f is available. Please update\n',actual_version);
    else
        msg='You are up-to-date\n';
        fprintf(fid,'up-to-date %20e\n',now);
    end
    fclose(fid);
end
end




function vnum=get_last_version()
try
    str = urlread('https://github.com/tduriez/LFD_MPIV_toolbox/blob/master/README.md');
    idx1=strfind(str,'LFD_MPIV_Toolbox v');
    idx2=strfind(str(idx1:end),'</h3>');
    vnum=str2double(char(str(idx1+18:idx1+idx2(1)-2)));
catch
    fprintf('Could not check last version. Check connectivity.\n');
    vnum=0;
end
end
    