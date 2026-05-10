data = readtable('divaovadira.csv', 'VariableNamingRule', 'preserve');
t = data.("time_s");

%% Left/Right motor velocity 
vL_cmd = data.("left_velocity (rps)");
vR_cmd = data.("right_velocity (rps)");
vL_act = data.("left_rps");
vR_act = data.("right_rps");

e_vL = abs(vL_cmd - vL_act);
e_vR = abs(vR_cmd - vR_act);

max_eL = max(e_vL);
mean_eL = mean(e_vL);
max_eR = max(e_vR);
mean_eR = mean(e_vR);

fprintf('    - Sai số vận tốc dài bánh trái trung bình      : %.4f (m/s)\n', mean_eL);
fprintf('    - Sai số vận tốc dài bánh trái lớn nhất        : %.4f (m/s)\n', max_eL);
fprintf('    - Sai số vận tốc dài bánh phải trung bình      : %.4f (rad/s)\n', mean_eR);
fprintf('    - Sai số vận tốc dài bánh phải lớn nhất        : %.4f (rad/s)\n', max_eR);

%% Trajectory 

x = data.("amcl_x");
y = data.("amcl_y");

figure('Color', 'w'); 
ax = axes;

map_img = imread('lab_map.pgm'); % Thay tên file map của bạn vào đây
[h, w] = size(map_img);

resolution = 0.025;     
origin_x   = -2.07 - 0.3;    
origin_y   = -4.89;   

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

xlim([min(x) - 1.5, max(x) + 1.5]); 
ylim([min(y) - 1.5, max(y) + 1.5]);
