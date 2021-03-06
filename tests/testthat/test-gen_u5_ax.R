library(data.table)

# test input
dt <- data.table::data.table(
  age_start = rep(c(0, 1, 5), 3),
  age_end = rep(c(1, 5, 10), 3),
  mx = c(0.09, 0.12, 0.08, 0.11, 0.14, 0.05, 0.4, 0.3, 0.07),
  sex = rep(c("male", "female", "both"), each = 3),
  location = rep("Canada", 9)
)
setorderv(dt, c("sex", "age_start"))

# expected output
expected <- copy(dt)
expected$ax <- c(0.34000, 1.35650, NA,
                 0.35000, 1.36100, NA,
                 0.28656, 1.39756, NA)

test_that("test that `gen_u5_ax` gives expected output", {
  test_dt <- copy(dt)
  gen_u5_ax(test_dt, id_cols = c("age_start", "age_end", "sex", "location"))
  setorderv(test_dt, c("sex", "age_start"))
  setcolorder(test_dt, c("age_start", "age_end", "mx", "sex", "location", "ax"))
  testthat::expect_equivalent(test_dt, expected, tolerance = 0.001)
})

test_that("test that `gen_u5_ax` gives errors when it should", {
  test_dt <- copy(dt)
  testthat::expect_error(gen_u5_ax(test_dt, id_cols = c("age_start", "age_end",
                                                   "sex", "year")))
  testthat::expect_error(gen_u5_ax(test_dt[age_start != 0],
                                   id_cols = c("age_start", "age_end", "sex")))
})

test_that("test that `gen_u5_ax` modifies in place", {
  test_dt <- copy(dt)
  mem1 <- pryr::address(test_dt) # memory address before
  gen_u5_ax(test_dt, id_cols = c("age_start", "age_end", "sex", "location"))
  mem2 <- pryr::address(test_dt) # memory address after
  testthat::expect_equal(mem1, mem2)
})
