
test_that("function replicates Interact", {
  d <- get_deflection(act = "brute", beh = "work", obj = "cook")
  d <- round(d$brute.d, digits = 1)
  expect_equal(d, 3.9)
})
