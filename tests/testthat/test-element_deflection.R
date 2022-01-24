test_that("sum of element deflection is equal to overall deflection", {
    d <- get_deflection(act = "ceo", beh = "advise", obj = "benefactor", dictionary_key = "usfullsurveyor2015",
                        gender = "average", equation_key = "us2010")
    e <- element_deflection(act = "ceo", beh = "advise", obj = "benefactor", dictionary_key = "usfullsurveyor2015",
                            gender = "average", equation_key = "us2010") %>%
         summarise(d = sum(sqd_diff))
  expect_equal(d, e$d)
})
