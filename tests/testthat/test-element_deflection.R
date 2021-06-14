test_that("sum of element deflection is equal to overall deflection", {
    d <- get_deflection("ceo", "advise", "benefactor", equation = "us")
    e <- element_deflection("ceo", "advise", "benefactor", equation = "us") %>%
         summarise(d = sum(sqd_diff))
  expect_equal(d$d, e$d)
})
