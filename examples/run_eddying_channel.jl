using GLMakie
using Oceananigans
using Oceananigans.Units
using LESbrary.IdealizedExperiments: eddying_channel_simulation

using Oceananigans.TurbulenceClosures.CATKEVerticalDiffusivities:
    CATKEVerticalDiffusivity,
    SurfaceTKEFlux

#####
##### Setup and run the simulation
#####

surface_TKE_flux = SurfaceTKEFlux(CᵂwΔ=4.56, Cᵂu★=4.46)
boundary_layer_closure = CATKEVerticalDiffusivity(; surface_TKE_flux, Cᴰ=0.215) 

simulation = eddying_channel_simulation(; architecture = GPU(),
                                        size = (80, 40, 60),
                                        stop_time = 1years,
                                        Δt = 5minutes,
                                        boundary_layer_closure)
 
wall_time = time_ns()

run!(simulation)

elapsed = 1e-9 * (time_ns() - wall_time)

@info "Simulation took " * prettytime(elapsed) * " to run."

#####
##### Visualization
#####

u, v, w = simulation.model.velocities
ζ = Field(∂x(v) - ∂y(u))
compute!(ζ)

b = simulation.model.tracers.b
Nz = simulation.model.grid.Nz
bn = Array(interior(b, :, :, Nz))
ζn = Array(interior(ζ, :, :, Nz))

fig = Figure(resolution=(1200, 800))
ax_b = Axis(fig[1, 1])
ax_ζ = Axis(fig[1, 2])
heatmap!(ax_b, bn) 
heatmap!(ax_ζ, ζn) 

display(fig)
