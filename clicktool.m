bg_image = imread('resources/layout.png');
X_max = 28.8;
Y_max = 22.4;

figure('Name', 'Choosing Start and Goal');
imshow(bg_image, 'XData', [0, X_max], 'YData', [Y_max, 0]);
axis on; set(gca, 'YDir', 'normal'); hold on;

disp('Click on Start...');
start_pose = ginput(1); 
plot(start_pose(1), start_pose(2), 'go', 'MarkerSize', 10, 'LineWidth', 3);
disp(['-> Start (m): X = ', num2str(start_pose(1)), ', Y = ', num2str(start_pose(2))]);

disp('Click on Goal...');
goal_pose = ginput(1);
plot(goal_pose(1), goal_pose(2), 'ro', 'MarkerSize', 10, 'LineWidth', 3); 
disp(['-> Goal (m): X = ', num2str(goal_pose(1)), ', Y = ', num2str(goal_pose(2))]);
