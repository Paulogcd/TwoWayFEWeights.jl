function compare_python_julia(python_object::AbstractDict, julia_object::AbstractDict)

    for k in intersect(string.(keys(julia_object)), string.(keys(python_object)))
        
        julia_object_k          = julia_object[Symbol(k)]
        python_object_k         = python_object[k]

        if julia_object_k isa OrderedCollections.OrderedDict

            # @info string("The object ", k, " is a Dict.")
            compare_R_julia_object(python_object_k, julia_object_k)

        elseif julia_object_k isa DataFrames.DataFrame
            
            # @info string("The object ", k, " is a DataFrame.")
            compare_python_julia_df(python_object_k, julia_object_k)
        
        else

            result = isequal(python_object_k, julia_object_k)
            
            if !result

                result_approx = isapprox(
                    python_object_k,
                    julia_object_k;
                    atol = 1e-4
                )

                if !result_approx
                    @show k
                    @show eltype(julia_object_k)
                    @show eltype(python_object_k)
                    @show length(julia_object_k)
                    @show length(python_object_k)
                    @show maximum(abs.(julia_object_k .- python_object_k))
                    @show python_object_k
                    @show julia_object_k
                end
                Test.@test result_approx
            else
                Test.@test result
            end
        end
    end
end

function compare_python_julia_df(python_object_k::DataFrames.DataFrame, julia_object_k::DataFrames.DataFrame)
    
    Test.@test size(julia_object_k) == size(python_object_k)
    Test.@test length(setdiff(names(julia_object_k), names(python_object_k))) == 0

    # For Tfactor:
    if "Tfactor" ∈ names(julia_object_k)
        julia_object_k = julia_object_k[:, DataFrames.Not(:Tfactor)]
        python_object_k = python_object_k[:, DataFrames.Not(:Tfactor)]
    end

    for col_name in names(julia_object_k)
        
        julia_test  = julia_object_k[!, col_name]
        julia_test  = length(julia_test) == 1  ? julia_test[1] : julia_test
        python_test = python_object_k[Symbol(col_name)]

        result = isequal(python_test, julia_test)
        
        if !result
            
            julia_test  = julia_test |> skipmissing |> collect
            python_test      = python_test |> skipmissing |> collect

            result_approx = isapprox(
                julia_test,
                python_test;
                atol = 1e-3
            )
            if !result_approx
                @show col_name
                @show eltype(julia_test)
                @show eltype(python_test)
                @show length(julia_test)
                @show length(python_test)
                @show maximum(abs.(julia_test .- python_test))
            end
            Test.@test result_approx
        else
            Test.@test result
        end
    end
end