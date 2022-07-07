test_that("max confirm replicates interact", {
  event <-  inteRact::reshape_events_df(df = tibble(actor = c("abortionist", "adolescent"),
                                                    object = c("adolescent", "abortionist")),
                                        df_format = "wide",
                                        dictionary_key = "indiana2003",
                                        dictionary_gender = "male")

  events_nested <- event %>%
                   dplyr::group_by(event_id, event) %>%
                   tidyr::nest() %>%
                   dplyr::ungroup() %>%
                   dplyr::mutate(equation_key = c("nc1978","nc1978"),
                                 equation_gender = c("male", "male")) %>%
                   dplyr::mutate(opt_behavior = purrr::pmap_df(.l = .,
                                                                    .f = maximally_confirm_behavior))

  expect_equal(round(events_nested$opt_behavior$opt_E[1], digits = 2), -0.54)
  expect_equal(round(events_nested$opt_behavior$opt_P[1], digits = 2), 0.31)
  expect_equal(round(events_nested$opt_behavior$opt_A[1], digits = 2), -0.10)

  expect_equal(round(events_nested$opt_behavior$opt_E[2], digits = 2), 0.18)
  expect_equal(round(events_nested$opt_behavior$opt_P[2], digits = 2), -0.19)
  expect_equal(round(events_nested$opt_behavior$opt_A[2], digits = 2), 0.67)

})
