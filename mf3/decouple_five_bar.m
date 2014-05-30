q3 = 0.73;
alpha4 = -1.122;
L1 = 150;
L2 = 60;
L3 = 100;
L4 = 40;
d = 40;
right = true;

if right
    q3 = -q3;
    alpha4 = -alpha4;
end

phi = q3 + pi/2;
theta = alpha4 + pi/2;

x1 = L1 * cos(phi);
y1 = L1 * sin(phi);
x2 = L4 * cos(theta);
y2 = d + (L4 * sin(theta));
beta = atan2(y2-y1, x1-x2);
L5 = sqrt((x1-x2)^2 + (y1-y2)^2);
gamma = acos((L3^2 - L5^2 - L2^2)/(2*L5*L2));
psi = gamma - beta - phi
q4 = psi - pi/2;
if right
    q4 = -q4;
end
q4