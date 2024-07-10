%Input parameters:
%I: input image.
%i: Select the corresponding RIO to operate through index i
%H_middle: 3x3 perspective transformation matrix.

%Output parameters:
%I_new_middle: the new image area after transformation.

function [I_new_poly] = foregroundObjImg(I, i, H_middle, app)
    % Get the RIO's mask selected by the user
    mask = app.rois.mask{i};
    
    %Extracts the red, green, and blue channels in image region I. 
    % Flatten the extracted region into a column vector and convert to double type.
    I1 = I(:, :, 1);
    I2 = I(:, :, 2);
    I3 = I(:, :, 3);
    [y,x] = find(mask);
    I1_poly = double(I1(mask));
    I2_poly = double(I2(mask));
    I3_poly = double(I3(mask));
    I1_poly = I1_poly(:);
    I2_poly = I2_poly(:);
    I3_poly = I3_poly(:);    
    % Constructing the chi-square coordinate matrix
    p_Ixy_poly = [x'; y'];
    p_Ixy_poly(3, :) = 1;
    %Perform Projective Transformations
    PW_poly = H_middle * p_Ixy_poly;
    PW_poly(1, :) = PW_poly(1, :) ./ PW_poly(3, :);
    PW_poly(2, :) = PW_poly(2, :) ./ PW_poly(3, :);
    PW_poly(3, :) = PW_poly(3, :) ./ PW_poly(3, :);
    % 
    % change = abs(min([min(PW_poly(1, :)), min(PW_poly(2, :))])) + 1;
    % 
    % I_new_poly = zeros(round(max(PW_poly(2, :)) + change), round(max(PW_poly(1, :)) + change), 3);
   
    % PW_poly(1, :) = PW_poly(1, :) - min(PW_poly(1, :)) + 1;
    % PW_poly(2, :) = PW_poly(2, :) - min(PW_poly(2, :)) + 1;

     % Construct new image matrix
    new_width = round(max(PW_poly(1, :) - min(PW_poly(1, :)) + 1));
    new_height = round(max(PW_poly(2, :) - min(PW_poly(2, :)) + 1));
    I_new_poly = zeros(new_height, new_width, 4);

    %Create a mask for the transformed polygon
    % transformed_mask = false(new_height, new_width);
    % for k = 1:length(PW_poly)
    %     transformed_mask(round(PW_poly(2, :) - min(PW_poly(2, :)) + 1), round(PW_poly(1, :) - min(PW_poly(1, :)) + 1)) = true;
    % end
    % figure;
    % imshow(transformed_mask);
    % title('Transformed Mask');
    
    %Calculate coordinate offsets and populate new image
    for NUM = 1:length(x)
        x_d = round(PW_poly(1, NUM)- min(PW_poly(1, :)) + 1);
        y_d = round(PW_poly(2, NUM)- min(PW_poly(2, :)) + 1);
            I_new_poly(x_d, y_d, 1) = I1_poly(NUM);
            I_new_poly(x_d, y_d, 2) = I2_poly(NUM);
            I_new_poly(x_d, y_d, 3) = I3_poly(NUM);
            I_new_poly(x_d, y_d, 4) = 255;
    end

    %Crop the image to the bounding box of the polygon
    % [row, col] = find(transformed_mask);
    % I_new_poly = I_new_poly(min(row):max(row), min(col):max(col), :);

    I_new_poly = uint8(I_new_poly);
    mask_interpolation = I_new_poly(:, :, 1) == 0; 
    I_new_poly(:, :, 1:3) = inpaintCoherent(I_new_poly(:, :, 1:3), mask_interpolation);
    app.rois.I_new_poly{i} = I_new_poly;
    app.rois.PW_poly{i} = PW_poly;
    % figure
    % f= imshow(I_new_poly(:, :, 1:3));
    % set(f, 'AlphaData', I_new_poly(:, :, 4));
    % title('Transformed Polygon Region1');
    
    end