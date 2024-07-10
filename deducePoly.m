function [poly_ceiling, poly_left, poly_right, poly_floor] = deducePoly(topL, topR, bottomL, bottomR, int_im_topL, int_im_topR, int_im_bottomL, int_im_bottomR, size_im)
    %deducePoly(topL, topR, bottomL, bottomR, int_im_topL, int_im_topR, int_im_bottomL, int_im_bottomR, size_im)

    %% Initialise 
    %Image
    im_topL = [1,1];
    im_bottomL = [1,size_im(1)];
    im_topR = [size_im(2), 1];
    im_bottomR = [size_im(2),size_im(1)];

    %Arrays to store polygon coordinates
    poly_ceiling =[topL; topR];
    poly_left = [topL; bottomL];
    poly_right = [topR; bottomR];
    poly_floor = [bottomL; bottomR];

    %% Allocate the coordinates to the correct polygon array

    %Top Left
    if int_im_topL(2) == 1
       poly_ceiling =[poly_ceiling; int_im_topL];
       poly_left = [poly_left; im_topL; int_im_topL;];
    else
       poly_ceiling =[poly_ceiling; int_im_topL; im_topL];
       poly_left = [poly_left; int_im_topL];
    end

    %Top Right
    if int_im_topR(2) == 1
       poly_ceiling =[poly_ceiling; int_im_topR];
       poly_right = [poly_right; im_topR; int_im_topR];
    else
       poly_ceiling =[poly_ceiling; im_topR; int_im_topR];
       poly_right = [poly_right; int_im_topR];
    end

    %Bottom Left
    if int_im_bottomL(1) == 1
       poly_floor =[poly_floor; int_im_bottomL; im_bottomL];
       poly_left = [poly_left; int_im_bottomL;];
    else
       poly_floor = [poly_floor; int_im_bottomL;];
       poly_left = [poly_left; int_im_bottomL; im_bottomL];
    end

    %Bottom Right
    if int_im_bottomR(1) >= size_im(2)
       poly_floor =[poly_floor; int_im_bottomR; im_bottomR ];
       poly_right = [poly_right; int_im_bottomR];
    else
       poly_floor = [poly_floor; int_im_bottomR];
       poly_right = [poly_right; int_im_bottomR; im_bottomR];
    end

end