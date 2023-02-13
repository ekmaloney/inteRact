test_that("reidentify actor replicates interact.jar Indiana", {

  reidentify_actor_df <- tibble::tibble(actor = "graduate_student",
                      behavior = "gossip_with",
                      object = "friend")

  df <- reshape_events_df(df = reidentify_actor_df, df_format = "wide",
                         dictionary_key = "indiana2003",
                         dictionary_gender = "male")

  actor_id <- reidentify_actor(d = df,
                               equation_key = "nc1978",
                               equation_gender = "male")

  object_id <- reidentify_object(d = df,
                                 equation_key = "nc1978",
                                 equation_gender = "male")

  expect_equal(round(actor_id$E, digits = 2), -0.9)
  expect_equal(round(actor_id$P, digits = 2), -0.11)
  expect_equal(round(actor_id$A, digits = 2), 0.78)
})


test_that("reidentify actor replicates interact.jar US 2010", {

  reidentify_actor_df <- tibble::tibble(actor = "astronaut",
                                        behavior = "accommodate",
                                        object = "atheist")

  df <- reshape_events_df(df = reidentify_actor_df, df_format = "wide",
                          dictionary_key = "usfullsurveyor2015",
                          dictionary_gender = "all")

  actor_id <- reidentify_actor(d = df,
                               equation_key = "us2010",
                               equation_gender = "all")

  object_id <- reidentify_object(d = df,
                                 equation_key = "us2010",
                                 equation_gender = "all")

  expect_equal(round(actor_id$E, digits = 2), 0.33)
  expect_equal(round(actor_id$P, digits = 2), 1.46)
  expect_equal(round(actor_id$A, digits = 2), 0.08)

  expect_equal(round(object_id$E, digits = 2), 2.65)
  expect_equal(round(object_id$P, digits = 2), 0.02)
  expect_equal(round(object_id$A, digits = 2), 6.61, tolerance=1e-2)
})
