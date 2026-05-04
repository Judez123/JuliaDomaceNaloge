using Naloga01
using Plots

# Ustvarimo 9 točk na intervalu od 0 do 2π
x = collect(0 : pi/4 : 2*pi)
y = sin.(x)

# Izračunamo zlepek
Z = interpoliraj(x, y)

# Narišemo
p = plot(Z)

savefig(p, "zlepek_sinus.png")
println("Slika sinus_zlepek.png je shranjena!")