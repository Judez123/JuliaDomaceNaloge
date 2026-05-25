module Naloga03

using LinearAlgebra
using SpecialFunctions: gamma # Uporabimo samo za začetni pogoj v 0

export izracunaj_nicle_airy

# 1. En korak Magnusove metode reda 4
function magnus_step(x, y, h)
    c1 = 0.5 - sqrt(3)/6
    c2 = 0.5 + sqrt(3)/6
    
    # Matrika sistema A(x) za Airyjevo enačbo: y'' - x*y = 0
    # Spremenljivki: y1 = Ai(x), y2 = Ai'(x) -> y1' = y2, y2' = x*y1
    A(x_val) = [0.0 1.0; x_val 0.0]
    
    A1 = A(x + c1 * h)
    A2 = A(x + c2 * h)
    
    # Komutator [A1, A2] = A1*A2 - A2*A1
    A_comm = A1 * A2 - A2 * A1
    
    # Izračunσ_{k+1}
    sigma = (h / 2) * (A1 + A2) - (sqrt(3) / 12) * (h^2) * A_comm
    
    # Nov približek z matrično eksponentno funkcijo
    return exp(sigma) * y
end

# 2. Pametna bisekcija znotraj intervala [x_k, x_k + h]
# Da ne izgubljamo natančnosti, bisekcijo delamo na deležu koraka t ∈ [0, 1]
function bisekcija_magnus(x_k, y_k, h, tol=1e-12)
    t_low = 0.0
    t_high = 1.0
    y_low = y_k
    
    while (t_high - t_low) * abs(h) > tol
        t_mid = (t_low + t_high) / 2
        
        # Izračunamo stanje na sredini z enim korakom dolžine (t_mid * h) iz začetne točke x_k
        y_mid = magnus_step(x_k, y_k, t_mid * h)
        
        if y_mid[1] * y_low[1] < 0
            t_high = t_mid
        else
            t_low = t_mid
            y_low = y_mid
        end
    end
    
    return x_k + ((t_low + t_high) / 2) * h
end

# 3. Glavna funkcija za iskanje vseh ničel do x_end
function izracunaj_nicle_airy(x_end=-15.0, h=-0.01)
    # Začetni pogoji pri x = 0 (iz navodil naloge)
    ai_0 = 1 / (3^(2/3) * gamma(2/3))
    aid_0 = -1 / (3^(1/3) * gamma(1/3))
    
    y = [ai_0, aid_0]
    x = 0.0
    nicle = Float64[]
    
    # Integriramo nazaj (h je negativen, zato se x manjša)
    while x > x_end
        y_next = magnus_step(x, y, h)
        
        # Če produkt vrednosti spremeni predznak, smo prečkali ničlo
        if y[1] * y_next[1] < 0
            nicla = bisekcija_magnus(x, y, h)
            push!(nicle, nicla)
        end
        
        x += h
        y = y_next
    end
    
    return nicle
end

end # module