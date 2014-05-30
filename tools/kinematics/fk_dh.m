function [T,A]=fk_dh(DH)

[f,c] = size(DH);
if c ~= 4
    msgbox('La matriz DH debe tener 4 columnas','Tama�o Matriz DH','error');
    return
end

T = eye(4);
for i=1:f
    theta = DH(i,1);
    d = DH(i,2);
    a = DH(i,3);
    alfa = DH(i,4);
    A(:,:,i)=[cos(theta) -cos(alfa)*sin(theta) sin(alfa)*sin(theta) a*cos(theta);
        sin(theta) cos(alfa)*cos(theta) -sin(alfa)*cos(theta) a*sin(theta);
        0 sin(alfa) cos(alfa) d;
        0 0 0 1];
    T= T*A(:,:,i);
end