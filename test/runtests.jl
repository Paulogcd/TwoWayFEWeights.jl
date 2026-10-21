using TwoWayFEWeights
using Test
using RCall
using PyCall
using Random
using DataFrames
using Downloads
using OrderedCollections
using JLD2
using CSV
using ReadStatTables

Test.@testset "TwoWayFEWeights.jl" begin

    # Helper:
    include(joinpath(@__DIR__, "0_utils_R_packages.jl"))
    include(joinpath(@__DIR__, "0_utils_python_environment.jl"))
    include(joinpath(@__DIR__, "0_utils_python_utils.jl"))
    
    include(joinpath(@__DIR__, "3_0_utils_test_helper.jl"))
    include(joinpath(@__DIR__, "3_1_utils_test_stepwise.jl"))

    
    # Basic tests
    include(joinpath(@__DIR__, "./0_utils.jl"));
    
    # Intermediate function tests
    include("./1_intermediate_twowayfeweights_normalize_var.jl");
    
    # Final results tests
    include(joinpath(@__DIR__, "2_final_internal_test_wagepan.jl"));
    include(joinpath(@__DIR__, "2_final_official_test.jl"));
    
    # Stepwise tests
    include(joinpath(@__DIR__, "3_final_stepwise_official_test.jl"));

end;