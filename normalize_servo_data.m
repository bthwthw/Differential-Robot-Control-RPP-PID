% 1. Đọc dữ liệu từ CSV (Thêm lệnh ép giữ nguyên tên cột gốc)
data = readtable('velocity_20260502_063609.csv', 'VariableNamingRule', 'preserve');

% 2. Lấy trục thời gian gốc và các tín hiệu
t_raw = data.("Time(s)");
u0_raw = data.Axis0_Ref;  
y0_raw = data.Axis0_Real;

u1_raw = data.Axis1_Ref;  
y1_raw = data.Axis1_Real;

% 3. Tạo trục thời gian T_s chuẩn (0.05s) đều đặn từ đầu đến cuối
Ts_chuan = 0.05;
t_chuan = (t_raw(1) : Ts_chuan : t_raw(end))';

% 4. Dùng hàm nội suy để nắn lại dữ liệu theo trục thời gian chuẩn
u0_chuan = interp1(t_raw, u0_raw, t_chuan, 'linear');
y0_chuan = interp1(t_raw, y0_raw, t_chuan, 'linear');

u1_chuan = interp1(t_raw, u1_raw, t_chuan, 'linear');
y1_chuan = interp1(t_raw, y1_raw, t_chuan, 'linear');

disp('Done');