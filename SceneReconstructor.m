function depths = SceneReconstructor(app)
    %% Extract variables from the app
    %Vanishing Point
    vanishingPoint_x = app.vanishing_Point.Position(1); % x-coord of VP
    vanishingPoint_y = app.vanishing_Point.Position(2); % y-coord of VP

    %Corners of the background rectangle
    topL = app.Rectanglecorners.top_left; % in the format [x,y]
    topR = app.Rectanglecorners.top_right; % in the format [x,y]
    bottomL = app.Rectanglecorners.bottom_left; % in the format [x,y]
    bottomR = app.Rectanglecorners.bottom_right; % in the format [x,y]

    %Intersection points with the image
    int_im_topL = app.Intersectionpoints.top_left; % in the format [x,y]
    int_im_topR = app.Intersectionpoints.top_right; % in the format [x,y]
    int_im_bottomL = app.Intersectionpoints.bottom_left; % in the format [x,y]
    int_im_bottomR = app.Intersectionpoints.bottom_right; % in the format [x,y]

    %Image
    im = app.imagedata; %image itself with all colour channels, [x,y,3] type uint8 
    imageDimensions = [size(im, 1), size(im, 2)]; % dimensions of the image[x,y]
    

    %% Computing the coordinates of the polygons
    
    [PC PL PR PF] = deducePoly(topL, topR, bottomL, bottomR, int_im_topL, int_im_topR, int_im_bottomL, int_im_bottomR, imageDimensions)

    %PC refers to the ceiling polygon, PF is floor, PL is left wall and PR
    %is right wall. Next step is to define the ceiling, left, right, floor
    %and background rectangles (see how we will compute their lengths using
    %depth, perhaps).

    %I have computed the coordinates slightly different than how it says in
    %the paper. Instead of going out of the image, I have defined all
    %points within the image. In this case the outermost point will be the
    %corner of the image. I think it will work just as fine.

    %After we have the rectangles, we will warp the polygonal sections with
    %the image texture on the rectangles and then plot the rectangles as
    %separate planes on a 3D plot. This should conclude the background 3D
    %reconstruction.