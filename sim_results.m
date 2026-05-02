%% Simulation 
simout = sim('RPP.slx');

%% Results 
figure;

% (a) Quỹ đạo di chuyển (Robot's trajectory)
subplot(2, 2, 1);
plot(WP(1,1), WP(1,2), "bo", 'MarkerFaceColor', 'b'); hold on;
plot(WP(2,1), WP(2,2), "bo", 'MarkerFaceColor', 'b'); hold on;
plot(WP(3,1), WP(3,2), "bo", 'MarkerFaceColor', 'b'); hold on;
plot(WP(4,1), WP(4,2), "bo", 'MarkerFaceColor', 'b'); hold on;
plot(simout.position_x, simout.position_y, "Red", 'LineWidth', 1.5); 
xlabel('x (m)'); 
ylabel('y (m)');
title("(a) Robot's Trajectory");
legend('WP 1', 'WP 2', 'WP 3', 'WP 4', "Robot's Trajectory", 'Location', 'best');
grid on;
axis equal;

% (c) Sai số bám quỹ đạo (Cross-track error)
subplot(2, 2, 2);
n_ct = min(length(simout.tout), length(simout.cross_track)); % Đồng bộ kích thước
plot(simout.tout(1:n_ct), simout.cross_track(1:n_ct), "Blue", 'LineWidth', 1); 
xlabel('Time (s)'); 
ylabel('Cross\_track (m)'); 
title('(b) Cross-track error');
grid on;

% (d) Vận tốc dài (Linear velocity)
subplot(2, 2, 3);
n_v = min(length(simout.tout), length(simout.v)); % Đồng bộ kích thước
plot(simout.tout(1:n_v), simout.v(1:n_v), "Blue", 'LineWidth', 1); 
xlabel('Time (s)');
ylabel('v (m/s)'); 
title('(d) Linear velocity');
grid on;

% (e) Vận tốc góc (Angular velocity)
subplot(2, 2, 4);
n_w = min(length(simout.tout), length(simout.w)); % Đồng bộ kích thước
plot(simout.tout(1:n_w), simout.w(1:n_w), "Blue", 'LineWidth', 1); 
xlabel('Time (s)');
ylabel('w (rad/s)'); 
title('(e) Angular velocity');
grid on;

%% --- TỰ ĐỘNG TÍNH TOÁN CÁC CHỈ SỐ ĐÁNH GIÁ  ---

e = simout.cross_track;
v = simout.v;
w = simout.w;
x = simout.position_x;
y = simout.position_y;
t = simout.tout; % Trục thời gian
dt = t(2) - t(1); % Thời gian lấy mẫu (0.05s)

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
fprintf('[1] ĐỘ CHÍNH XÁC BÁM QUỸ ĐẠO (TRACKING ACCURACY)\n');
fprintf('    - Max CTE (Sai số lớn nhất)  : %.4f (m)\n', Max_CTE);
fprintf('    - MAE (Sai số trung bình)    : %.4f (m)\n', MAE_CTE);
fprintf('    - RMSE (Sai số toàn phương)  : %.4f (m)\n', RMSE_CTE);
fprintf('    - Độ lệch chuẩn sai số (Std) : %.4f (m)\n', Std_CTE);
fprintf('--------------------------------------------------\n');
fprintf('[2] ĐỘ ÊM ÁI VÀ NĂNG LƯỢNG (CONTROL EFFORT)\n');
fprintf('    - Năng lượng tịnh tiến (RMS v): %.4f (m/s)\n', RMS_v);
fprintf('    - Năng lượng xoay (RMS w)     : %.4f (rad/s)\n', RMS_w);
fprintf('    - Độ giật tịnh tiến trung bình: %.4f (m/s^2)\n', Mean_Linear_Jerk);
fprintf('    - Độ giật góc trung bình      : %.4f (rad/s^2)\n', Mean_Angular_Jerk);
fprintf('--------------------------------------------------\n');
fprintf('[3] ĐỘNG HỌC TỔNG THỂ (GLOBAL KINEMATICS)\n');
fprintf('    - Tổng quãng đường đã đi      : %.4f (m)\n', Total_Distance);
fprintf('    - Thời gian hoàn thành        : %.2f (s)\n', Total_Time);
fprintf('==================================================\n');