function [p, height_background, width_background] = coordinates_Rechnung(vp, width, height,rect_corners)

    x_coords_background = [rect_corners.top_left(1) rect_corners.bottom_right(1)];
    y_coords_background = [rect_corners.top_left(2) rect_corners.bottom_right(2)];
    x_coords_background = sort(x_coords_background);
    y_coords_background = sort(y_coords_background);
    x_coords_VP = vp.Position(1);
    y_coords_VP = vp.Position(2);
    
    %Calculate Polygon corners
    p1 = [x_coords_background(1),y_coords_background(2)];
    p2 = [x_coords_background(2),y_coords_background(2)];
    p3 = [x_coords_background(1),y_coords_background(1)];
    p4 = [x_coords_background(2),y_coords_background(1)];
    p5 = P_inter(x_coords_VP,y_coords_VP,p1(1),p1(2),'y',height);
    p6 = P_inter(x_coords_VP,y_coords_VP,x_coords_background(2),y_coords_background(2),'y',height);
    p7 = P_inter(x_coords_VP,y_coords_VP,x_coords_background(2),y_coords_background(2),'x',width);
    p8 = P_inter(x_coords_VP,y_coords_VP,p4(1),p4(2),'x',width);
    p9 = P_inter(x_coords_VP,y_coords_VP,p4(1),p4(2),'y',1);
    p11 = P_inter(x_coords_VP,y_coords_VP,x_coords_background(1),y_coords_background(1),'x',1);
    p10 = P_inter(x_coords_VP,y_coords_VP,x_coords_background(1),y_coords_background(1),'y',1);
    p12 = P_inter(x_coords_VP,y_coords_VP,p1(1),p1(2),'x',1);
    p=[p1;p2;p3;p4;p5;p6;p7;p8;p9;p10;p11;p12];

    height_background = abs(p3(2)-p1(2));
    width_background= abs(p2(1)-p1(1));

end