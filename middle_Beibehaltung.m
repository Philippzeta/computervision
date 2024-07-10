%Input parameters:
%I: input image.
%p: coordinate matrix containing the coordinates of the four points in the image area.
%H_middle: 3x3 perspective transformation matrix.
%Output parameters:

%I_new_middle: the new image area after transformation.
%PW_middle: the transformed world coordinates.
%I1_middle, I2_middle, I3_middle: pixel value of RGB channel.

function [ I_new_middle,PW_middle,I1_middle,I2_middle,I3_middle] = middle_Beibehaltung( I,p,Part_middle)
%Use the meshgrid function to create a grid from p(3,1) to p(4,1) and from p(3,2) to p(1,2).
%Expand the X and Y coordinates of the mesh into column vectors
    [X,Y] = meshgrid(round(p(3,1)):round(p(4,1)),round(p(3,2)):round(p(1,2)));
    X = X(:);
    Y = Y(:);
%Extracts the red, green, and blue channels in image region I. Flatten the extracted region into a column vector and convert to double type.

    I1 = I(round(p(3,2)):round(p(1,2)),round(p(3,1)):round(p(4,1)),1);
    I1_middle = double(I1(:));
    I2= I(round(p(3,2)):round(p(1,2)),round(p(3,1)):round(p(4,1)),2);
    I2_middle = double(I2(:));
    I3 = I(round(p(3,2)):round(p(1,2)),round(p(3,1)):round(p(4,1)),3);
    I3_middle = double(I3(:));
    % Constructing the chi-square coordinate matrix
    p_Ixy_middle = [X';Y'] ;
    p_Ixy_middle(3,:) = 1;
    %Perform perspective transformations
    PW_middle = Part_middle*p_Ixy_middle;
    PW_middle(1,:)=PW_middle(1,:)./PW_middle(3,:);
    PW_middle(2,:)=PW_middle(2,:)./PW_middle(3,:);
    PW_middle(3,:)=PW_middle(3,:)./PW_middle(3,:);
   %Calculate coordinate offsets and populate new image
    change = abs(min([min(PW_middle(1,:)),min(PW_middle(2,:))]))+1;
    for NUM=1:size(PW_middle,2)
        I_new_middle(round(PW_middle(1,NUM)+change),round(PW_middle(2,NUM)+change),1) = I1_middle(NUM);
        I_new_middle(round(PW_middle(1,NUM)+change),round(PW_middle(2,NUM)+change),2) = I2_middle(NUM);
        I_new_middle(round(PW_middle(1,NUM)+change),round(PW_middle(2,NUM)+change),3) = I3_middle(NUM);
    end
   
    I_new_middle = uint8(I_new_middle);


end