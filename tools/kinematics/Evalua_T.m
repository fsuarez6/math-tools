function [T]=Evalua_T(T0, q, d, a)
[f,c] = size(T0);
[fq,cq] = size(q);
[fd,cd] = size(d);
[fa,ca] = size(a);
if (c ~= 4) || (f ~= 4)
    msgbox('El tama�o de T0 no es coherente','Tama�o de Matrices','error');
    return
end
for i = 1 : cq
    eval(strcat('q',num2str(i),'=q(',num2str(i),');'));
end
for i = 1 : cd
    eval(strcat('d',num2str(i),'=d(',num2str(i),');'));
end
for i = 1 : ca
    eval(strcat('a',num2str(i),'=a(',num2str(i),');'));
end
T = subs(T0);