test_that("reidentify actor replicates interact.jar", {

  reidentify_actor_df <- tibble::tibble(actor = "graduate_student",
                      behavior = "gossip_with",
                      object = "friend")

  df <- reshape_events_df(df = reidentify_actor_df, df_format = "wide",
                         dictionary_key = "indiana2003",
                         dictionary_gender = "male")

  actor_id <- reidentify_actor(data = df,
                               equation_key = "nc1978",
                               equation_gender = "male")

  object_id <- reidentify_object(data = df,
                                 equation_key = "nc1978",
                                 equation_gender = "male")

  expect_equal(round(actor_id$E, digits = 2), -0.9)
  expect_equal(round(actor_id$P, digits = 2), -0.11)
  expect_equal(round(actor_id$A, digits = 2), 0.78)
})
