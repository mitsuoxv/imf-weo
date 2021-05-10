test_that("output_data prepares appropriate download data", {
  name_current <- "2104"
  df <- tibble::tibble(
    ref_area = c(rep("112", 3), rep("122", 3)),
    year = rep(1980:1982, 2),
    value = c(11:13, 31:33)
  )
  
  name_prev <- "2010"
  df_prev <- tibble::tibble(
    ref_area = c(rep("112", 3), rep("122", 3)),
    year = rep(1980:1982, 2),
    value = c(1:3, 21:23)
  )
  
  prev <- "No"
  data <- output_data(prev, df, df_prev, name_current, name_prev)
  expect_data <- tibble::tibble(
    year = 1980:1982,
    `United Kingdom` = 11:13,
    Austria = 31:33
  )
  expect_equal(data, expect_data)
  
  prev <- "Yes"
  data <- output_data(prev, df, df_prev, name_current, name_prev)
  expect_data <- tibble::tibble(
    year = 1980:1982,
    `United Kingdom_2104` = 11:13,
    Austria_2104 = 31:33,
    `United Kingdom_2010` = 1:3,
    Austria_2010 = 21:23
  )
  expect_equal(data, expect_data)
})
