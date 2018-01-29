function thetimes=get_times(cxdfile)
    bfpackage_path='d:\20171227\bftools\bftools';
    bfpackfile=fullfile(bfpackage_path,'bioformats_package.jar');
    infotool='loci.formats.tools.ImageInfo';
    outputfile='filedatabase.txt';
    
    system(sprintf('java -cp %s %s %s -nopix > %s',strrep(bfpackfile,'\','\\'),infotool,cxdfile,outputfile));
    
    fid=fopen(outputfile);
    a=1;
    thetimes=[];
    while a~=-1
        a=fgetl(fid);
        if ~isempty(strfind(a,'Field'))
            if ~isempty(strfind(a,'Time_From_Start'))
                idx1=strfind(a,'Field');
                idx2=strfind(a,'Time_From_Start');
                idx3=strfind(a,':');
                thetimes(str2double(a(idx1+5:idx2-1)))=str2double(a(idx3+1:end));
            end
        end
        if isempty(a)
            a=1;
        end
            
    end
    fclose(fid);
    delete(outputfile);