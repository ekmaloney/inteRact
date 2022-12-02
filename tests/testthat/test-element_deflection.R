test_that("sum of element deflection is equal to overall deflection", {

  d <- tibble::tibble(actor = "brute", behavior = "work", object = "cook")

  df <- reshape_events_df(df = d,
                         df_format = "wide",
                         dictionary_key = "nc1978",
                         dictionary_gender = "male")

  d <- get_deflection(d = df, equation_key = "nc1978",
                      equation_gender = "male")


    e <- element_deflection(d = df,
                            equation_key = "nc1978",
                            equation_gender = "male") %>%
         dplyr::summarise(d = sum(sqd_diff))

    testthat::expect_equal(d, e$d)
})
