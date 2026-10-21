# This testset compares the final results of computations between Julia and the original packages.
# Initially, the tests were running only against the R version, but this proves to be too long on 
# the GitHub CI servers (estimated 120 minutes). Therefore, the final tests now run against the python
# version of the package, which is much faster. This comes however at the price of exactitude: the python 
# final objects are in fact different than the julia ones, but the tests compare all items present in both 
# versions of the package. This is an issue similar to the NULL items in the R version not being displayed
# and therefore underestimating the lenght of the R object (the R object key does not exist, but the julia version 
# has a nothing value at the same key).
# The R tests are kept for archive reasons, and if the user wishes to locally try them.
Test.@testset "final_official_test.jl" begin
    
    # Julia vs R
    # include("./2_final_official_test_1_R.jl") # Pass
    # include("./2_final_official_test_2_R.jl") # Pass
    # include("./2_final_official_test_3_R.jl") # Takes time... And 2 items are missing in the R object, due to NULL behaviour with RCall. (R_object = 12, julia_object = 15)
    # include("./2_final_official_test_4_R.jl") # Exact same problem here.
    # As the local output shows, some tests do not pass.
    # This is due to the fact that the output-creating function is `compare_R_julia`, that is 
    # used for intermediate functions. Another function strictly equivalent to the `compare_python_julia`
    # has not been created, (that would ignore missing items with interesect(names(), names()) 
    # as the final tests are way more convenient to be performed against python anyways.

    # Julia vs python
    include("./2_final_official_test_1_python.jl"); # Pass 
    include("./2_final_official_test_2_python.jl"); # Pass
    include("./2_final_official_test_3_python.jl"); # Pass
    include("./2_final_official_test_4_python.jl"); # Pass
end;