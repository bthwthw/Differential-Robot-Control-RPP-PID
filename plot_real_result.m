% filepath: e:\Final_Battle\Matlab\Differential-Robot-Control-RPP-PID\velocity.m
% Đọc dữ liệu từ file CSV
data = readtable('csv_data\b1.csv');

% Tính sai số vận tốc
left_velocity_error = data.real_left_velocity - data.left_velocity_cmd;
right_velocity_error = data.real_right_velocity - data.right_velocity_cmd;

% Tính sai số lớn nhất và trung bình
max_error_left = max(abs(left_velocity_error));
mean_error_left = mean(abs(left_velocity_error));
max_error_right = max(abs(right_velocity_error));
mean_error_right = mean(abs(right_velocity_error));

% Plot sai số vận tốc
figure;
hold on;
plot(data.time_s, left_velocity_error, 'r', 'DisplayName', 'Sai số vận tốc bánh trái');
plot(data.time_s, right_velocity_error, 'b', 'DisplayName', 'Sai số vận tốc bánh phải');
xlabel('Thời gian (s)');
ylabel('Sai số vận tốc (rps)');
title('Sai số vận tốc theo thời gian');
grid on;

% Thêm thông tin sai số vào chú thích
legend({
    sprintf('Sai số vận tốc bánh trái\nTB: %.4f rps, Max: %.4f rps', mean_error_left, max_error_left), ...
    sprintf('Sai số vận tốc bánh phải\nTB: %.4f rps, Max: %.4f rps', mean_error_right, max_error_right)
}, 'Location', 'best');

hold off;

% Plot vận tốc thực đáp ứng theo vận tốc lệnh
figure; % Tạo figure mới
hold on;
plot(data.time_s, data.left_velocity_cmd, 'r--', 'DisplayName', 'Lệnh vận tốc bánh trái');
plot(data.time_s, data.real_left_velocity, 'r', 'DisplayName', 'Vận tốc thực bánh trái');
plot(data.time_s, data.right_velocity_cmd, 'b--', 'DisplayName', 'Lệnh vận tốc bánh phải');
plot(data.time_s, data.real_right_velocity, 'b', 'DisplayName', 'Vận tốc thực bánh phải');
xlabel('Thời gian (s)');
ylabel('Vận tốc (rps)');
title('Vận tốc thực đáp ứng theo vận tốc lệnh');
legend('Location', 'best');
grid on;
hold off;

% Plot quỹ đạo di chuyển từ amcl_x và amcl_y trong một figure mới
figure;
hold on;
plot(data.amcl_x, data.amcl_y, 'g', 'DisplayName', 'Quỹ đạo di chuyển');
xlabel('amcl\_x (m)');
ylabel('amcl\_y (m)');
title('Quỹ đạo di chuyển của robot');
legend('Location', 'best');
grid on;
hold off;