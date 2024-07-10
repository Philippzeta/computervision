function H = HMatrix(p1,p2)
%Stack the Blockmatrices
    P_H = [get_PH(p1,p2,1);
        get_PH(p1,p2,3);
        get_PH(p1,p2,5);
        get_PH(p1,p2,7);];
% Solve PH*h = 0 to calculate the H Matrix
    H = P_H\p2(:);
    H=H';
    H = [H(1:3);H(4:6);[H(7:8),1]];
    
    %This function builds the Blockmatrix for the point pairs to solve the
    %linear equation system 
    function P_H = get_PH(p1,p2,i)
        P_H = [blkdiag([p1(i:i+1),1],[p1(i:i+1),1]),...
            [-p1(i)*p2(i),-p1(i+1)*p2(i);-p1(i)*p2(i+1),-p1(i+1)*p2(i+1)]];
    end
end