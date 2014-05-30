function J = geometric_jacobian(k, p, type, T, D)
    n = length(k);
    Rj = eye(3);
    Dj = eye(4);
    pe = T(1:3, 4);
    for i = 1 : n
        Rj = Rj * D(1:3, 1:3, i);
        kj = Rj * k(i,:)';
        Dj = Dj * D(:, :, i);
        pj = Dj * [p(i,:)'; 1];
        % Remove the 1 at the 4th row
        pj(4) = [];
        pj_e = pe - pj;
        if type(i) == 1  % Revolute Joint
            J(:,i) = [cross(kj,pj_e) ; kj];
        else             % Prismatic Joint
            J(:,i) = [kj ; zeros(3,1)];
        end
    end
end

