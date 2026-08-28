#!/usr/bin/env julia
# ------------------------------------------------------------
# Linear Convolution in Julia
# Computes the linear convolution of two discrete signals x[n] and h[n]
# both "manually" (from first principles) and shows how it compares to
# Julia's DSP.jl conv() function. Saves a PNG plot for each signal and
# for the convolution result.
# ------------------------------------------------------------

# --- Package setup -------------------------------------------------
# Run once if these aren't installed:
# using Pkg
# Pkg.add(["Plots", "DSP"])

using Plots
using DSP # provides conv() for verification
gr() # fast backend, good for PNG export

# --- 1. Manual linear convolution function --------------------------
"""
 linear_convolution(x, h)

Compute the linear convolution y[n] = sum_k x[k] * h[n-k]
of two 1-D signals `x` and `h`. Returns a vector of length
length(x) + length(h) - 1.
"""
function linear_convolution(x::Vector{<:Real}, h::Vector{<:Real})
 Nx = length(x)
 Nh = length(h)
 Ny = Nx + Nh - 1
 y = zeros(Float64, Ny)

 for n in 1:Ny
 s = 0.0
 for k in 1:Nx
 m = n - k + 1 # index into h (1-based)
 if 1 <= m <= Nh
 s += x[k] * h[m]
 end
 end
 y[n] = s
 end
 return y
end

# --- 2. Get input signals from the user --------------------------------
"""
 read_signal(prompt)

Prompt the user for a comma/space-separated list of numbers and
return them as a Vector{Float64}.
"""
function read_signal(prompt::String)
 print(prompt)
 line = readline()
 # split on commas and/or whitespace, drop empty tokens
 tokens = split(line, r"[,\s]+"; keepempty = false)
 return parse.(Float64, tokens)
end

println("Enter values separated by spaces or commas, e.g.: 1 2 3 4")
x = read_signal("Enter input signal x[n]: ")
h = read_signal("Enter impulse response h[n]: ")

println("x[n] = ", x)
println("h[n] = ", h)

# --- 3. Perform convolution -------------------------------------------
y_manual = linear_convolution(x, h)
y_builtin = DSP.conv(x, h)

println("\nManual convolution result y[n] = ", y_manual)
println("DSP.conv() result y[n] = ", y_builtin)
println("Match: ", isapprox(y_manual, y_builtin))

# --- 4. Plot and save each signal as PNG -------------------------------
n_x = 0:length(x)-1
n_h = 0:length(h)-1
n_y = 0:length(y_manual)-1

plt_x = sticks(n_x, x,
 title = "Input Signal x[n]",
 xlabel = "n", ylabel = "Amplitude",
 marker = :circle, legend = false, lw = 2)
savefig(plt_x, "signal_x.png")

plt_h = sticks(n_h, h,
 title = "Impulse Response h[n]",
 xlabel = "n", ylabel = "Amplitude",
 marker = :circle, legend = false, lw = 2, color = :orange)
savefig(plt_h, "signal_h.png")

plt_y = sticks(n_y, y_manual,
 title = "Linear Convolution y[n] = x[n] * h[n]",
 xlabel = "n", ylabel = "Amplitude",
 marker = :circle, legend = false, lw = 2, color = :green)
savefig(plt_y, "convolution_result.png")

# --- 5. Combined comparison plot (all three stacked) --------------------
plt_combined = plot(
 plt_x, plt_h, plt_y,
 layout = (3, 1),
 size = (700, 800)
)
savefig(plt_combined, "convolution_combined.png")

println("\nSaved plots:")
println(" signal_x.png")
println(" signal_h.png")
println(" convolution_result.png")
println(" convolution_combined.png")