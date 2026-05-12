% csv_path = 'real/csv_data/divaovadira.csv';
% map_img = imread('real\maps\lab_map.pgm'); % Thay tên file map của bạn vào đây
% [h, w] = size(map_img);
% resolution = 0.025;     
% origin_x   = -2.07 - 0.3;    
% origin_y   = -4.89; 

csv_path = 'real/csv_data/b1.csv';
map_img = imread('real\maps\carrierbot_slam.pgm'); % Thay tên file map của bạn vào đây
[h, w] = size(map_img);
resolution = 0.025;     
origin_x   = -24.9  - 0.3;    
origin_y   = -16.6; 

data = readtable(csv_path, 'VariableNamingRule', 'preserve');
t = data.("time_s");

%% Left/Right motor velocity 
vL_cmd = data.("left_velocity_cmd");
vR_cmd = data.("right_velocity_cmd");
vL_act = data.("left_velocity_encoder");
vR_act = data.("right_velocity_encoder");

e_vL = abs(vL_cmd - vL_act);
e_vR = abs(vR_cmd - vR_act);

max_eL = max(e_vL);
mean_eL = mean(e_vL);
max_eR = max(e_vR);
mean_eR = mean(e_vR);

fprintf('    - Sai số vận tốc bánh trái trung bình      : %.4f (rps)\n', mean_eL);
fprintf('    - Sai số vận tốc bánh trái lớn nhất        : %.4f (rps)\n', max_eL);
fprintf('    - Sai số vận tốc bánh phải trung bình      : %.4f (rps)\n', mean_eR);
fprintf('    - Sai số vận tốc bánh phải lớn nhất        : %.4f (rps)\n', max_eR);

%% Trajectory 

x = data.("amcl_x");
y = data.("amcl_y");

figure('Color', 'w'); 
ax = axes;

% pixel -> m 
x_min = origin_x;
x_max = origin_x + (w * resolution);
y_min = origin_y;
y_max = origin_y + (h * resolution);

imshow(map_img, 'XData', [x_min, x_max], 'YData', [y_max, y_min]);
axis on; 
set(gca, 'YDir', 'normal'); 
hold on;

plot(x, y, 'b', 'LineWidth', 2.0); 

plot(x(1), y(1), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0 0.5 0], 'MarkerFaceColor', [0.4 1 0.4]);
plot(x(end), y(end), 'p', 'MarkerSize', 12, 'MarkerEdgeColor', [0.7 0 0], 'MarkerFaceColor', [1 0.3 0.3]);

xlabel('Tọa độ X (m)', 'FontSize', 12, 'FontWeight', 'bold'); 
ylabel('Tọa độ Y (m)', 'FontSize', 12, 'FontWeight', 'bold');
legend({'Quỹ đạo', 'Điểm xuất phát', 'Đích đến'}, 'Location', 'best');
grid on;
ax.GridAlpha = 0.3;     
ax.MinorGridAlpha = 0.1;
set(gca, 'FontSize', 11, 'FontName', 'Arial', 'Box', 'on');
axis equal; 

% xlim([min(x) - 1.5, max(x) + 1.5]); 
% ylim([min(y) - 1.5, max(y) + 1.5]);

%% Velocity Response - Left and Right Wheels
figure('Color', 'w');

% Left wheel
subplot(2, 1, 1);
plot(t, vL_cmd, 'r--', 'LineWidth', 2, 'DisplayName', 'Vận tốc yêu cầu');
hold on;
plot(t, vL_act, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Vận tốc thực');
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12);
ylabel('Vận tốc (rps)', 'FontSize', 12);
title('Đáp ứng vận tốc bánh trái', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best');
grid on;
axis tight;

% Right wheel
subplot(2, 1, 2);
plot(t, vR_cmd, 'r--', 'LineWidth', 2, 'DisplayName', 'Vận tốc yêu cầu');
hold on;
plot(t, vR_act, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Vận tốc thực');
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12);
ylabel('Vận tốc (rps)', 'FontSize', 12);
title('Đáp ứng vận tốc bánh phải', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best');
grid on;
axis tight;

%% Velocity Error - Left and Right Wheels
figure('Color', 'w');

% Left wheel error
subplot(2, 1, 1);
plot(t, e_vL, 'b-', 'LineWidth', 1.5);
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12);
ylabel('Sai số (rps)', 'FontSize', 12);
title('Sai số vận tốc bánh trái', 'FontSize', 13, 'FontWeight', 'bold');
legend(sprintf('Trung bình: %.4f (rps)\nLớn nhất: %.4f (rps)', mean_eL, max_eL), 'Location', 'best', 'FontSize', 10);
grid on;
axis tight;

% Right wheel error
subplot(2, 1, 2);
plot(t, e_vR, 'g-', 'LineWidth', 1.5);
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12);
ylabel('Sai số (rps)', 'FontSize', 12);
title('Sai số vận tốc bánh phải', 'FontSize', 13, 'FontWeight', 'bold');
legend(sprintf('Trung bình: %.4f (rps)\nLớn nhất: %.4f (rps)', mean_eR, max_eR), 'Location', 'best', 'FontSize', 10);
grid on;
axis tight;
