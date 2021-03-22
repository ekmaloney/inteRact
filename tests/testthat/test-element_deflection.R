test_that("sum of element deflection is equal to overall deflection", {
    d <- get_deflection("ceo", "advise", "benefactor")
    e <- element_deflection("ceo", "advise", "benefactor") %>%
         summarise(d = sum(sqd_diff))
  expect_equal(d$ceo.d, e$d)
})
