% close all;
% clear all;
% clc;
% close all;

filepath = 'C:\Users\akash\OneDrive\Desktop\FALL 2022\09_08_2022_INFORMS_simulation\square.txt'

dist_res = 0.00254; %1 BLU in SIEMENS machine is 0.0001"
plot_path = 1;
verbose = 1;

layer_toolpath = gCodeReader(filepath, dist_res, plot_path, verbose); title('Perpsective View'); pub_fig;

figure(); 
scatter(layer_toolpath(:,1),layer_toolpath(:,2),'filled'); title('Top View');  pub_fig;
xlabel('X (m)'); ylabel('Y(m)');
data = layer_toolpath(:,1)';
xlim([0,0.1]); ylim([0,0.1])

X = layer_toolpath(:,1);
Y = layer_toolpath(:,2);
speed = 0.006; % m/sec
path_profile = [X,Y];

dist_points = sqrt(sum((path_profile(2:end,:) - path_profile(1:(end-1),:)).^2,2)); %distance between points

time_stamps = dist_points/speed;
Time = [0;cumsum(time_stamps)];

%% Required Position

p_req = [X,Y,Time];

%% Post plot
% figure();
% subplot(1,2,1)
% plot(X1,'LineWidth',2); hold on; plot(X2,'LineWidth',2);title('X');pub_fig;
% % ylim([4.5,5.1]);xlim([7000,14000]);
% subplot(1,2,2)
% plot(Y1,'LineWidth',2); hold on; plot(Y2,'LineWidth',2);title('Y');pub_fig;
% % ylim([8.5,10.5]);xlim([4000,9000]);