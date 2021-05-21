using Test
using Printf
using Logging
using Oceananigans
using Oceananigans.Fields
using Oceananigans.OutputWriters
using LESbrary

Logging.global_logger(OceananigansLogger())

architectures = [CPU()]

@testset "LESbrary" begin
    include("test_utils.jl")
    include("test_turbulence_statistics.jl")
    include("test_examples.jl")
end
