function [] = foregroundObjCoordinates(i, P, app)
    position = app.rois.position{i};
    original_x_coords = position(:, 1);
    original_y_coords = position(:, 2);
    PW_poly = app.rois.PW_poly{i};
    ROI_x_min = min(original_x_coords);
    ROI_y_max = max(original_y_coords);
    v_x = app.vanishing_Point.Position(1);
    v_y = app.vanishing_Point.Position(2);

    ZM = ROI_x_min/app.image_width*abs((P(1,1)-P(5,3)))*0.5-100;
    PW_M = [PW_poly;ZM*ones(size(PW_poly(1,:)))];
    PW_M(2, :) = double(PW_poly(2,:) + abs(app.p(2,2) - ROI_y_max));
    PW_M_cam(1, :) = double(PW_M(1,:)) - abs(v_x-app.p(1,1));
    PW_M_cam(2, :) = double(PW_M(2,:)) - abs(v_y-app.p(1,2));
    PW_M_cam(3, :) = ZM - app.depth;
    R_const = [0 1 0; 1 0 0; 0 0 -1];
    PW_M_cam = R_const * PW_M_cam;
    app.rois.PW_M_cam{i} = PW_M_cam;
    app.rois.ROI_x_min{i} = ROI_x_min;
end