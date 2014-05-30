function M = skew(k)
kx=k(1);
ky=k(2);
kz=k(3);
M = [0 -kz ky;kz 0 -kx;-ky kx 0];