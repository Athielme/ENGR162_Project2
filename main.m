t_start = 0;
t_end = 1000;
del_t = 2;
times = [t_start:del_t:t_end];

berg_size = [200,200,70];
berg_mass = berg_size(1)*berg_size(2)*berg_size(3)*1000;

air_v_x = sin([0:t_end]);
air_v_x = interp1([0:t_end], air_v_x, times);

air_v_y = [-5:10];
air_v_y = interp1([-5:10], air_v_y .* 0, times);

air_v = [air_v_x;air_v_y];
air_v = transpose(air_v);

water_v_x = sin([0:t_end]);
water_v_x = interp1([0:t_end], water_v_x .* 2, times);

water_v_y = [-5:10];
water_v_y = interp1([-5:10], water_v_y, times);

water_v = [water_v_x;water_v_y];
water_v = transpose(water_v);

berg_v = [0,0];
berg_x = 0;
berg_y = 0;



%% Main Calculation Loop
counter = 1;
for t = times
    air_force = F_air(air_v(counter,:),berg_v(counter,:), berg_size);
    water_force = F_water(water_v(counter,:), berg_v(counter,:), berg_size);
    berg_force = air_force + water_force;
    berg_v(counter + 1,:) = berg_v(counter, :) + (del_t/berg_mass).*( ...
          berg_force);
    
    norm_berg(counter) = norm(berg_v(counter,:));
    berg_x(counter + 1) = berg_x(counter) + berg_v(counter + 1, 1) * del_t;
    berg_y(counter + 1) = berg_y(counter) + berg_v(counter + 1, 2) * del_t;
    counter = counter + 1;
end

% %% FREE BODY DIAGRAM
% figure(1)
% quiver([0,0,0],[0,0,0], [air_force(1),water_force(1), berg_force(1)], [air_force(2),water_force(2), berg_force(2)])
% title("Free Body Diagram of Iceberg")
% xlabel("Force (N)")
% ylabel("Force (N)")
% xlim([-20 20])
% ylim([-20 20])
% 
%% ICEBERG POSITION (Small Scale)
figure(2)
scatter(berg_x,berg_y)
title("Position of Iceberg (Small Scale)")
xlabel("X Position (m)")
ylabel("Y Position (m)")

% %% ICEBERG POSITION (Large Scale)
% figure(3)
% scatter(berg_x,berg_y)
% 
% title("Position of Iceberg (Large Scale)")
% xlabel("X Position (km)")
% ylabel("Y Position (km)")
% 
% %% Tugboat Force 
% figure(4)
% plot(times, norm_berg)
% 
% title("Tugboat Force Required to Maintain Desired Course")
% xlabel("Time (hours)");
% ylabel("Force Required (N)");
% 
% %% Mass loss
% figure(5)
% plot(times, [10000:-100:0])
% 
% title("Iceberg Mass Loss")
% xlabel("Time (hours)")
% ylabel("Icberg Mass (kg)")
% 
% %% Voyage cost
% figure(6)
% plot(times, norm_berg .* 10000)
% 
% title("Cost of Voyage")
% xlabel("Time (hours)");
% ylabel("Cost ($)");