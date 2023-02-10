
test_that("get deflection replicates Interact - NC 1978", {

  d <- tibble(actor = "brute", behavior = "work", object = "cook")

  d <- reshape_events_df(df = d,
                         df_format = "wide",
                         dictionary_key = "nc1978", dictionary_gender = "male")

  d <- get_deflection(d = d, equation_key = "nc1978",
                      equation_gender = "male")

  d <- round(d, digits = 1)
  expect_equal(d, 1.9)
})


test_that("get deflection replicates Interact - Canada", {

  d <- tibble(actor = "academic", behavior = "accommodate", object = "accomplice")

  d <- reshape_events_df(df = d,
                         df_format = "wide",
                         dictionary_key = "ontario2001", dictionary_gender = "male")

  d <- get_deflection(d = d, equation_key = "canada1985",
                      equation_gender = "male")

  d <- round(d, digits = 1)
  expect_equal(d, 0.6)
})

test_that("get deflection replicates Interact - Egypt", {

  d <- tibble(actor = "abortionist", behavior = "abuse", object = "adolescent")

  d <- reshape_events_df(df = d,
                         df_format = "wide",
                         dictionary_key = "egypt2015",
                         dictionary_gender = "all")

  d <- get_deflection(d = d,
                      equation_key = "egypt2014",
                      equation_gender = "all")

  d <- round(d, digits = 1)
  expect_equal(d, 8.5)
})
