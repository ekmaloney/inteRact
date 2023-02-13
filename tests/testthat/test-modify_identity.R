test_that("modify identity replicates interact.jar Indiana", {

  mi <- tibble::tibble(actor_modifier = "adventurous",
                       actor = "juror")

  mi_reshaped <- reshape_events_df(df = mi,
                                   df_format = "wide",
                                   dictionary_key = "indiana2003",
                                   dictionary_gender = "male")

  mod_id <- modify_identity(d = mi_reshaped,
                            equation_key = "nc1978",
                            equation_gender = "male")


  expect_equal(round(mod_id$estimate[1], digits = 2), 0.9)
  expect_equal(round(mod_id$estimate[2], digits = 2), 1.73)
  expect_equal(round(mod_id$estimate[3], digits = 2), 1.28)
})

test_that("modify identity replicates interact.jar US Full Surveyor", {

  mi <- tibble::tibble(actor_modifier = "drunken",
                       actor = "agnostic")

  mi_reshaped <- reshape_events_df(df = mi,
                                   df_format = "wide",
                                   dictionary_key = "usfullsurveyor2015",
                                   dictionary_gender = "all")

  mod_id <- modify_identity(d = mi_reshaped,
                            equation_key = "nc1978",
                            equation_gender = "male")


  expect_equal(round(mod_id$estimate[1], digits = 2), -0.57)
  expect_equal(round(mod_id$estimate[2], digits = 2), -1.02)
  expect_equal(round(mod_id$estimate[3], digits = 2), 0.58)
})


test_that("modify identity replicates interact.jar Garmany", {

  mi <- tibble::tibble(actor_modifier = "american",
                       actor = "academic")

  mi_reshaped <- reshape_events_df(df = mi,
                                   df_format = "wide",
                                   dictionary_key = "germany2007",
                                   dictionary_gender = "male")

  mod_id <- modify_identity(d = mi_reshaped,
                            equation_key = "germany2007",
                            equation_gender = "male")


  expect_equal(round(mod_id$estimate[1], digits = 2), -0.24)
  expect_equal(round(mod_id$estimate[2], digits = 2), 1.17)
  expect_equal(round(mod_id$estimate[3], digits = 2), 1.05)
})
