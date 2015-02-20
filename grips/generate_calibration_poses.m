%~ Data from manufacturer manual (http://support.robotiq.com/display/IMB/6.4+Moment+of+inertia+and+center+of+mass)
%~ mass: 2.3 Kg
%~ center of mass: [-8 0 65] mm
%~ Inertia: Kg.mm^2
%~ Ixx: 7300
%~ Ixy: 0
%~ Ixz: -650
%~ Iyy: 8800
%~ Iyz: 0
%~ Izz: 7000
%~ Inertia:       [Ixx,     Ixy,    Ixz,      Iyy,      Iyz,    Izz]
%~ gripper_inertia:  [7300e-6, 0,      -650e-6,  8800e-6,  0,      7000e-6]
%~ 
%~ Real measurements
%~ FT Sensor: 1.4 N
%~ Acople:    1.4 N
%~ Robotiq:   23.3 N

path = '~/catkin_ws/src/grips/grips_ft_sensor/config';
% main loop frequency [Hz] (should be as fast as F/T sensor publish frequency)
data.loop_rate = 1000.0;
% waiting time after moving to each pose before taking F/T measurements
data.wait_time = 2.0;
% Name of the moveit group
data.moveit_group_name = 'arm';
% Name of the calib file
data.calib_file_name = 'ft_calibrated_data.yaml';

% Name of the directory
data.calib_file_dir = path;

% don't execute random poses
data.random_poses = false;

% number of random poses
data.number_random_poses = 0;

% the poses to which to move the arm in order to calibrate the F/T sensor
% format: [x y z r p y]  in meters, radians
% poses_frame_id sets the frame at which the poses are expressed
data.poses_frame_id = 'base_link';

% Poses are stored as: [x y z r p y] in meters, radians
data.pose0 = [0.25,   0.5,    0.5     0     0     0];
data.pose1 = [0.0,    0.5,    0.5     0     0     0];
data.pose2 = [0.0,    0.5,    0.5     0     0     0];

WriteYaml([path '/ft_calibration_poses.yaml'],data);
