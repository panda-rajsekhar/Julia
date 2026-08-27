using Plots

# Time index
n = -10:10

# ---------- Signals ----------
impulse     = [i == 0 ? 1 : 0 for i in n]
step        = [i >= 0 ? 1 : 0 for i in n]
ramp        = [i >= 0 ? i : 0 for i in n]

n_exp = 0:10
exponential = [0.8^i for i in n_exp]

sinusoid = [sin(0.2π * i) for i in n]
cosine   = [cos(0.2π * i) for i in n]

# ---------- Plots ----------
p1 = sticks(n, impulse, title="Unit Impulse", legend=false)
p2 = sticks(n, step, title="Unit Step", legend=false)
p3 = sticks(n, ramp, title="Unit Ramp", legend=false)
p4 = sticks(n_exp, exponential, title="Exponential", legend=false)
p5 = sticks(n, sinusoid, title="Sinusoidal", legend=false)
p6 = sticks(n, cosine, title="Cosine", legend=false)

plt = plot(p1, p2, p3, p4, p5, p6, layout=(3,2), size=(1000,900))
savefig(plt, "signals.png")
println("Plot saved to: ", joinpath(pwd(), "signals.png"))

# ---------- Classification helpers ----------

# Checks even/odd symmetry numerically over a symmetric index range (only valid if n is symmetric about 0)
function symmetry(x, n; tol=1e-9)
    if n[1] != -n[end]
        return "N/A (range not symmetric about 0)"
    end
    xr = reverse(x)   # x[-n] when n is symmetric
    if all(abs.(x .- xr) .< tol)
        return "Even"
    elseif all(abs.(x .+ xr) .< tol)
        return "Odd"
    else
        return "Neither"
    end
end

# Checks periodicity numerically by testing candidate periods within the window
function periodicity(x, n; tol=1e-9)
    L = length(x)
    for N in 1:(L-1)
        matches = true
        for i in 1:(L-N)
            if abs(x[i] - x[i+N]) > tol
                matches = false
                break
            end
        end
        if matches
            return "Periodic (period ≈ $N samples, within window)"
        end
    end
    return "Non-periodic (within window)"
end

# ---------- Print classification table ----------
println("\n===================== SIGNAL CLASSIFICATION =====================")

println("\n1) Unit Impulse δ[n]")
println("   Symmetry   : ", symmetry(impulse, n))
println("   Periodicity: ", periodicity(impulse, n))
println("   Energy/Power: Energy signal (finite energy = 1, avg power → 0)")

println("\n2) Unit Step u[n]")
println("   Symmetry   : ", symmetry(step, n))
println("   Periodicity: ", periodicity(step, n))
println("   Energy/Power: Power signal (infinite energy, avg power = 0.5)")

println("\n3) Unit Ramp r[n]")
println("   Symmetry   : ", symmetry(ramp, n))
println("   Periodicity: ", periodicity(ramp, n))
println("   Energy/Power: Neither (energy AND power both infinite, grows unbounded)")

println("\n4) Exponential (0.8)^n, n ≥ 0")
println("   Symmetry   : N/A (only defined for n ≥ 0, not a symmetric range)")
println("   Periodicity: ", periodicity(exponential, n_exp))
println("   Energy/Power: Energy signal (|0.8|<1 → sum of squares converges)")

println("\n5) Sinusoidal sin(0.2πn)")
println("   Symmetry   : ", symmetry(sinusoid, n))
println("   Periodicity: ", periodicity(sinusoid, n))
println("   Energy/Power: Power signal (finite avg power = 0.5, infinite energy)")

println("\n6) Cosine cos(0.2πn)")
println("   Symmetry   : ", symmetry(cosine, n))
println("   Periodicity: ", periodicity(cosine, n))
println("   Energy/Power: Power signal (finite avg power = 0.5, infinite energy)")

println("\n===================================================================")