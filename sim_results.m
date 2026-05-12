%% Simulation 
simout = sim('RPP.slx');

% Lấy dữ liệu từ kết quả mô phỏng
x = simout.position_x; % Tọa độ x
y = simout.position_y; % Tọa độ y

%% Results 
fig1 = figure('Visible', 'off');
% các wp A* sinh ra 
bg_image = imread('resources/layout_inf.png');
% kích thước layout thật 
X_max = 28.8; % m
Y_max = 22.4; % m
imshow(bg_image, 'XData', [0, X_max], 'YData', [Y_max, 0]);
axis on; 
set(gca, 'YDir', 'normal'); 
hold on;
plot(WP(:,1), WP(:,2), 'r--', 'LineWidth', 2.0); hold on;
plot(x(1), y(1), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0 0.5 0], 'MarkerFaceColor', [0.4 1 0.4]);
plot(x(end), y(end), 'p', 'MarkerSize', 12, 'MarkerEdgeColor', [0.7 0 0], 'MarkerFaceColor', [1 0.3 0.3]);
xlabel('x (m)'); 
ylabel('y (m)');
legend('WP', 'Start', 'Goal', 'Location', 'best');
grid on;
axis equal;
xlim([0 X_max]);
ylim([0 Y_max]);

fig2 = figure('Visible', 'off');
% Quỹ đạo di chuyển
bg_image = imread('resources/layout.png');
% kích thước layout thật 
X_max = 28.8; % m
Y_max = 22.4; % m
imshow(bg_image, 'XData', [0, X_max], 'YData', [Y_max, 0]);
axis on; 
set(gca, 'YDir', 'normal'); 
hold on;
plot(WP(:,1), WP(:,2), 'r--', 'LineWidth', 2.0); hold on;
plot(simout.position_x, simout.position_y, "b", 'LineWidth', 1.5); 
plot(x(1), y(1), 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0 0.5 0], 'MarkerFaceColor', [0.4 1 0.4]);
plot(x(end), y(end), 'p', 'MarkerSize', 12, 'MarkerEdgeColor', [0.7 0 0], 'MarkerFaceColor', [1 0.3 0.3]);
xlabel('x (m)'); 
ylabel('y (m)');
title("(a) Robot's Trajectory");
legend('WP', "Robot's Trajectory", 'Start', 'Goal', 'Location', 'best');
grid on;
axis equal;
xlim([0 X_max]);
ylim([0 Y_max]);

fig1.Visible = 'on';
fig2.Visible = 'on';

%% --- TÍNH TOÁN SỚM CÁC CHỈ SỐ ĐÁNH GIÁ ---
e = simout.cross_track;
v = simout.v;
w = simout.w;
x = simout.position_x;
y = simout.position_y;
t = simout.tout; % Trục thời gian

% Lọc nhiễu NaN
e(isnan(e)) = 0; v(isnan(v)) = 0; w(isnan(w)) = 0; x(isnan(x)) = 0; y(isnan(y)) = 0;

% Tính toán các chỉ số
Max_CTE = max(abs(e));
MAE_CTE = mean(abs(e));
RMSE_CTE = sqrt(mean(e.^2));
Std_CTE = std(e);

figure;
% (a) Sai số bám quỹ đạo 
subplot(3, 1, 1);
n_ct = min(length(simout.tout), length(simout.cross_track));
plot(simout.tout(1:n_ct), simout.cross_track(1:n_ct), "Blue", 'LineWidth', 1); 
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12); 
ylabel('Sai số (m)', 'FontSize', 12); 
title('(a) Sai số bám quỹ đạo ', 'FontSize', 14);
grid on;
axis tight;
hold on;
text(0.65, 0.9, sprintf('- Max: %.4f (m)\n- Mean: %.4f (m)', Max_CTE, MAE_CTE), ...
    'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
    'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', 'Margin', 3);

% (b) Vận tốc tịnh tiến 
subplot(3, 1, 2);
n_v = min(length(simout.tout), length(simout.v));
plot(simout.tout(1:n_v), simout.v(1:n_v), "Blue", 'LineWidth', 1); 
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12);
ylabel('v (m/s)', 'FontSize', 12); 
title('(b) Vận tốc tịnh tiến', 'FontSize', 14);
grid on;
axis tight;

% (c) Vận tốc góc 
subplot(3, 1, 3);
n_w = min(length(simout.tout), length(simout.w)); 
plot(simout.tout(1:n_w), simout.w(1:n_w), "Blue", 'LineWidth', 1); 
set(gca, 'FontSize', 10);
xlabel('Thời gian (s)', 'FontSize', 12);
ylabel('w (rad/s)', 'FontSize', 12); 
title('(c) Vận tốc góc', 'FontSize', 14);
grid on;
axis tight;

%% --- HOÀN TẤT TÍNH TOÁN CÁC CHỈ SỐ ---
dt = t(2) - t(1); % Thời gian lấy mẫu (0.05s)
max_v = max(abs(v));
mean_v = mean(abs(v));
max_w = max(abs(w));
mean_w = mean(abs(w));

% Quãng đường thực tế
dx = diff(x);
dy = diff(y);
Total_Distance = sum(sqrt(dx.^2 + dy.^2));

% Thời gian hoàn thành
Total_Time = t(end);

%% --- IN BÁO CÁO RA MÀN HÌNH ---
fprintf(' ĐỘ CHÍNH XÁC BÁM QUỸ ĐẠO \n');
fprintf('    - Max                        : %.4f (m)\n', Max_CTE);
fprintf('    - Mean                       : %.4f (m)\n', MAE_CTE);
fprintf('    - RMSE (Sai số toàn phương)  : %.4f (m)\n', RMSE_CTE);
fprintf('    - Độ lệch chuẩn sai số       : %.4f (m)\n', Std_CTE);
fprintf('--------------------------------------------------\n');
fprintf(' ĐỘNG HỌC TỔNG THỂ \n');
fprintf('    - Tổng quãng đường đã đi      : %.4f (m)\n', Total_Distance);    
fprintf('    - Thời gian hoàn thành        : %.2f (s)\n', Total_Time);
fprintf('--------------------------------------------------\n');
fprintf(' VẬN TỐC \n');
fprintf('    - Vận tốc dài trung bình      : %.4f (m/s)\n', mean_v);
fprintf('    - Vận tốc dài lớn nhất        : %.4f (m/s)\n', max_v);
fprintf('    - Vận tốc góc trung bình      : %.4f (rad/s)\n', mean_w);
fprintf('    - Vận tốc góc lớn nhất        : %.4f (rad/s)\n', max_w);
fprintf('==================================================\n');