test_that("print_lastactual creates expected HTML", {
  m_area <- tibble::tibble(
    code = c("112", "122"),
    area = c("United Kingdom", "Austria")
  )
  
  df <- tibble::tibble(
    ref_area = c(rep("112", 3), rep("122", 2))
  )
  
  df$lastactualdate <- c(rep(2020, 3), rep(2019, 2))
  expect_snapshot(print_lastactual(df, m_area))
  
  df$lastactualdate <- c(rep(2020, 3), rep(NA_integer_, 2))
  expect_snapshot(print_lastactual(df, m_area))
  
  df$lastactualdate <- c(rep(NA_integer_, 3), rep(2019, 2))
  expect_snapshot(print_lastactual(df, m_area))

  df$lastactualdate <- c(rep(NA_integer_, 3), rep(NA_integer_, 2))
  expect_snapshot(print_lastactual(df, m_area))
})

test_that("print_note creates expected HTML", {
  df <- tibble::tibble(
    ref_area = c(rep("112", 3), rep("122", 2))
  )
  
  df$notes <- c(rep("See notes for: xxx", 3), rep("See notes for: xxx", 2))
  expect_snapshot(print_note(df))
  
  df$notes <- c(rep("See notes for: xxx", 3), rep(NA_character_, 2))
  expect_snapshot(print_note(df))
  
  df$notes <- c(rep(NA_character_, 3), rep("See notes for: xxx", 2))
  expect_snapshot(print_note(df))

  df$notes <- c(rep(NA_character_, 3), rep(NA_character_, 2))
  expect_snapshot(print_note(df))
})
