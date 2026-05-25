using Test
using Naloga02

@testset "Gauss-Legendre 2 točki" begin
    # 1. Test na polinomu stopnje 3 (mora biti točen do strojne natančnosti)
    f_poly(x) = x^3 - 2x + 5
    a, b = 0, 2
    # Točen integral: [x^4/4 - x^2 + 5x] od 0 do 2 = (4 - 4 + 10) - 0 = 10
    @test gauss_legendre_2(f_poly, a, b, 1) ≈ 10.0 atol=1e-14

    # 2. Test za sin(x)/x na [0, 5]
    # Limita v 0 mora biti 1.0
    sinc_custom(x) = x == 0 ? 1.0 : sin(x)/x
    
    # Preverimo, če se n povečuje pri strožji toleranci
    val1, n1 = oceni_n_za_natancnost(sinc_custom, 0.0, 5.0, 1e-5)
    val2, n2 = oceni_n_za_natancnost(sinc_custom, 0.0, 5.0, 1e-10)
    
    @test n2 > n1
    @test isapprox(val1, val2, atol=1e-5)
    
    println("Za integral sin(x)/x na [0, 5] na 10 decimalk potrebujemo n = $n2 intervalov.")
    println("Število izračunov funkcijske vrednosti: $(2 * n2)")
end