%% Data Storage
xvelocity_data = x_velocity.Data;
xvelocity_time = x_velocity.Time;

yvelocity_data = y_velocity.Data;
yvelocity_time = y_velocity.Time;

%% Observe Velocity and position

figure();

subplot(2,1,1)
plot(velocity_time,xvelocity_data,'LineWidth',2,'Color','blue'); pub_fig;
hold on; plot(velocity_time,yvelocity_data,'LineWidth',2,'Color','red'); pub_fig;
ylim([-0.02,0.02])
xlabel('time(s)')
hold off;

subplot(2,1,2)
plot(velocity_time,X1,'LineWidth',2); pub_fig;
hold on; plot(velocity_time,Y1,'LineWidth',2); pub_fig;
legend({'X','Y'},'Location','NorthWest')
hold off

%% Actual Position v/s referenced position

figure();
plot(xvelocity_time,X1,'LineWidth',1.5,'Color','blue'); pub_fig;
hold on; 
plot(xvelocity_time,X2,'LineWidth',1.5,'Color','black');
plot(yvelocity_time,Y1,'LineWidth',1.5,'Color','red');
plot(yvelocity_time,Y2,'LineWidth',1.5,'Color','black');

%% Error calculation

%Independent calculations for both axes
MSE_X = mean((X1-X2).^2);
MSE_Y = mean((Y1-Y2).^2);

MSE = MSE_X + MSE_Y;

