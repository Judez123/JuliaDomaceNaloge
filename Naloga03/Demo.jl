using Naloga03
using SpecialFunctions: airyai
using Printf
using Plots

println("-"^65)
println("DEMO: Iskanje ničel Airyjeve funkcije z Magnusovo metodo (red 4)")
println("-"^65)

# Poiščemo ničle na intervalu [0, -15]
nicle = izracunaj_nicle_airy(-15.0, -0.01)

@sprintf("%-5s | %-15s | %-20s", "Št.", "Izračunana ničla", "Prava vrednost Ai(x_nicla)")
println("-"^65)

for (i, x_n) in enumerate(nicle)
    # Izračunamo vrednost prave Airyjeve funkcije v naši ničli (morala bi biti blizu 0)
    prava_vrednost = airyai(x_n)
    @printf("%-5d | %-15.11f | %-20.2e\n", i, x_n, prava_vrednost)
end

println("-"^65)
println("Skupaj najdenih ničel: ", length(nicle))
println("-"^65)

println("Generiram graf...")

# 1. Pripravimo točke za gladko risanje funkcije
x_graf = range(-15.0, 0.0, length=1000)
y_graf = airyai.(x_graf)

# 2. Narišemo osnovno funkcijo
p = plot(x_graf, y_graf, 
    label="Ai(x)", 
    linewidth=2, 
    color=:blue,
    title="Airyjeva funkcija in njene ničle",
    xlabel="x", 
    ylabel="Ai(x)", 
    legend=:bottomright,
    grid=true
)

# 3. Dodamo vodoravno črto pri y = 0 za boljšo orientacijo
hline!(p, [0.0], color=:black, linestyle=:dash, label="")

# 4. Na graf dodamo izračunane ničle kot rdeče pike
# y-koordinate ničel so po definiciji 0
scatter!(p, nicle, zeros(length(nicle)), 
    label="Izračunane ničle", 
    color=:red, 
    markersize=5,
    markerstrokecolor=:black
)

# 5. Shranimo sliko
savefig(p, "airy_nicle.png")
println("Graf je uspešno shranjen kot 'airy_nicle.png'!")