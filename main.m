t_start = 0;
t_end = 10;
del_t = .1;
times = [t_start:del_t:t_end];

berg_mass = 1;

air_v_x = sin([0:10]);
air_v_x = interp1([0:10], air_v_x, times);

air_v_y = [-5:10];
air_v_y = interp1([-5:10], air_v_y .* 0, times);

air_v = [air_v_x;air_v_y];
air_v = transpose(air_v);

water_v_x = sin([0:10]);
water_v_x = interp1([0:10], water_v_x, times);

water_v_y = [-5:10];
water_v_y = interp1([-5:10], water_v_y, times);

water_v = [water_v_x;water_v_y];
water_v = transpose(water_v);

berg_v = [0,0];
berg_x = 0;
berg_y = 0;

counter = 1;
for t = times
    disp(berg_v(counter,:))
    berg_v(counter + 1,:) = berg_v(counter, :) + (del_t/berg_mass).*( ...
          F_air(air_v(counter,:),berg_v(counter,:)) ...
        + F_water(water_v(counter,:), berg_v(counter,:)));
    
    norm_berg(counter) = norm(berg_v(counter,:));
    berg_x(counter + 1) = berg_x(counter) + berg_v(counter + 1, 1) * del_t;
    berg_y(counter + 1) = berg_y(counter) + berg_v(counter + 1, 1) * del_t;
    counter = counter + 1;
end

scatter(berg_x,berg_y)