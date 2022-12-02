test_that("optimal behavior replicates interact", {
  opt_behavior_example <- tibble::tibble(actor = "dyke",
                                         behavior = "beam_at",
                                         object = "gay")

  opt_behavior_df <- reshape_events_df(df = opt_behavior_example,
                                       df_format = "wide",
                                       dictionary_key = "indiana2003",
                                       dictionary_gender = "male")

  opt_b <- optimal_behavior(d = opt_behavior_df,
                            equation_key = "nc1978",
                            equation_gender = "male")


  expect_equal(round(opt_b$opt_E[1], digits = 2), 0.46)
  expect_equal(round(opt_b$opt_P[1], digits = 2), 0.96)
  expect_equal(round(opt_b$opt_A[1], digits = 2), 0.02)
  expect_equal(round(opt_b$opt_E[2], digits = 2), 0.43)
  expect_equal(round(opt_b$opt_P[2], digits = 2), -0.03)
  expect_equal(round(opt_b$opt_A[2], digits = 2), -0.27)
})
