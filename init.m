clear;
clc;
close all;
%% Robot
R = 0.1;        % Wheels' radius
L = 0.3;        % 1/2 distance between 2 wheels
d = 0.05;       % distance of gravity center to midpoint of 2 wheels

WP =[0 0;
     6 0;
     6 4;
     0 4;
     0 0];

%% Motor
a1 = 0.9;
a2 = 0.9;
b1 = 0.9;
b2 = 0.9;
g = 9.81;

%% Robustness
m_add = 0;      %kg
time_add = 0;