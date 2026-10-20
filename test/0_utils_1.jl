
Test.@testset "utils_1.jl" begin

    Test.@testset "fn_ctrl_rename.jl" begin
        
        # Data generation
        random_vector_test = [Random.randstring(12) for _ in 1:100]
        RCall.@rput random_vector_test
        Test.@test random_vector_test == rcopy(R"random_vector_test") # We check they are the same

        # Operation
        julia_code_result   = TwoWayFEWeights.fn_ctrl_rename(random_vector_test)
        R_code_result       = rcopy(R"TwoWayFEWeights:::fn_ctrl_rename(random_vector_test)")
        
        # Comparison
        Test.@test R_code_result == julia_code_result 
    end;

    Test.@testset "get_controls_rename.jl" begin 

        random_vector_test = [Random.randstring(12) for _ in 1:100]
        RCall.@rput random_vector_test
        Test.@test random_vector_test == rcopy(R"random_vector_test")

        julia_code_result   = TwoWayFEWeights.get_controls_rename(random_vector_test)
        R_code_result       = rcopy(R"TwoWayFEWeights:::get_controls_rename(random_vector_test)")
        
        Test.@test R_code_result == julia_code_result
    end;

    Test.@testset "get_treatments_rename.jl" begin

        random_vector_test  = [Random.randstring(12) for _ in 1:100]
        RCall.@rput random_vector_test
        Test.@test random_vector_test == rcopy(R"random_vector_test")

        julia_code_result   = TwoWayFEWeights.get_treatments_rename(random_vector_test)
        R_code_result       = rcopy(R"TwoWayFEWeights:::get_treatments_rename(random_vector_test)")
        
        Test.@test R_code_result == julia_code_result
    end;

    Test.@testset "fn_treatment_weight_rename.jl" begin

        random_vector_test = [Random.randstring(12) for _ in 1:100]
        RCall.@rput random_vector_test
        Test.@test random_vector_test == rcopy(R"random_vector_test")

        julia_code_result = TwoWayFEWeights.fn_treatment_weight_rename(random_vector_test)
        R_code_result = rcopy(R"TwoWayFEWeights:::fn_treatment_weight_rename(random_vector_test)")
        
        Test.@test R_code_result == julia_code_result
    end;

    Test.@testset "fn_random_weight_rename.jl" begin

        random_vector_test = [Random.randstring(12) for _ in 1:100]
        RCall.@rput random_vector_test
        Test.@test random_vector_test == rcopy(R"random_vector_test")

        julia_code_result = TwoWayFEWeights.fn_random_weight_rename(random_vector_test)
        R_code_result = rcopy(R"TwoWayFEWeights:::fn_random_weight_rename(random_vector_test)")

        Test.@test R_code_result == julia_code_result
    end;

    Test.@testset "get_random_weight_rename.jl" begin

        random_vector_test = [Random.randstring(12) for _ in 1:100]
        RCall.@rput random_vector_test
        Test.@test random_vector_test == rcopy(R"random_vector_test")

        julia_code_result = TwoWayFEWeights.get_random_weight_rename(random_vector_test)
        R_code_result = rcopy(R"TwoWayFEWeights:::get_random_weight_rename(random_vector_test)")
        
        Test.@test R_code_result == julia_code_result
    end;

end;