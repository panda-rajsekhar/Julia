# Circular Convolution

using Plots

# Input signals
x = [1, 2, 3, 4]
h = [1, 2, 1, 0]

# Check signal lengths
if length(x) != length(h)
    error("Both signals must have the same length.")
end

N = length(x)

# Initialize output signal
y = zeros(N)

# Perform circular convolution
for n in 1:N
    for k in 1:N
        index = mod(n - k, N) + 1
        y[n] += x[k] * h[index]
    end
end

# Sample indices
n = 0:N-1

# Create plots
p1 = plot(
    n, x,
    seriestype = :stem,
    marker = :circle,
    title = "Input Signal x[n]",
    xlabel = "n",
    ylabel = "Amplitude",
    legend = false
)

p2 = plot(
    n, h,
    seriestype = :stem,
    marker = :circle,
    title = "Input Signal h[n]",
    xlabel = "n",
    ylabel = "Amplitude",
    legend = false
)

p3 = plot(
    n, y,
    seriestype = :stem,
    marker = :circle,
    title = "Circular Convolution y[n]",
    xlabel = "n",
    ylabel = "Amplitude",
    legend = false
)

# Combine all plots vertically
final_plot = plot(
    p1, p2, p3,
    layout = (3, 1),
    size = (800, 900)
)

# Save the plot as PNG
savefig(final_plot, "circular_convolution_results.png")

println("Input x[n] = ", x)
println("Input h[n] = ", h)
println("Output y[n] = ", y)

println("\nPlot saved as: circular_convolution_results.png")