function [rois] = markMultipleROIs(img, app)
  
    app.TabGroup.SelectedTab = app.FGMaskTab;
    axis1 = app.UIAxes;
    axis2 = app.UIAxes2;
    axis3 = app.UIAxes3;
    type = 'Parent';

    rois = struct('count', 0, 'mask', {{}}, 'position', {{}}, 'picture', {{}}, ...
    'PW_M_cam', {{}}, 'ROI_x_min', {{}}, 'middle_mx', {{}}, 'middle_my', {{}}, 'middle_mz', {{}}, ...
    'I_new_poly', {{}}, 'PW_poly', {{}}, 'middle_mx_new', {{}}, 'middle_my_new', {{}},...
    'middle_mz_new', {{}}); %structure array to store ROIs

    %Display the image
    imshow(img, type, axis1);

    mask = false(size(img, 1), size(img, 2));

    if app.chooseForeground == true

        selectMore = 'Yes';
    
        while strcmpi(selectMore, 'Yes')
            
            h = impoly(axis1); %Selecting ROI using the impoly function
            position = wait(h); %Blocks execution of next line until double-clicked
    
            %Delete the variable if no selection made
            if isempty(position)
                delete(h);
                break;
            end
            
            %If polygon is not closed, connect last two points linearly
            if ~isequal(position(1,:), position(end,:))
                position(end+1,:) = position(1,:);
            end
    
            %Generate a binary mask from the polygon
            currentMask = poly2mask(position(:,1), position(:,2), size(img, 1), size(img, 2));
            mask = mask | currentMask;

            %Extract the region of interest using the mask
            roi = bsxfun(@times, img, cast(currentMask, class(img)));

            %Inpaint the ROI using surrounding pixels
            inpaintedRoi = inpaintExemplar(img, mask);
    
            %Store the results
            rois.mask{end+1} = currentMask;
            rois.picture{end+1} = roi;
            rois.position{end+1} = position;
            rois.count = rois.count + 1;
    
            %Prompt user if they want to select another ROI
            selectMore = questdlg('Do you want to select another ROI?', ...
                                  'Select Another ROI', ...
                                  'Yes', 'No', 'No'); %[Question; Box Title; Opt.1, Opt.2, defOpt.]
    
            close(gcf);
    
            
        end
    
        close all;
        
        %Figure for inpainted region
       
        imshow(inpaintedRoi, type, axis1);
        
        %Figure for binary mask
        h = imshow(mask, type, axis2);
        set(h, 'AlphaData', 1);
        
    
        %Figure for ROIs only
    
        C = img .* uint8(mask);
        imshow(C, type, axis3);
        app.impaintedRoi = inpaintedRoi;
    else
        app.impaintedRoi = img;
    end
    app.rois = rois;
end
