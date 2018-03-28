function forceAir = F_air(V_a, V_i, berg_size)
    airDensity = 1;
    dragCoeff = 1;
    berg_size(3) = berg_size(3) - submerged(berg_size);
    area = CS_area(berg_size, V_a-V_i);
    forceAir = (1/2)*airDensity*dragCoeff*area*norm(V_a - V_i).*(V_a - V_i);
end