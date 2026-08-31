#jai-jagannath 
using Plots
using Statistics
using Random

function crosscorrelation(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}, maxlag::Int)
    @assert length(x) == length(y) "x and y must be the same length"
    N = length(x)
    @assert 0 <= maxlag < N "maxlag must be smaller than length(x)"

    xc = x .- mean(x)
    yc = y .- mean(y)
    denom = sqrt(sum(xc .^ 2) * sum(yc .^ 2))

    lags = -maxlag:maxlag
    r = zeros(Float64, length(lags))
    for (i, k) in enumerate(lags)
        num = 0.0
        if k >= 0
            @inbounds for t in 1:(N - k)
                num += xc[t] * yc[t + k]
            end
        else
            @inbounds for t in 1:(N + k)
                num += xc[t - k] * yc[t]
            end
        end
        r[i] = num / denom
    end
    return r
end

"""
    autocorrelation(x, maxlag)

Normalized sample autocorrelation of `x` for lags 0:maxlag:

    r(k) = Σ_{t=1}^{N-k} (x_t - μ)(x_{t+k} - μ) / Σ_{t=1}^{N} (x_t - μ)^2

Returns a vector of length maxlag + 1 (lag 0 first).
Equivalent to the k >= 0 half of crosscorrelation(x, x, maxlag).
"""
function autocorrelation(x::AbstractVector{<:Real}, maxlag::Int)
    N = length(x)
    @assert 0 <= maxlag < N "maxlag must be smaller than length(x)"

    xc = x .- mean(x)
    denom = sum(xc .^ 2)

    r = zeros(Float64, maxlag + 1)
    for k in 0:maxlag
        num = 0.0
        @inbounds for t in 1:(N - k)
            num += xc[t] * xc[t + k]
        end
        r[k + 1] = num / denom
    end
    return r
end


Random.seed!(42)

N = 500
t = 1:N

# Signal x: noisy sine wave
x = sin.(2π .* t ./ 40) .+ 0.3 .* randn(N)

# Signal y: same underlying sine wave, phase-shifted + independent noise
# (gives the cross-correlation a clear peak away from lag 0)
shift = 15
y = sin.(2π .* (t .- shift) ./ 40) .+ 0.3 .* randn(N)


maxlag = 100
acf = autocorrelation(x, maxlag)
ccf = crosscorrelation(x, y, maxlag)

lags_acf = 0:maxlag
lags_ccf = -maxlag:maxlag


p1 = plot(t, x, label = "x(t)", linewidth = 1.1, color = :steelblue)
plot!(p1, t, y, label = "y(t)", linewidth = 1.1, color = :seagreen,
      title = "Signals", xlabel = "t", ylabel = "amplitude")

p2 = plot(lags_ccf, ccf,
    seriestype = :sticks,
    title = "Cross-correlation  r_xy(k)",
    xlabel = "Lag (k)", ylabel = "r_xy(k)",
    legend = false, color = :purple,
    marker = (:circle, 3, :purple))
hline!(p2, [0], color = :black, linewidth = 0.8, linestyle = :dash)
vline!(p2, [shift], color = :red, linewidth = 1, linestyle = :dot, label = "true shift")

p3 = plot(lags_acf, acf,
    seriestype = :sticks,
    title = "Autocorrelation  r(k)",
    xlabel = "Lag (k)", ylabel = "r(k)",
    legend = false, color = :darkorange,
    marker = (:circle, 3, :darkorange))
hline!(p3, [0], color = :black, linewidth = 0.8, linestyle = :dash)

plt = plot(p1, p2, p3, layout = (3, 1), size = (850, 950))


outfile = joinpath(@__DIR__, "correlation_autocorrelation.png")
savefig(plt, outfile)
println("Saved plot to: ", outfile)