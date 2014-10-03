path = '~/catkin_ws/src/grips/grips_ft_sensor/config';
% main loop frequency [Hz] (should be as fast as F/T sensor publish frequency)
data.loop_rate = 500.0;
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
data.poses_frame_id = 'world';

% Poses are stored as:
% rotation     position
% [w x y z]    [x y z]
load ikfast.mat
valid = ikfast_iterations;
poses = ikfast_poses;
i = 1;
p = 1;
while (1)
    if valid(i)
        q = Quaternion(poses(i,1:4));
        rpy_pose = [poses(i,5:7) tr2rpy(q.R)];
        rpy_pose = round(rpy_pose*1e6)/1e6;
        eval(['data.pose' num2str(p-1) '=rpy_pose;']);
        if p >= 30
            break;
        end
        p = p + 1;
    end
    i = i + 1;
end
WriteYaml([path '/ft_calibration_poses.yaml'],data);