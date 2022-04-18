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
                   dplyr::mutate(eq_info = c("nc1978_male","nc1978_male")) %>%
                   dplyr::mutate(opt_behavior = purrr::map2(data, eq_info, maximally_confirm_behavior))

  expect_equal(round(events_nested$opt_behavior[[1]]$opt_E, digits = 2), -0.54)
  expect_equal(round(events_nested$opt_behavior[[1]]$opt_P, digits = 2), 0.31)
  expect_equal(round(events_nested$opt_behavior[[1]]$opt_A, digits = 2), -0.10)

  expect_equal(round(events_nested$opt_behavior[[2]]$opt_E, digits = 2), 0.18)
  expect_equal(round(events_nested$opt_behavior[[2]]$opt_P, digits = 2), -0.19)
  expect_equal(round(events_nested$opt_behavior[[2]]$opt_A, digits = 2), 0.67)

})
