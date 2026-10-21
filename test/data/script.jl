# This file contains different functions that could help for a local test workflow.
# They download the different datasets of the official test suite and save them in ./test/data.
# Almost all modifications to the downloaded datasets were done by Anzony Quispe of the ERC REALLYCREDIBLE Team,
# thanks to whom I could greatly improve the testing suite of the package against the R results.

function data_official_test_1_download()
    url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Wolfers%202006/wolfers2006_didtextbook.dta"
    destination = joinpath(@__DIR__, "2_official_test_1_data.dta")
    Downloads.download(url, destination)
end

function data_official_test_2_download()
    url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Pierce%20and%20Schott%202016/pierce_schott_didtextbook.dta"
    path = Downloads.download(url, "./pierce_schott_twfeweights.dta")
    data = ReadStatTables.readstat(path)
    data = DataFrames.DataFrame(data)

    data_1 = DataFrames.DataFrame(indusid = data.indusid, time = 1, Y = 0, D = 0)
    data_2 = DataFrames.DataFrame(indusid = data.indusid, time = 2, Y = data.delta2001, D = data.ntrgap)
    data = [data_1; data_2]
    
    CSV.write("./test/data/2_official_test_2_data.csv", data)
end

function original_data_official_test_3_download()
    url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Gentzkow%20et%20al%202011/gentzkowetal_didtextbook.RData"
    path = Downloads.download(url, "./gentzkowetal_twfeweights.dta")
    obj = RData.load(path)
    data = obj["df"]
    data = DataFrames.DataFrame(data)
    RCall.@rput data

    # Credit: Anzony Quispe of the ERC REALLYCREDIBLE Team.
    RCall.rcopy(R"
        df <- fastDummies::dummy_cols(data, select_columns = 'styr', remove_first_dummy = FALSE)
        df <- fastDummies::dummy_cols(df, select_columns = 'styr',
                remove_first_dummy = FALSE,
                remove_selected_columns = FALSE)
        
        # Crear dummies
        styr_dummies <- model.matrix(~factor(df$styr) - 1)
        colnames(styr_dummies) <- paste0('styr_', levels(factor(df$styr)))
        styr_cols <- paste0('styr_', levels(factor(df$styr)))
        
        # Unirlas al dataframe original
        df <- cbind(df, styr_dummies)
        utils::write.csv(df, file.path('.', 'test', 'data', '2_official_test_3_data_original.csv'), row.names = FALSE)
    ")
end

# This function attempts to reproduce in a simpler way the
# previous data manipulation. It does not work, as the final
# output are different. It would be nice to be able to do
# this data manipulation in Julia, to be sure to understand
# the operations.
function alternative_data_official_test_3_download()
    url = "https://raw.githubusercontent.com/anzonyquispe/did_book/main/cc_xd_didtextbook_2025_9_30/Data%20sets/Gentzkow%20et%20al%202011/gentzkowetal_didtextbook.RData"
    path = Downloads.download(path, "./gentzkowetal_twfeweights_alternative.dta")
    obj = RData.load(path)
    data = obj["df"]
    data = DataFrames.DataFrame(data)
    RCall.@rput data

    RCall.rcopy(R"
        df <- data
        df <- cbind(
        df,
        model.matrix(~ factor(styr) - 1, data = df) |>
            as.data.frame() |>
            setNames(paste0(\"styr_\", levels(factor(df$styr))))
        )

        utils::write.csv(
            df,
            \"./test/data/2_official_test_3_data_original.csv\",
            row.names = FALSE
        )
    ")
    data = RCall.rcopy(R"df")
    CSV.write("./test/data/2_official_test_3_data_alternative.csv", data)
end

# Shows differences for now.
function test_3_comparison()
    original = CSV.read("./test/data/2_official_test_3_data_original.csv", DataFrames.DataFrame)
    alternative = CSV.read("./test/data/2_official_test_3_data_alternative.csv", DataFrames.DataFrame)

    for col in names(original)
        test_resultat = original[!, col] == alternative[!, col]
        if test_resultat
            print("No problem with ", col, "\n")
        else
            print("Problem wit ", col, "\n")
        end
    end

    names(original) == names(alternative)

end

function test_data_prepare()
    data_official_test_1_download()
    data_official_test_2_download()
    original_data_official_test_3_download()
end