module Naloga02

using LinearAlgebra

export gauss_legendre_2, oceni_n_za_natancnost

"""
    gauss_legendre_2(f, a, b, n)

Izračuna integral funkcije `f` na [a, b] z n podintervali.
"""
function gauss_legendre_2(f, a, b, n)
    h = (b - a) / n
    v1 = -1/sqrt(3)
    v2 = 1/sqrt(3)
    integral = 0.0
    
    for i in 0:n-1
        x_start = a + i*h
        sredina = x_start + h/2
        
        # Točki na podintervalu
        t1 = sredina + (h/2) * v1
        t2 = sredina + (h/2) * v2
        
        integral += (h/2) * (f(t1) + f(t2))
    end
    return integral
end

"""
    oceni_n_za_natancnost(f, a, b, tol)

Vrne (približek, n), kjer je n število intervalov potrebnih za toleranco `tol`.
"""
function oceni_n_za_natancnost(f, a, b, tol)
    n = 1
    I_n = gauss_legendre_2(f, a, b, n)
    while true
        n *= 2
        I_2n = gauss_legendre_2(f, a, b, n)
        # Za O(h^4) metodo je napaka |I_2n - I_n| / (2^4 - 1)
        napaka = abs(I_2n - I_n) / 15
        if napaka < tol
            return I_2n, n
        end
        I_n = I_2n
        if n > 10^7 # Varnostna blokada
            error("Konvergenca prepočasna.")
        end
    end
end

end
