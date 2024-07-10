function [ Rotation ] = R_matrix( seta_1,seta_2,seta_3 )

    x=[1 0 0;0 cosd(seta_1) sind(seta_1);0 -sind(seta_1) cosd(seta_1)];
    y=[cosd(seta_2) 0 -sind(seta_2);0 1 0;sind(seta_2) 0 cosd(seta_2)];
    z=[cosd(seta_3) sind(seta_3) 0;-sind(seta_3) cosd(seta_3) 0;0 0 1];
    Rotation =z*y*x;

end