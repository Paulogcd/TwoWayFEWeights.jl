# TwoWayFEWeights.jl

[![Build Status](https://github.com/Paulogcd/TwoWayFEWeights.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Paulogcd/TwoWayFEWeights.jl/actions/workflows/CI.yml?query=branch%3Amain)   <a href="https://www.paulogcd.com/TwoWayFEWeights.jl"><img src="https://img.shields.io/static/v1?label=TwoWayFEWeights&message=Docs&color=blue" alt="TwoWayFEWeights - Docs"></a> [![codecov](https://codecov.io/gh/Paulogcd/TwoWayFEWeights.jl/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Paulogcd/TwoWayFEWeights.jl)

This package is the Julia translation of the [ERC REALLYCREDIBLE Team](https://credible-answers.github.io) team R `twowayfeweights` package, [available here](https://github.com/chaisemartinPackages/twowayfeweights).

It provides a function (`twowayfeweights`) to compute the Two Way Fixed Effects (TWFE) estimate of de Chaisemartin and D'Haultfoeuille (2020), [available here](https://www.aeaweb.org/articles?id=10.1257/aer.20181169).

A [Documenter.jl](https://documenter.juliadocs.org/stable/)-based documentation website [is available here](https://www.paulogcd.com/TwoWayFEWeights.jl/dev/).

# First steps

## Installation

To install the package: 

```julia
using Pkg

# Via the official registry:
Pkg.add("TwoWayFEWeights")

# Or via the GitHub repository URL:
Pkg.add(url="https://github.com/Paulogcd/TwoWayFEWeights.jl")
```

The package has one external function, `twowayfeweights()` that allows 4 different computations, [explained in the original article](https://www.aeaweb.org/articles?id=10.1257/aer.20181169):

|  | Common Trend Assumption | Group treatment does not change over time |
|----|----|----|
| Fixed-Effects Regression  | feTR  | feS  |
| First Difference Regression  | fdTR  | fdS  |

## Example

For example, using the example dataset of [F. Vella and M. Verbeek (1998), “Whose Wages Do Unions Raise? A Dynamic Model of Unionism and Wage Rate Determination for Young Men”](https://www.jstor.org/stable/223257) (also used as the first example in the original R and Stata packages), we can compute a Fixed-Effects Regression with Common Trend (feTR) treating `lwage` as the outcome variable and `union` as the treatment variable.

```julia
# Package management
using TwoWayFEWeights
using Downloads
using ReadStatTables
using DataFrames

# Loading the data
url = "https://raw.githubusercontent.com/chaisemartinPackages/twowayfeweights/main/wagepan_twfeweights.dta"
path = Downloads.download(url, "./wagepan_twfeweights.dta")
wagepan = ReadStatTables.readstat(path)
wagepan = DataFrames.DataFrame(wagepan)

# Computation
result = twowayfeweights(
    data                = wagepan,
    Y                   = "lwage",
    G                   = "nr",
    T                   = "year",
    D                   = "union",
    type                = "feTR",
    summary_measures    = true,
    test_random_weights = "educ");
```

## Display

The `twowayfeweights` function returns an object of type `twowayfeweights`, which is a wrapper of the `OrderedCollections.OrderedDict` type with a specific show method, matching the original package result display. To see it, one can simply use the result variable name:

```julia
julia> result

┌ Info: 
│ Under the common trends assumption,
│ the TWFE coefficient beta, equal to 0.1066, estimates a weighted sum of 967 ATTs
│ 820 ATTs receive a positive weight, and 147 receive a negative weight.
│ 1016 (g,t) cells receive the treatment, but the ATTs of 49 cells receive a weight equal to zero.
│ 
│ 
│                Treatment matrix
│ ──────────────────────────────────────────────
│         Σ weights  Treat. var: union    ATTss
│            String            Float64  Float64
│ ──────────────────────────────────────────────
│  Positive weights              820.0   1.0105
│  Negative weights              147.0  -0.0105
│             Total              967.0      1.0
│ ──────────────────────────────────────────────
│ 
│ 
│ Summary Measures:
│  TWFE Coefficient β_fe: 0.10662746641838203
│    min σ(Δ) compatible with β_fe and Δ_TR = 0: 0.0968690958111648
│    min σ(Δ) compatible with treatment effect of opposite sign than β_fe in all (g,t) cells: 3.1758589231944727
│  Reference: Corollary 1, de Chaisemartin, C, and D'Haultfoeille, X (2020a)
│ 
│ Regression of variables possibly correlated with the treatment effect on the weights:
│ ┌───────────┬───────────┬──────────┬─────────────┐
│ │      Coef │        SE │   t-stat │ Correlation │
│ │   Float64 │   Float64 │  Float64 │     Float64 │
│ ├───────────┼───────────┼──────────┼─────────────┤
│ │ -0.134455 │ 0.0713602 │ -1.88418 │   -0.118259 │
│ └───────────┴───────────┴──────────┴─────────────┘
│ 
│ 
└ The development of the original packages (R and Stata) was funded by the European Union (ERC, REALLYCREDIBLE,GA N. 101043899).
```

> Note: running the `twowayfeweights()` function without a semicolon at its end will automatically display.

The `twowayfeweights` type can be converted to a `OrderedCollections.OrderedDict` type object with the homonymous function `OrderedCollections.OrderedDict()`such as:

```julia
>julia OrderedCollections.OrderedDict(result)

OrderedDict{Any, Any} with 16 entries:
  :nr_plus          => 820
  :nr_minus         => 147
  :nr_weights       => 967
  :sum_plus         => 1.01053
  :sum_minus        => -0.010529
  :dat_result       => 4360×3 DataFrame…
  :beta             => 0.106627
  :sensibility      => 0.0968691
  :mat              => 1×4 DataFrame…
  :sensibility2     => 3.17586
  :tot_cells        => 1016
  :type             => "feTR"
  :params           => OrderedDict{Symbol, Union{Nothing, String}}(:Y=>"lwage", :G=>"nr", :T=>"year", :D=>"union", :D0=>nothing)
  :summary_measures => true
  :other_treatments => nothing
  :random_weights   => "RW_educ"
```

## Result export

Using the `path` keyword will save the weight values associated with each (G,T) cell:

```julia
result = twowayfeweights(
    data                = wagepan,
    Y                   = "lwage",
    G                   = "nr",
    T                   = "year",
    D                   = "union",
    type                = "feTR",
    summary_measures    = true,
    test_random_weights = "educ"
    path                = "weights.csv");
```

# Performance and benchmark

The package is faster than the Stata and R versions, but slower than the python one.

A benchmark of the different versions of the twowayfeweights package is currently under developemnt (GitHub repository [available here](https://github.com/Paulogcd/benchmark_twfew) and results [available here](https://www.paulogcd.com/benchmark_twfew/)).

# Features that are still to implement

- Harmonize documentation for utils (internal functions).
- Harmonize the display of message in the Julia REPL.

Website-Documentation: 
- Internal process
- Getting Started
- Benchmark

