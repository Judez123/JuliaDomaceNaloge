Navodila za uporaboKoda je organizirana kot Julia paket Naloga02.

Zagon testov: V Julia REPL aktivirajte okolje in uporabite ukaz Pkg.test("Naloga02").

Izračun integrala: Funkcija gauss_legendre_2(f, a, b, n) izračuna približek integrala funkcije f na intervalu $[a, b]$ z uporabo $n$ podintervalov.

Ocena natančnosti: Funkcija oceni_n_za_natancnost(f, a, b, tol) samodejno določi potrebno število podintervalov $n$ za dosego zahtevane tolerance tol.

Demonstracija: Zagon skripte demo.jl v terminalu (julia --project=. demo.jl) izvede izračun za testni primer $\int_0^5 \frac{\sin x}{x} dx$, izpiše tabelo konvergence in zgenerira graf napake.