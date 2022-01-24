
test_that("function replicates Interact", {
  d <- get_deflection(act = "brute",
                      beh = "work",
                      obj = "cook",
                      dictionary_key = "nc1978",
                      gender = "male",
                      equation_key = "nc1978")

  d <- round(d, digits = 1)
  expect_equal(d, 1.9)
})
