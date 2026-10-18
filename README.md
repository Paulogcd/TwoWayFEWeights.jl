# twowayfeweights.jl

[![Build Status](https://github.com/Paulogcd/twowayfeweights.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Paulogcd/twowayfeweights.jl/actions/workflows/CI.yml?query=branch%3Amain)

This package is the Julia translation of the R twowayfeweights package of the [ERC REALLYCREDIBLE Team](https://credible-answers.github.io), [available here](https://github.com/chaisemartinPackages/twowayfeweights).

It provides a set of functions to compute the two way fixed effects (TWFE) estimate of de Chaisemartin and D'Haultfoeuille (2020), [available here](https://www.aeaweb.org/articles?id=10.1257/aer.20181169).

# Performance and benchmark

The package is faster than the Stata and R versions, but slower than the python one.

A benchmark of the different versions of the twowayfeweights package is currently under developemnt [here](https://www.paulogcd.com/benchmark_twfew/).

# Features that are still to implement

- Harmonize documentation for utils (internal functions).
- Harmonize the display of message in the Julia REPL.

Website-Documentation: 
- Internal process
- Getting Started
- Benchmark

