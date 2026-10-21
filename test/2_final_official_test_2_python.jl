Test.@testset "2 - Pierce Schott 2016" begin

    using ReadStatTables
    using Downloads
    using DataFrames
    using CSV
    using PyCall
    using OrderedCollections

    # Data loading
    csv_path = joinpath(@__DIR__, "data", "2_official_test_2_data.csv")
    data = CSV.read(
        csv_path,
        DataFrame
    )

    # Julia implementation
    test_2_julia = TwoWayFEWeights.twowayfeweights(
        data             = data,
        Y                = "Y",
        G                = "indusid",
        T                = "time",
        D                = "D",
        type             = "feTR",
        summary_measures = true
    )

    test_2_julia = OrderedCollections.OrderedDict(test_2_julia)

    # Python implementation
    py"""
    import pandas as pd
    from twowayfeweights import twowayfeweights as twfe

    data_python = pd.read_csv($csv_path)

    test_2_python = twfe(
        data    = data_python,
        Y       = 'Y',
        G       = 'indusid',
        T       = 'time',
        D       = 'D',
        type    = 'feTR',
        summary_measures = True
    )
    """

    test_2_python = py"test_2_python"
    test_2_python = test_2_python.to_dict()
    test_2_python = OrderedCollections.OrderedDict(test_2_python)

    # Compare Python and Julia results
    compare_python_julia(test_2_python, test_2_julia)

end