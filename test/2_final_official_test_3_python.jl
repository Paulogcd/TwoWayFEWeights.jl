Test.@testset "3 - Gentzkow et al. 2011" begin

    using ReadStatTables
    using Downloads
    using DataFrames
    using CSV
    using PyCall
    using OrderedCollections

    # Data loading
    csv_path = joinpath(
        @__DIR__,
        "data",
        "2_official_test_3_data_original.csv"
    )

    data = CSV.read(csv_path, DataFrame)

    # Julia implementation
    styr_cols = ["styr_" * string(x) for x in sort(unique(data.styr))]

    test_3_julia = TwoWayFEWeights.twowayfeweights(
        data     = data,
        Y        = "changeprestout",
        G        = "cnty90",
        T        = "year",
        D        = "changedailies",
        D0       = "numdailies",
        type     = "fdTR",
        controls = styr_cols
    )

    test_3_julia = OrderedCollections.OrderedDict(test_3_julia)

    # Python implementation
    py"""
    import pandas as pd
    from twowayfeweights import twowayfeweights as twfe

    data_python = pd.read_csv($csv_path)

    styr_cols = [
        f"styr_{x}"
        for x in sorted(data_python["styr"].dropna().unique())
    ]

    test_3_python = twfe(
        data=data_python,
        Y='changeprestout',
        G='cnty90',
        T='year',
        D='changedailies',
        D0='numdailies',
        type='fdTR',
        controls=styr_cols
    )
    """
    test_3_python = py"test_3_python"
    test_3_python = test_3_python.to_dict()
    test_3_python = OrderedCollections.OrderedDict(test_3_python)

    # Compare Python and Julia results
    compare_python_julia(test_3_python, test_3_julia)

end