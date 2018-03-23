function forceWater = F_water(V_w, V_i)
    waterDensity = 1;
    dragCoeff = 1;
    area = 1;
    forceWater = (1/2)*waterDensity*dragCoeff*area*norm(V_w - V_i).*(V_w - V_i);
end