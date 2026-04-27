%% Simulation 
simout = sim('RPP.slx');

%% Results 
% FIGURE 1: QUỸ ĐẠO DI CHUYỂN (a)
figure('Name', 'Trajectory', 'Color', 'w');
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

% =========================================================================

% FIGURE 2: CÁC THÔNG SỐ ĐỘNG HỌC & ĐIỀU KHIỂN (Gồm 4 đồ thị con)
figure('Name', 'Kinematic Performance', 'Color', 'w');

% (b) Sai số bám quỹ đạo (Cross-track error)
subplot(2, 2, 1);
n_ct = min(length(simout.tout), length(simout.cross_track)); % Đồng bộ kích thước
plot(simout.tout(1:n_ct), simout.cross_track(1:n_ct), "Blue", 'LineWidth', 1); 
xlabel('Time (s)'); 
ylabel('Cross\_track (m)'); 
title('(b) Cross-track error');
grid on;

% (c) Đáp ứng góc hướng (Heading angle)
subplot(2, 2, 2);
n_psi = min(length(simout.tout), length(simout.psi_d)); % Đồng bộ kích thước
n_theta = min(length(simout.tout), length(simout.theta)); % Đồng bộ kích thước
plot(simout.tout(1:n_psi), simout.psi_d(1:n_psi), "Blue--", 'LineWidth', 1); hold on;
plot(simout.tout(1:n_theta), simout.theta(1:n_theta), "Green", 'LineWidth', 1); 
xlabel('Time (s)');
ylabel('Angle (rad)'); 
title('(c) Heading response');
legend('\psi_d (Expected)', '\theta (Actual)', 'Location', 'best');
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