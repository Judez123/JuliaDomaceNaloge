using Naloga02
using Plots
using Printf

# 1. Definiramo funkcijo in interval
# Funkcija sin(x)/x ima v 0 odstranljivo singularnost (limita je 1)
f(x) = x == 0 ? 1.0 : sin(x) / x
a, b = 0.0, 5.0

println("-"^50)
println("DEMO: Gauss-Legendrove kvadrature na dveh točkah")
println("Računanje integrala sin(x)/x na [0, 5]")
println("-"^50)

# 2. Analiza konvergence (podvajanje števila intervalov)
ns = [2^i for i in 0:10]
priblizki = Float64[]
napake = Float64[]

# Izračunamo "točno" vrednost z zelo veliko intervali za referenco
tocna_vrednost = gauss_legendre_2(f, a, b, 2048)

println(@sprintf("%-10s | %-20s | %-15s", "n", "Približek", "Ocena napake"))
println("-"^50)

for (i, n) in enumerate(ns)
    val = gauss_legendre_2(f, a, b, n)
    push!(priblizki, val)
    
    if i > 1
        # Ocena napake po Rungejevem pravilu za metodo reda 4
        err = abs(priblizki[i] - priblizki[i-1]) / 15
        push!(napake, err)
        @printf("%-10d | %-20.15f | %-15.2e\n", n, val, err)
    else
        push!(napake, 0.0)
        @printf("%-10d | %-20.15f | %-15s\n", n, val, "---")
    end
end

# 3. Iskanje n za natančnost 10^-10
rezultat, n_final = oceni_n_za_natancnost(f, a, b, 1e-10)

println("-"^50)
println(@sprintf("Končni rezultat: %.15f", rezultat))
println("Za 10 decimalk potrebujemo n = $n_final podintervalov.")
println("Skupno število izračunov funkcije: $(2 * n_final)")
println("-"^50)

# 4. Vizualizacija konvergence
plt = plot(ns[2:end], napake[2:end], 
    xaxis=:log, yaxis=:log, 
    marker=:circle, 
    title="Konvergenca Gauss-Legendrove metode",
    xlabel="Število intervalov (n)", 
    ylabel="Ocena napake",
    label="Izračunana napaka",
    grid=true)

# Dodamo premico, ki kaže red O(h^4) za primerjavo
plot!(plt, ns[2:end], (napake[2] .* (ns[2] ./ ns[2:end]).^4), 
    linestyle=:dash, color=:red, label="Teoretični red O(h^4)")

savefig(plt, "konvergenca_gauss.png")
println("Graf konvergence je shranjen v 'konvergenca_gauss.png'.")