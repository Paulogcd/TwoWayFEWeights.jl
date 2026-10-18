# Documentation

Documentation for TwoWayFEWeights.jl

```@docs
twowayfeweights(;
    data::DataFrames.DataFrame,
    Y::AbstractString,
    G::AbstractString,
    T::AbstractString,
    D::AbstractString,
    type::AbstractString = "feTR",
    D0::Union{AbstractString, Nothing} = nothing,
    summary_measures::Bool = false,
    controls::Union{AbstractVector{T}, Nothing} where {T<:AbstractString} = nothing,
    weights::Union{AbstractVector{T}, Nothing} where {T<:Real} = nothing,
    other_treatments::Union{AbstractVector{T}, Nothing} where {T<:AbstractString} = nothing,
    test_random_weights::Union{AbstractString, Nothing} = nothing,
    path::Union{AbstractString, Nothing} = nothing)
```