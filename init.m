clear;
clc;
close all;
%% Robot
R = 0.1;        % Wheels' radius
L = 0.6;        % distance between 2 wheels
d = 0.05;       % distance of gravity center to midpoint of 2 wheels

WP =[0 0;
     6 0;
     6 4;
     0 4;
     0 0];

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