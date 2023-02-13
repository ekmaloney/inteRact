test_that("max confirm replicates interact Indiana", {
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
                   dplyr::group_by(event_id, event) %>%
                   dplyr::mutate(opt_behavior = purrr::pmap_df(.l = list(d = data,
                                                                         equation_gender = equation_gender,
                                                                         equation_key = equation_key),
                                                                    .f = maximally_confirm_behavior))

  expect_equal(round(events_nested$opt_behavior$opt_E[1], digits = 2), -0.54)
  expect_equal(round(events_nested$opt_behavior$opt_P[1], digits = 2), 0.31)
  expect_equal(round(events_nested$opt_behavior$opt_A[1], digits = 2), -0.10)

  expect_equal(round(events_nested$opt_behavior$opt_E[2], digits = 2), 0.18)
  expect_equal(round(events_nested$opt_behavior$opt_P[2], digits = 2), -0.19)
  expect_equal(round(events_nested$opt_behavior$opt_A[2], digits = 2), 0.67)

})


test_that("max confirm replicates interact Germany", {
  event <-  inteRact::reshape_events_df(df = tibble(actor = c("academic", "alcoholic"),
                                                    object = c("alcoholic", "academic")),
                                        df_format = "wide",
                                        dictionary_key = "germany2007",
                                        dictionary_gender = "male")

  events_nested <- event %>%
    dplyr::group_by(event_id, event) %>%
    tidyr::nest() %>%
    dplyr::ungroup() %>%
    dplyr::mutate(equation_key = c("germany2007","germany2007"),
                  equation_gender = c("all", "all")) %>%
    dplyr::group_by(event_id, event) %>%
    dplyr::mutate(opt_behavior = purrr::pmap_df(.l = list(d = data,
                                                          equation_gender = equation_gender,
                                                          equation_key = equation_key),
                                                .f = maximally_confirm_behavior))

  expect_equal(round(events_nested$opt_behavior$opt_E[1], digits = 2),  -0.13)
  expect_equal(round(events_nested$opt_behavior$opt_P[1], digits = 2), 1.57)
  expect_equal(round(events_nested$opt_behavior$opt_A[1], digits = 2), 0.17)

  expect_equal(round(events_nested$opt_behavior$opt_E[2], digits = 2), -2.15)
  expect_equal(round(events_nested$opt_behavior$opt_P[2], digits = 2), -0.92)
  expect_equal(round(events_nested$opt_behavior$opt_A[2], digits = 2), -0.10)

})
