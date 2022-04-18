
test_that("get deflection replicates Interact", {

  d <- tibble(actor = "brute", behavior = "work", object = "cook")

  d <- reshape_events_df(df = d,
                         df_format = "wide",
                         dictionary_key = "nc1978", dictionary_gender = "male")

  d <- get_deflection(df = d, equation_info = "nc1978_male")

  d <- round(d, digits = 1)
  expect_equal(d, 1.9)
})
