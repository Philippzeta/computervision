function x2_cam = make_Projection( P_1_hom,PW,value_depth,R,T )

    R_T=[R,T;0 0 0 1];
    pi_0=[1 0 0 0;0 1 0 0;0 0 1 0];
    K=[value_depth 0 0;0 value_depth 0;0 0 1];
    x2_repro=K*pi_0*R_T*P_1_hom;
    remain_x2=find(x2_repro(3,:)>1);
    x2_repro_remain=x2_repro(:,remain_x2);
    PW_remain=PW(:,remain_x2);
    x2_repro_norm=x2_repro_remain./x2_repro_remain(3,:);
    x2_cam=round(x2_repro_norm(1:2,:));
    x2_cam(3,:)=1;
    x2_cam(4,:)=PW_remain(4,:); 
    x2_cam(5,:)=PW_remain(5,:);
    x2_cam(6,:)=PW_remain(6,:);
    
end