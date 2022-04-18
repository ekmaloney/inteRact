test_that("sum of element deflection is equal to overall deflection", {

  d <- tibble::tibble(actor = "brute", behavior = "work", object = "cook")

  df <- reshape_events_df(df = d,
                         df_format = "wide",
                         dictionary_key = "nc1978",
                         dictionary_gender = "male")

  d <- get_deflection(df = df, equation_info = "nc1978_male")


    e <- element_deflection(df = df, equation_info = "nc1978_male") %>%
         dplyr::summarise(d = sum(sqd_diff))

    testthat::expect_equal(d, e$d)
})
