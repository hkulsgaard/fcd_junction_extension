function [convolved_img, binary_img] = get_convolution(imgBrain, imgGM, imgWM, stdFactor, kernel_size)
 
    %huppertz2015 > junction map > Step 3 - Conversion to binary image
    t_lower_tresh = mean(imgBrain(imgGM(:)>0.49)) + stdFactor * std(imgBrain(imgGM(:)>0.49));
    t_upper_tresh = mean(imgBrain(imgWM(:)>0.49)) - stdFactor * std(imgBrain(imgWM(:)>0.49));
    binary_img = zeros(size(imgBrain));
    binary_img(imgBrain >= t_lower_tresh & imgBrain <= t_upper_tresh) = 1;
    %t_lower_tresh = report.S.qualitymeasures.tissue_mnr(3) + 0.5 * report.S.qualitymeasures.tissue_stdr(3);
    %t_upper_tresh = report.S.qualitymeasures.tissue_mnr(4) - 0.5 * report.S.qualitymeasures.tissue_stdr(4);
      
    %huppertz2015 > junction map > Step 4 - Convolution
    convolved_img = convn(binary_img,ones([kernel_size kernel_size kernel_size]),'same');
    convolved_img = convolved_img/100;
    
    %for i=40:2:75
        %imshow(junction_img(:,:,i),[min(junction_img(:)) max(junction_img(:))])
        %pause(0.25)
    %end
end

