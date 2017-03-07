function [data,parameters]=vector_field_determination(correlation,data,parameters,is_it_last);
     

    if nargin<4
        is_it_last=0;
    end
    
    try
        s2n_threshold=parameters.s2n;
    catch
        s2n_threshold=1;
    end
    
    

    IntWin=parameters.IntWin(parameters.current_pass);
    minix= parameters.minix;
    maxix= parameters.maxix;
    miniy=parameters.miniy;
    maxiy=parameters.maxiy;
    step=parameters.Step(parameters.current_pass);

    %% Normalize result
    minres = permute(repmat(squeeze(min(min(correlation))), [1, size(correlation, 1), size(correlation, 2)]), [2 3 1]);
    deltares = permute(repmat(squeeze(max(max(correlation))-min(min(correlation))), [1, size(correlation, 1), size(correlation, 2)]), [2 3 1]);
    correlation = ((correlation-minres)./deltares)*255;

    %% Find first and second peak
    [x1,y1,index1,x2,y2,index2,s2n]=find_all_displacement(correlation);


    %% Sub-pixel determination

    if (rem(IntWin,2) == 0) %for the subpixel displacement measurement
        SubPixOffset=1;
    else
        SubPixOffset=0.5;
    end

    if parameters.SubPixMode==1
        [vector] = SUBPIXGAUSS (correlation,IntWin, x1, y1, index1,SubPixOffset);
    elseif parameters.SubPixMode==2 %% prone to errors
        [vector] = SUBPIX2DGAUSS (correlation,IntWin, x1, y1, index1,SubPixOffset);
    end
    
    
    
    %% Create data 
    
    data_empty=1;
    if ~isempty(data)
        data_empty=0;
    end
 
    
    
    data.x = repmat((minix:step:maxix)+IntWin/2, length(miniy:step:maxiy), 1);
    data.y = repmat(((miniy:step:maxiy)+IntWin/2)', 1, length(minix:step:maxix));
    vector = permute(reshape(vector, [size(data.x') 2]), [2 1 3]);
    
     
    
    s2n=s2n(reshape((1:numel(data.x)),size(data.x,2),size(data.x,1)))';
    
    %% signal to noise filter
    if is_it_last
    vector(:,:,1)=vector(:,:,1).*(s2n>s2n_threshold);
    vector(:,:,2)=vector(:,:,2).*(s2n>s2n_threshold);
    end
    
    %% assignement
    if ~data_empty
        
        data.u=data.u + vector(:,:,1);
        data.v=data.v + vector(:,:,2);
    else
        data.u=vector(:,:,1);
        data.v=vector(:,:,2);
    end
    data.x = repmat((minix:step:maxix)+IntWin/2, length(miniy:step:maxiy), 1);
    data.y = repmat(((miniy:step:maxiy)+IntWin/2)', 1, length(minix:step:maxix));
    data.s2n=s2n;
    
    if parameters.current_pass==length(parameters.IntWin)
        data.x=data.x-IntWin/2;
        data.y=data.y-IntWin/2;
    end
    
end
   

function [vector] = SUBPIXGAUSS(result_conv, IntWin, x, y, idx, SubPixOffset)
    z= (1:length(idx))';
    xi = find(~((x <= (size(result_conv,2)-1)) & (y <= (size(result_conv,1)-1)) & (x >= 2) & (y >= 2)));
    x(xi) = [];
    y(xi) = [];
    z(xi) = [];
    xmax = size(result_conv, 2);
    vector = NaN(size(result_conv,3), 2);
  
    if(numel(x)~=0)
        ip = sub2ind(size(result_conv), y, x, z);
        
        %the following 8 lines are copyright (c) 1998, Uri Shavit, Roi Gurka, Alex Liberzon, Technion � Israel Institute of Technology
        %http://urapiv.wordpress.com
        f0 = log(result_conv(ip));
        f1 = log(result_conv(ip-1));
        f2 = log(result_conv(ip+1));
        peaky = y + (f1-f2)./(2*f1-4*f0+2*f2);
        f0 = log(result_conv(ip));
        f1 = log(result_conv(ip-xmax));
        f2 = log(result_conv(ip+xmax));
        peakx = x + (f1-f2)./(2*f1-4*f0+2*f2);

        SubpixelX=peakx-(IntWin/2)-SubPixOffset;
        SubpixelY=peaky-(IntWin/2)-SubPixOffset;
        vector(z, :) = [SubpixelX, SubpixelY];  
    end
end
    
    function [vector] = SUBPIX2DGAUSS(result_conv, IntWin, x, y, idx, SubPixOffset)
    xi = find(~((x <= (size(result_conv,2)-1)) & (y <= (size(result_conv,1)-1)) & (x >= 2) & (y >= 2)));
    x(xi) = [];
    y(xi) = [];
    z(xi) = [];
    xmax = size(result_conv, 2);
    vector = NaN(size(result_conv,3), 2);
    if(numel(x)~=0)
        c10 = zeros(3,3, length(z));
        c01 = c10;
        c11 = c10;
        c20 = c10;
        c02 = c10;
        ip = sub2ind(size(result_conv), y, x, z);

        for i = -1:1
            for j = -1:1
                %following 15 lines based on
                %H. Nobach � M. Honkanen (2005)
                %Two-dimensional Gaussian regression for sub-pixel displacement
                %estimation in particle image velocimetry or particle position
                %estimation in particle tracking velocimetry
                %Experiments in Fluids (2005) 38: 511�515
                c10(j+2,i+2, :) = i*log(result_conv(ip+xmax*i+j));
                c01(j+2,i+2, :) = j*log(result_conv(ip+xmax*i+j));
                c11(j+2,i+2, :) = i*j*log(result_conv(ip+xmax*i+j));
                c20(j+2,i+2, :) = (3*i^2-2)*log(result_conv(ip+xmax*i+j));
                c02(j+2,i+2, :) = (3*j^2-2)*log(result_conv(ip+xmax*i+j));
                %c00(j+2,i+2)=(5-3*i^2-3*j^2)*log(result_conv_norm(maxY+j, maxX+i));
            end
        end
        c10 = (1/6)*sum(sum(c10));
        c01 = (1/6)*sum(sum(c01));
        c11 = (1/4)*sum(sum(c11));
        c20 = (1/6)*sum(sum(c20));
        c02 = (1/6)*sum(sum(c02));
        %c00=(1/9)*sum(sum(c00));

        deltax = squeeze((c11.*c01-2*c10.*c02)./(4*c20.*c02-c11.^2));
        deltay = squeeze((c11.*c10-2*c01.*c20)./(4*c20.*c02-c11.^2));
        peakx = x+deltax;
        peaky = y+deltay;

        SubpixelX = peakx-(IntWin/2)-SubPixOffset;
        SubpixelY = peaky-(IntWin/2)-SubPixOffset;

        vector(z, :) = [SubpixelX, SubpixelY];
    end
    end
    
  