clear;
clc;
close all;

%% RPP parameters 
desired_linear_vel = 1.0;
max_linear_accel = 1.5;
max_linear_decel = 1.5;

min_lookahead_dist = 0.3;
max_lookahead_dist = 0.9;
lookahead_time = 0.5;

rotate_to_heading_angular_vel = 3.0;

regulated_linear_scaling_min_radius = 0.9;
regulated_linear_scaling_min_speed = 0.2;

max_angular_accel = 4.0;
goal_dist_tol = 0.05;

%% Occupancy for A* 
load('binaryOccupancy.mat');

% resolution = 40; % 40 cells/m, 0.025m/pixel
% robot_radius = 0.35;
% safety_margin = 0.25;
% % inflation radius 
% inf_rad = robot_radius + safety_margin;
% 
% % img processing 
% bw_image = imread(map_name);
% if size(bw_image, 3) == 3
%     bw_image = rgb2gray(bw_image); 
% end
% bw_image = imbinarize(bw_image);
% 
% %  occupancy Map (NOT img: ~bw_image cause 1 is obstacle)
% map = binaryOccupancyMap(~bw_image, resolution);

% % inflation map for A* 
% map_inf = copy(map);
% inflate(map_inf, inf_rad);

% inflated_matrix = occupancyMatrix(map_inf);
% image_to_save = ~inflated_matrix;
% imwrite(image_to_save, 'layout_inf.png');
% save('binaryOccupancy.mat', 'map', 'map_inf');
% 
% figure;
% % Dùng hàm show tích hợp sẵn của binaryOccupancyMap để vẽ bản đồ
% show(map);
% grid on;
% grid minor; % Bật thêm lưới nhỏ cho chi tiết 
% xlabel('Trục X (m)');
% ylabel('Trục Y (m)');
% exportgraphics(gcf, 'layout_grid.png', 'Resolution', 300);

%% Robot
R = 0.173;        % Wheels' radius
L = 0.411;        % distance between 2 wheels
d = 0.116;       % distance of gravity center to midpoint of 2 wheels

% m 
start_pose = [9.95, 7.65];    
goal_pose  = [25.15, 15.3];

%% Motor
load('motor_data.mat');
[num_left, den_left] = tfdata(tf_left, 'v');
[num_right, den_right] = tfdata(tf_right, 'v');
Ts_motor = 0.05;
g = 9.81;

%% Robustness
m_add = 0;      %kg
time_add = 0;
disp('Init done')