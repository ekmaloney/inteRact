test_that("reidentify object replicates interact.jar", {
  reidentify_object_df <- tibble::tibble(actor = "graduate_student",
                                        behavior = "gossip_with",
                                        object = "friend")

  df <- reshape_events_df(df = reidentify_object_df, df_format = "wide",
                          dictionary_key = "indiana2003",
                          dictionary_gender = "male")

  object_id <- reidentify_object(d = df,
                                 equation_key = "nc1978",
                                 equation_gender = "male")

  expect_equal(round(object_id$E, digits = 2), -1.01)
  expect_equal(round(object_id$P, digits = 2), 0.36)
  expect_equal(round(object_id$A, digits = 2), 0.12)
})
