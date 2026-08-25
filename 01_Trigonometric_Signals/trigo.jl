using Plots

# Discrete time vector
n = 0:50
t = n .* 0.2

# Trigonometric functions
y_sin = sin.(t)
y_cos = cos.(t)
y_tan = tan.(t)

# Reciprocal trig functions
y_csc = 1 ./ sin.(t) # csc(t) = 1/sin(t)
y_sec = 1 ./ cos.(t) # sec(t) = 1/cos(t)
y_cot = 1 ./ tan.(t) # cot(t) = 1/tan(t)

# --- Individual subplots ---
p1 = plot(n, y_sin, seriestype=:scatter, label="sin(n)", markersize=2,
 title="sin", xlabel="n", ylabel="Amplitude")

p2 = plot(n, y_cos, seriestype=:scatter, label="cos(n)", markersize=2,
 title="cos", xlabel="n", ylabel="Amplitude")

p3 = plot(n, y_tan, seriestype=:scatter, label="tan(n)", markersize=2,
 title="tan", xlabel="n", ylabel="Amplitude", ylim=(-5,5))

p4 = plot(n, y_csc, seriestype=:scatter, label="csc(n)", markersize=2,
 title="csc", xlabel="n", ylabel="Amplitude", ylim=(-5,5))

p5 = plot(n, y_sec, seriestype=:scatter, label="sec(n)", markersize=2,
 title="sec", xlabel="n", ylabel="Amplitude", ylim=(-5,5))

p6 = plot(n, y_cot, seriestype=:scatter, label="cot(n)", markersize=2,
 title="cot", xlabel="n", ylabel="Amplitude", ylim=(-5,5))

# Combine into one figure with 6 subplots (3 rows x 2 cols)
plot(p1, p2, p3, p4, p5, p6, layout=(3,2), size=(900,1000))
savefig("trig_discrete_all.png")