function forceAir = F_air(V_a, V_i)
    airDensity = 1;
    dragCoeff = 1;
    area = 1;
    forceAir = (1/2)*airDensity*dragCoeff*area*norm(V_a - V_i).*(V_a - V_i);
end