Test.@testset "4 - Gentzkow et al. 2011" begin

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

    # Construct control variable names in Julia
    styr_cols = ["styr_" * string(x) for x in sort(unique(skipmissing(data.styr)))]

    # Julia implementation
    test_4_julia = TwoWayFEWeights.twowayfeweights(
        data     = data,
        Y        = "prestout",
        G        = "cnty90",
        T        = "year",
        D        = "numdailies",
        type     = "feTR",
        controls = styr_cols
    )

    test_4_julia = OrderedCollections.OrderedDict(test_4_julia)

    # Python implementation
    py"""
    import pandas as pd
    from twowayfeweights import twowayfeweights as twfe

    data_python = pd.read_csv($csv_path)

    styr_cols = [
        f"styr_{x}"
        for x in sorted(data_python["styr"].dropna().unique())
    ]

    test_4_python = twfe(
        data    = data_python,
        Y       = 'prestout',
        G       = 'cnty90',
        T       = 'year',
        D       = 'numdailies',
        type    = 'feTR',
        controls = styr_cols
    )
    """

    test_4_python = py"test_4_python"
    test_4_python = test_4_python.to_dict()
    test_4_python = OrderedCollections.OrderedDict(test_4_python)

    # Compare Python and Julia results
    compare_python_julia(test_4_python, test_4_julia)

end;