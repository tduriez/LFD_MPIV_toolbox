function vnum=check_last_version()
    websave('version_check.html','https://github.com/tduriez/LFD_MPIV_toolbox/blob/master/README.md')
    fid=fopen('version_check.html');
    a=fread(fid);
    fclose(fid);
    delete('version_check.html');
    idx1=strfind(a','LFD_MPIV_Toolbox v');
    idx2=strfind(a(idx1:end)','</h3>');
    vnum=str2double(char(a(idx1+18:idx1+idx2(1)-2)'));
    