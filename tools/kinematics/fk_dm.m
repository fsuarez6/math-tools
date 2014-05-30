function [T,D]=fk_dm(T0, k, p, tipo)
[f1,c1] = size(T0);
[f2,c2] = size(k);
[f3,c3] = size(p);
c4 = length(tipo);
if (c1 ~= 4) || (c2 ~= 3) || (c3 ~= 3) || (f2 ~= f3)
    msgbox('El tama�o de T0, k y p no es coherente','Tama�o de Matrices','error');
    return
end

if c4 ~= f2
    msgbox('El tama�o de "p" debe coincidir con los GDL','Vector de Parametros','error');
    return
end
T = eye(4);
I = eye(3);

for i=1:f2
    syms(strcat('q',num2str(i)));
    qi = eval(strcat('q',num2str(i)));
    if tipo(i)== 0  % Prismatic joint
        D(:,:,i)=simple([I qi*k(i,:)';0 0 0 1]);
    else            % Revolute joint
        R(:,:,i) = cos(qi)*I + (1-cos(qi))*k(i,:)'*k(i,:) + sin(qi)*skew(k(i,:));
        D(:,:,i) = simple([R(:,:,i) (I-R(:,:,i))*p(i,:)';0 0 0 1]);
    end
    T = T*D(:,:,i);
end
T = T*T0;