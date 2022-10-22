function enhanced_bundle = enhance_image(image_bundle)
%ENHANCE_IMAGE Remove some motion blur from images
%   Enhance images by using a radial filter to sharpened the particles.
%   This function use GPU Accelaration. 
%   

enhanced_bundle = zeros(size(image_bundle), class(image_bundle));
image_bundle = gpuArray(squeeze(image_bundle));
n = size(image_bundle,3);
%% radial kernel
for it = 1:n
    current_image = image_bundle(:,:,it);
    H = fspecial('disk',10);
    blurred_gray = imfilter(current_image,H,'replicate');
    k=2; % filter gain
    gray_enhanced = current_image + k.*(current_image - blurred_gray);
    enhanced_bundle(:,:,it) = gather(gray_enhanced);
end
end