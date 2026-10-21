Test.@testset "1 - Wolfers 2006" begin

    using ReadStatTables
    using Downloads
    using DataFrames
    using CSV
    using PyCall
    using OrderedCollections

    # Download and load data in Julia
    url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Wolfers%202006/wolfers2006_didtextbook.dta"
    path = Downloads.download(url, "./wolfers2006_twfeweights.dta")
    data = ReadStatTables.readstat(path)
    data = DataFrames.DataFrame(data)

    # Load the same dataset in Python
    pd = pyimport("pandas")
    twfe = pyimport("twowayfeweights")

    data_python = pd.read_stata(path)

    # Julia implementation
    test_1_julia = TwoWayFEWeights.twowayfeweights(
        data                = data,
        Y                   = "div_rate",
        G                   = "state",
        T                   = "year",
        D                   = "rel_time1",
        type                = "feTR",
        D0                  = nothing,
        summary_measures    = true,
        controls            = ["rel_timeminus$(i)" for i in 1:9],
        weights             = data[!, :stpop],
        other_treatments    = ["rel_time$(i)" for i in 2:16],
        test_random_weights = "year",
        path                = nothing
    )
    test_1_julia = OrderedCollections.OrderedDict(test_1_julia)

    # Python implementation
    py"""
    import pandas as pd
    from twowayfeweights import twowayfeweights as twfe
    
    data_python = pd.read_stata($path)

    test_1_python = twfe(
        data    = data_python,
        Y       = 'div_rate',
        G       = 'state',
        T       = 'year',
        D       = 'rel_time1',
        type    = 'feTR',
        summary_measures = True,
        controls = [f'rel_timeminus{i}' for i in range(1, 10)],
        weights = 'stpop',
        other_treatments = [f'rel_time{i}' for i in range(2, 17)],
        test_random_weights = 'year'
    )
    """
    test_1_python = py"test_1_python"
    test_1_python = test_1_python.to_dict()
    test_1_python = OrderedCollections.OrderedDict(test_1_python)

    # Compare Python and Julia results
    compare_python_julia(test_1_python, test_1_julia)

    # Cleaning up
    rm(path)
end