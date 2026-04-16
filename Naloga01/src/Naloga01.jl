module Naloga01

using LinearAlgebra
using Plots

export Zlepek, interpoliraj, vrednost

"""
    Zlepek

Podatkovni tip, ki hrani interpolacijske točke (x) in koeficiente 
kubičnih polinomov (a, b, c, d) za posamezne odseke.
"""
struct Zlepek
    x::Vector{Float64}
    a::Vector{Float64}
    b::Vector{Float64}
    c::Vector{Float64}
    d::Vector{Float64}
end

"""
    interpoliraj(x, y)

Izračuna koeficiente naravnega kubičnega zlepka za podane točke `x` in vrednosti `y`.
Vrne objekt tipa `Zlepek`.
"""
function interpoliraj(x::Vector{Float64}, y::Vector{Float64})
    n = length(x)
    h = diff(x) # razlike med sosednjimi x: h[i] = x[i+1] - x[i]
    a = copy(y)

    # Priprava elementov za tridiagonalni sistem A * c = v
    dl = zeros(n-1) # poddiagonala
    d  = ones(n)    # glavna diagonala (na robovih 1 za c_1 = c_n = 0)
    du = zeros(n-1) # naddiagonala
    v  = zeros(n)   # desna stran

    for i in 2:n-1
        dl[i-1] = h[i-1]
        d[i] = 2 * (h[i-1] + h[i])
        du[i] = h[i]
        v[i] = 3/h[i] * (a[i+1] - a[i]) - 3/h[i-1] * (a[i] - a[i-1])
    end

    #tridiagonalni sistem
    A = Tridiagonal(dl, d, du)
    c = A \ v # c_1 in c_n bosta 0

    # Izračunamo b in d
    b = zeros(n-1)
    d_coef = zeros(n-1)
    for i in 1:n-1
        b[i] = (a[i+1] - a[i])/h[i] - h[i]*(2*c[i] + c[i+1])/3
        d_coef[i] = (c[i+1] - c[i]) / (3*h[i])
    end

    # Vrnemo Zlepek
    return Zlepek(x, a[1:n-1], b, c[1:n-1], d_coef)
end

"""
    vrednost(Z, x_val)

Vrne vrednost zlepka `Z` v točki `x_val`.
"""
function vrednost(Z::Zlepek, x_val::Float64)
    # Poiščemo indeks intervala, v katerem leži x_val
    i = searchsortedlast(Z.x, x_val)
    
    # Preprečimo napake na robovih
    if i < 1; i = 1; end
    if i > length(Z.x) - 1; i = length(Z.x) - 1; end

    dx = x_val - Z.x[i]
    return Z.a[i] + Z.b[i]*dx + Z.c[i]*dx^2 + Z.d[i]*dx^3
end

"""
    Plots.plot(Z::Zlepek)

Nariše graf naravnega zlepka. Sosednji odseki so izmenično rdeče in modre barve.
"""
function Plots.plot(Z::Zlepek)
    p = plot(legend=false, title="Naravni kubični zlepek")
    for i in 1:length(Z.x)-1
        # Generiramo točke za risanje posameznega intervala
        xx = range(Z.x[i], Z.x[i+1], length=50)
        yy = [vrednost(Z, x) for x in xx]
        
        # Izmenično določanje barv (za sodo in liho)
        barva = isodd(i) ? :red : :blue
        plot!(p, xx, yy, color=barva, linewidth=2)
    end
    
    # Narišemo še originalne interpolacijske točke
    scatter!(p, Z.x, [Z.a...; vrednost(Z, Z.x[end])], color=:black, markersize=4)
    return p
end

end