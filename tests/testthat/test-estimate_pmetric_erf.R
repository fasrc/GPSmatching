test_that("estimate_pmetric_erf works as expected", {

  set.seed(6451)
  gnm_model <-  estimate_pmetric_erf(Y ~ w + cf5,
                            family = gaussian,
                            data = pseudo_pop_weight_test,
                            ci_appr = "weighting")
  expect_equal(gnm_model$coefficients[3][[1]], 2.576177, tolerance = 0.00001)
})
