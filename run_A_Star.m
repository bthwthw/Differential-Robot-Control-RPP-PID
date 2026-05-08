planner = plannerAStarGrid(map_inf);

disp('-> Looking for path');
start_grid = world2grid(map_inf, start_pose);
goal_grid  = world2grid(map_inf, goal_pose);
path = plan(planner, start_grid, goal_grid);

if isempty(path)
    error('[ERROR]: A* found no path, check Start/Goal');
end

WP = grid2world(map_inf, path);
WP = WP(1:5:end, :); % WP filter 

% if goal is missing, add it to the end of WP
if norm(WP(end,:) - goal_pose) > 0.1
    WP = [WP; goal_pose];
end 
fprintf('-> A* done, path has %d point \n', length(WP));

x_0 = WP(1, 1);      % initial X, Y, theta of robot 
y_0 = WP(1, 2);      
theta_0 = atan2(WP(2,2) - WP(1,2), WP(2,1) - WP(1,1));