test_that("modify identity replicates interact.jar", {

  mi <- tibble::tibble(actor_modifier = "adventurous",
                       actor = "juror")

  mi_reshaped <- reshape_events_df(df = mi,
                                   df_format = "wide",
                                   dictionary_key = "indiana2003",
                                   dictionary_gender = "male")

  mod_id <- modify_identity(data = mi_reshaped,
                            equation_key = "nc1978",
                            equation_gender = "male")


  expect_equal(round(mod_id$estimate[1], digits = 2), 0.9)
  expect_equal(round(mod_id$estimate[2], digits = 2), 1.73)
  expect_equal(round(mod_id$estimate[3], digits = 2), 1.28)
})
