using Test
using Naloga03
using SpecialFunctions: airyai

@testset "Naloga03 - Ničle Airyjeve funkcije" begin
    
    # 1. Test: Zagon z osnovnimi parametri
    nicle = izracunaj_nicle_airy(-15.0, -0.01)
    
    # Preverimo, da je rezultat pravega tipa in ni prazen
    @test isa(nicle, Vector{Float64})
    @test !isempty(nicle)
    @test length(nicle) >= 5  # Na tem intervalu moramo najti vsaj 5 ničel
    
    # 2. Test: Natančnost vseh najdenih ničel
    # Profesor zahteva 10 decimalk (relativna natančnost 10^-10).
    # Če je ničla prava, mora biti vrednost funkcije Airyai v tej točki praktično 0.
    for nicla in nicle
        @test abs(airyai(nicla)) < 1e-10
    end
    
    # 3. Test: Preverjanje točnih znanih vrednosti za prve tri ničle
    # Vrednosti so zaokrožene na 10 tekstovnih decimalk
    @test nicle[1] ≈ -2.3381074105 atol=1e-10
    @test nicle[2] ≈ -4.0879494441 atol=1e-10
    @test nicle[3] ≈ -5.5205598281 atol=1e-10

    # 4. Test: Robni pogoj (če skrajšamo interval, moramo dobiti manj ničel)
    nicle_kratko = izracunaj_nicle_airy(-3.0, -0.01)
    @test length(nicle_kratko) == 1  # Med 0 in -3 je samo prva ničla
end