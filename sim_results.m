%% Simulation 
simout = sim('RPP.slx');

%% Results 
figure;
% Quỹ đạo di chuyển (Robot's trajectory)
bg_image = imread('layout.png');
% real dimension 
X_max = 28.8; % m
Y_max = 22.4; % m
imshow(bg_image, 'XData', [0, X_max], 'YData', [Y_max, 0]);
axis on; 
set(gca, 'YDir', 'normal'); 
hold on;
plot(WP(:,1), WP(:,2), 'r--', 'LineWidth', 2.0); hold on;
plot(simout.position_x, simout.position_y, "b", 'LineWidth', 1.5); 
xlabel('x (m)'); 
ylabel('y (m)');
title("(a) Robot's Trajectory");
legend('WP', "Robot's Trajectory", 'Location', 'best');
grid on;
axis equal;
xlim([0 X_max]);
ylim([0 Y_max]);

figure;
% Quỹ đạo di chuyển (Robot's trajectory)
bg_image = imread('layout_inf.png');
% real dimension 
X_max = 28.8; % m
Y_max = 22.4; % m
imshow(bg_image, 'XData', [0, X_max], 'YData', [Y_max, 0]);
axis on; 
set(gca, 'YDir', 'normal'); 
hold on;
plot(WP(:,1), WP(:,2), 'r--', 'LineWidth', 2.0); hold on;
xlabel('x (m)'); 
ylabel('y (m)');
legend('WP', 'Location', 'best');
grid on;
axis equal;
xlim([0 X_max]);
ylim([0 Y_max]);

figure;
% (a) Sai số bám quỹ đạo (Cross-track error)
subplot(3, 1, 1);
n_ct = min(length(simout.tout), length(simout.cross_track)); % Đồng bộ kích thước
plot(simout.tout(1:n_ct), simout.cross_track(1:n_ct), "Blue", 'LineWidth', 1); 
xlabel('Time (s)'); 
ylabel('Cross\_track (m)'); 
title('(a) Cross-track error');
grid on;
axis tight;

% (b) Vận tốc dài (Linear velocity)
subplot(3, 1, 2);
n_v = min(length(simout.tout), length(simout.v)); % Đồng bộ kích thước
plot(simout.tout(1:n_v), simout.v(1:n_v), "Blue", 'LineWidth', 1); 
xlabel('Time (s)');
ylabel('v (m/s)'); 
title('(b) Linear velocity');
grid on;
axis tight;

% (c) Vận tốc góc (Angular velocity)
subplot(3, 1, 3);
n_w = min(length(simout.tout), length(simout.w)); % Đồng bộ kích thước
plot(simout.tout(1:n_w), simout.w(1:n_w), "Blue", 'LineWidth', 1); 
xlabel('Time (s)');
ylabel('w (rad/s)'); 
title('(c) Angular velocity');
grid on;
axis tight;

%% --- TỰ ĐỘNG TÍNH TOÁN CÁC CHỈ SỐ ĐÁNH GIÁ  ---

e = simout.cross_track;
v = simout.v;
w = simout.w;
x = simout.position_x;
y = simout.position_y;
t = simout.tout; % Trục thời gian
dt = t(2) - t(1); % Thời gian lấy mẫu (0.05s)

max_v = max(abs(v));
mean_v = mean(abs(v));

max_w = max(abs(w));
mean_w = mean(abs(w));

% Lọc nhiễu NaN nếu có lúc khởi động
e(isnan(e)) = 0; v(isnan(v)) = 0; w(isnan(w)) = 0; x(isnan(x)) = 0; y(isnan(y)) = 0;
% --- NHÓM 1: TRACKING ACCURACY ---
Max_CTE = max(abs(e));
MAE_CTE = mean(abs(e));
RMSE_CTE = sqrt(mean(e.^2));
Std_CTE = std(e);

% --- NHÓM 2: CONTROL EFFORT & SMOOTHNESS ---
% Năng lượng điều khiển (RMS của vận tốc)
RMS_v = sqrt(mean(v.^2));
RMS_w = sqrt(mean(w.^2));

% Độ giật (Gia tốc trung bình) - Tính đạo hàm bậc 1
dv_dt = diff(v) / dt;
dw_dt = diff(w) / dt;
Mean_Linear_Jerk = mean(abs(dv_dt));
Mean_Angular_Jerk = mean(abs(dw_dt));

% --- NHÓM 3: GLOBAL KINEMATICS ---
% Quãng đường thực tế
dx = diff(x);
dy = diff(y);
Total_Distance = sum(sqrt(dx.^2 + dy.^2));

% Thời gian hoàn thành
Total_Time = t(end);

%% --- IN BÁO CÁO RA MÀN HÌNH ---
fprintf('\n==================================================\n');
fprintf('       BẢNG KẾT QUẢ ĐÁNH GIÁ CHẤT LƯỢNG RPP       \n');
fprintf('==================================================\n');
fprintf(' ĐỘ CHÍNH XÁC BÁM QUỸ ĐẠO (TRACKING ACCURACY)\n');
fprintf('    - Max CTE (Sai số lớn nhất)  : %.4f (m)\n', Max_CTE);
fprintf('    - MAE (Sai số trung bình)    : %.4f (m)\n', MAE_CTE);
fprintf('    - RMSE (Sai số toàn phương)  : %.4f (m)\n', RMSE_CTE);
fprintf('    - Độ lệch chuẩn sai số (Std) : %.4f (m)\n', Std_CTE);
fprintf('--------------------------------------------------\n');
fprintf(' ĐỘ ÊM ÁI VÀ NĂNG LƯỢNG (CONTROL EFFORT)\n');
fprintf('    - Năng lượng tịnh tiến (RMS v): %.4f (m/s)\n', RMS_v);
fprintf('    - Năng lượng xoay (RMS w)     : %.4f (rad/s)\n', RMS_w);
fprintf('    - Độ giật tịnh tiến trung bình: %.4f (m/s^2)\n', Mean_Linear_Jerk);
fprintf('    - Độ giật góc trung bình      : %.4f (rad/s^2)\n', Mean_Angular_Jerk);
fprintf('--------------------------------------------------\n');
fprintf(' ĐỘNG HỌC TỔNG THỂ (GLOBAL KINEMATICS)\n');
fprintf('    - Tổng quãng đường đã đi      : %.4f (m)\n', Total_Distance);
fprintf('    - Thời gian hoàn thành        : %.2f (s)\n', Total_Time);
fprintf('--------------------------------------------------\n');
fprintf(' VẬN TỐC (VELOCITY)\n');
fprintf('    - Vận tốc dài trung bình      : %.4f (m/s)\n', mean_v);
fprintf('    - Vận tốc dài lớn nhất        : %.4f (m/s)\n', max_v);
fprintf('    - Vận tốc góc trung bình      : %.4f (rad/s)\n', mean_w);
fprintf('    - Vận tốc góc lớn nhất        : %.4f (rad/s)\n', max_w);
fprintf('==================================================\n');