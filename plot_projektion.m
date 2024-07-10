function view  = plot_projektion( I,v_x,v_y,cam )
    cam(1,:)=cam(1,:)+round(size(I,1)-v_y);
    cam(2,:)=cam(2,:)+round(v_x); 
    view=zeros(size(I,2),size(I,1),3);
    for i=1:size(cam,2)
        if 1<=cam(1,i) && cam(1,i)<=size(I,1) && 1<=cam(2,i) && cam(2,i)<=size(I,2)
            view(cam(2,i),cam(1,i),1) = cam(4,i);
            view(cam(2,i),cam(1,i),2) = cam(5,i);
            view(cam(2,i),cam(1,i),3) = cam(6,i);
        end
    end
    view=uint8(view);
end