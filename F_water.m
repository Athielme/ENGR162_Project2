function forceWater = F_water(V_w, V_i, berg_size)
    waterDensity = 1;
    dragCoeff = 1;
    berg_size(3) = submerged(berg_size);
    area = CS_area(berg_size, V_w - V_i);
    forceWater = (1/2)*waterDensity*dragCoeff*area*norm(V_w - V_i).*(V_w - V_i);
end