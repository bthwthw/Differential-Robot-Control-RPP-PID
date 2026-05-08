clear;
clc;
close all;
%% Waypoint
% % Rectangle 
% WP =[0 0;
%      6 0;
%      6 4;
%      0 4;
%      0 0];


WP =[0 0;
     5 0;
     5 10];

%% Robot
R = 0.173;        % Wheels' radius
L = 0.411;        % distance between 2 wheels
d = 0.116;       % distance of gravity center to midpoint of 2 wheels

x_0 = 0;      % initial X, Y, theta of robot 
y_0 = 0;       
theta_0 = 0;

%% Motor
load('motor_data.mat');
[num_left, den_left] = tfdata(tf_left, 'v');
[num_right, den_right] = tfdata(tf_right, 'v');
Ts_motor = 0.05;
g = 9.81;

%% Robustness
m_add = 0;      %kg
time_add = 0;